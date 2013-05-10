Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab3EJDiM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 23:38:12 -0400
Received: from mga14.intel.com ([143.182.124.37]:50288 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab3EJDiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 23:38:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,645,1363158000"; 
   d="scan'208";a="331750844"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "Wei, Gang" <gang.wei@intel.com>
Subject: RE: [PATCH 1/4] driver: add TXT driver in kernel
Thread-Topic: [PATCH 1/4] driver: add TXT driver in kernel
Thread-Index: AQHOSvE9AcunBqr7IUa9oxQD3ESIK5j6kqOAgAIFqdA=
Date: Fri, 10 May 2013 03:38:05 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE9AC855@SHSMSX102.ccr.corp.intel.com>
References: <1367938519-840-1-git-send-email-qiaowei.ren@intel.com>
	 <1367938519-840-2-git-send-email-qiaowei.ren@intel.com>
 <1367980339.2425.7.camel@x230>
In-Reply-To: <1367980339.2425.7.camel@x230>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4A3cKG7020253

On 2013-05-08, Matthew Garrett wrote:
> On Tue, 2013-05-07 at 22:55 +0800, Qiaowei Ren wrote:
> 
> > + * This module is expected to be a better tool to access below
> > + resources
> 
> Expected to be or is? :)

"is" :)

> > + * Data is currently found below
> 
> You're adding it to ABI, so it shouldn't just be current - are you planning on
> moving it at any point? Is this functionality that should be under securityfs
> instead?
> 
> > +	txt_pdev = platform_device_register_simple(DEV_NAME, -1, NULL, 0);
> 
> This will register even if there's no TXT support on the platform, right? Is there
> no mechanism for determining whether a platform has TXT support before
> registering a device?
> 
> > +module_init(txt_sysfs_init);
> > +module_exit(txt_sysfs_exit);
> 
> And you've got no module aliases, so this will never be autoloaded. How does
> the OS know that the platform implements TXT?

Currently this driver only depends on CONFIG_INTEL_TXT, which is the kernel option for enabling Intel TXT support. And there is no explicit interface to check whether txt is supported in this txt enabling part of kernel. But since the tboot code will detect whether the platform actually supports Intel TXT, and so tboot_enabled() in include/linux/tboot.h may be used to determine whether a platform has TXT support.

In fact, we may also check CPU feature ECX[6] (SMX) for this purpose.

Thanks,
Qiaowei

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
