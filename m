Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630Ab3EJHF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 03:05:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:32579 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825Ab3EJHF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 03:05:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,646,1363158000"; 
   d="scan'208";a="334718048"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "Wei, Gang" <gang.wei@intel.com>
Subject: RE: [PATCH 4/4] driver: provide sysfs interfaces to access SMX
 parameter
Thread-Topic: [PATCH 4/4] driver: provide sysfs interfaces to access SMX
 parameter
Thread-Index: AQHOSvE+ysMfIHdI9EqG5gcExdaKwpj6wt+AgAMpG0A=
Date: Fri, 10 May 2013 07:05:53 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE9AC926@SHSMSX102.ccr.corp.intel.com>
References: <1367938519-840-1-git-send-email-qiaowei.ren@intel.com>
	 <1367938519-840-5-git-send-email-qiaowei.ren@intel.com>
 <1367990697.2425.33.camel@x230>
In-Reply-To: <1367990697.2425.33.camel@x230>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4A766cr020623

On 2013-05-08, Matthew Garrett wrote:
> On Tue, 2013-05-07 at 22:55 +0800, Qiaowei Ren wrote:
>
> > +What:		/sys/devices/platform/intel_txt/parameter/acm_max_size
> > +Date:		May 2013
> > +KernelVersion:	3.9
> > +Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
> > +Description:	The "acm_max_size" property will show max size of
> > +		authenticated code execution area.
> 
> What would userspace use this for?

These sysfs files are just export SMX & TXT related information to userspace. So that other developers (or OSV & ISV) can be able to develop txt related applications or tools based on these information.

> > +What:		/sys/devices/platform/intel_txt/parameter/acm_mem_types
> > +Date:		May 2013
> > +KernelVersion:	3.9
> > +Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
> > +Description:	The "acm_max_types" property will show external memory
> > +		types supported during AC mode.
> 
> Or this? And what's AC mode?

It means that the property will show supportable memory types for memory mapped outside of the authenticated code execution area.

> > +	__asm__ __volatile__ (IA32_GETSEC_OPCODE "\n"
> > +			      : "=a"(eax), "=b"(ebx), "=c"(ecx)
> > +			      : "a"(IA32_GETSEC_PARAMETERS), "b"(index));
> > +
> > +	*param_type = eax & 0x1f;
> > +	*peax = eax;
> > +	*pebx = ebx;
> > +	*pecx = ecx;
> 
> Should there be a check for failure here? Is it possible for this operation to fail?

You mean GETSEC instruction? I don't notice related description in manual. Next function get_parameters() will process return eax/ebx/ecx returned by this instruction.

> > +	write_cr4(read_cr4() | CR4_SMXE);
> 
> Whoo. This needs at least a giant comment and probably some locking, but if
> this is supposed to be set during runtime then it should be done in core
> architecture code rather than just in this driver.

Oh. This code should be removed, because tboot code have set SMXE bit.

Thanks,
Qiaowei

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
