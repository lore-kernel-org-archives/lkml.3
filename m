Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbaBNHvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 02:51:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49504 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbaBNHvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 02:51:18 -0500
Message-ID: <52FDCAB0.2090509@zytor.com>
Date: Thu, 13 Feb 2014 23:50:08 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stefani Seibold <stefani@seibold.net>
CC: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, ak@linux.intel.com,
        aarcange@redhat.com, john.stultz@linaro.org, luto@amacapital.net,
        xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Subject: Re: [PATCH v15 0/10] Add 32 bit VDSO time function support
References: <1392237483-6421-1-git-send-email-stefani@seibold.net>	 <52FDBC16.10101@zytor.com> <1392364081.1034.6.camel@wall-e.seibold.net>
In-Reply-To: <1392364081.1034.6.camel@wall-e.seibold.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2014 11:48 PM, Stefani Seibold wrote:
> Am Donnerstag, den 13.02.2014, 22:47 -0800 schrieb H. Peter Anvin:
>> Hi,
>>
>> I tried this patchset, but it fails to compile on i386 "make allyesconfig".
>>
>> 	-hpa
>>
> 
> I tried "make allyseconfig" on my i386, but the resulting config will
> always set CONFIG_X86_64=y, so it fails with

"make ARCH=i386 allyesconfig"

... will do it for you.

> scripts/mod/empty.c:1:0: error: CPU you selected does not support x86-64
> instruction set
> 
> Setting to CONFIG_X86_32 by hand will allow to compile but fails in
> vclock_gettime.c, because CONFIG_PARAVIRT_CLOCK is not supported for by
> a 32 bit VDSO.

Right, this is the problem here.  Keep in mind many shipping kernels
will have CONFIG_PARAVIRT_CLOCK enabled, so it matters that a PV kernel
*booting native* doesn't take an unnecessary hit.

> PARAVIRT_CLOCK and getcpu is an other topic which is not addressed by
> this patch set.
> 
> I will do a patch to fix this.

Thanks.

	-hpa


