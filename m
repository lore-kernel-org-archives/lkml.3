Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500Ab3EJBuQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 21:50:16 -0400
Received: from mga14.intel.com ([143.182.124.37]:23492 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392Ab3EJBuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 21:50:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,645,1363158000"; 
   d="scan'208";a="331715976"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "Wei, Gang" <gang.wei@intel.com>
Subject: RE: [PATCH 3/4] driver: provide sysfs interfaces to access TXT log
Thread-Topic: [PATCH 3/4] driver: provide sysfs interfaces to access TXT log
Thread-Index: AQHOSvE9bxnf/3s/7UWUo8Zw/n8iKpj6wJAAgAG87bCAAEa7AIAA4+Kw
Date: Fri, 10 May 2013 01:50:05 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE9AC797@SHSMSX102.ccr.corp.intel.com>
References: <1367938519-840-1-git-send-email-qiaowei.ren@intel.com>
	 <1367938519-840-4-git-send-email-qiaowei.ren@intel.com>
	 <1367990202.2425.26.camel@x230>
	 <9E0BE1322F2F2246BD820DA9FC397ADE9A9BD2@SHSMSX102.ccr.corp.intel.com>
 <1368100938.2425.36.camel@x230>
In-Reply-To: <1368100938.2425.36.camel@x230>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4A1ohAo019895

On 2013-05-09, Matthew Garrett wrote:
> On Thu, 2013-05-09 at 08:05 +0000, Ren, Qiaowei wrote:
> > On 2013-05-08, Matthew Garrett wrote:
> > > How different are these logs to the TPM measurements exported via
> > > securityfs?
> >
> > These logs come from tboot (Trusted Boot, an open source, pre-kernel/VMM
> module that uses IntelÂ® Trusted Execution Technology (IntelÂ® TXT) to perform a
> measured and verified launch of an OS kernel/VMM.), and should be different
> from those TPM measurements (from BIOS?) exported via security.
> 
> Different in what way? What are they actually logging?

Tboot log should also contain txt heap memory content, a lot of event log, etc.

> > > So I write a value here and then I see different chunks of log? This
> > > doesn't seem like an optimal interface. What do these logs actually
> > > contain? How do I know which block I should be reading?
> >
> > Yes. Since total log size is bigger than one page 4K, the log have to be
> displayed in 4K-block indexed by block_index.
> > These logs will be very helpful for txt related debugging.
> 
> If they're only intended for debugging then sysfs probably isn't the best place
> for them. debugfs might make more sense.

Yes. Debugfs seems to be better choice. Maybe we need to further consider the purpose of outputting tboot log. So I will temporarily remove this feature from this patch.

Thanks,
Qiaowei

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
