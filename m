Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab3LUBwn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 20:52:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50099 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab3LUBwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 20:52:41 -0500
Message-ID: <52B4F421.2000403@zytor.com>
Date: Fri, 20 Dec 2013 17:51:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: joeyli <jlee@suse.com>
CC: Matthew Garrett <matthew.garrett@nebula.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "samer.el-haj-mahmoud@hp.com" <samer.el-haj-mahmoud@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "Elliott@hp.com" <Elliott@hp.com>, "werner@suse.com" <werner@suse.com>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "oneukum@suse.de" <oneukum@suse.de>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "trenn@suse.de" <trenn@suse.de>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "JBeulich@suse.com" <JBeulich@suse.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "matt@console-pimps.org" <matt@console-pimps.org>
Subject: Re: [RFC PATCH 06/14] rtc-efi: register rtc-efi device when EFI enabled
References: <1387439515-8926-1-git-send-email-jlee@suse.com>	 <1387439515-8926-7-git-send-email-jlee@suse.com>	 <20131219140918.GF3145@console-pimps.org>	 <1387513491.3539.4345.camel@linux-s257.site> <52B3C7F8.3040901@zytor.com>	 <20131220103755.GA14784@pd.tnic> <1387552463.17961.2.camel@x230>	 <52B4B0ED.7030600@zytor.com> <1387589042.3539.4901.camel@linux-s257.site>
In-Reply-To: <1387589042.3539.4901.camel@linux-s257.site>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2013 05:24 PM, joeyli wrote:
> 於 五，2013-12-20 於 13:04 -0800，H. Peter Anvin 提到：
>>
>> Actually, it doesn't have to reprogram the clock ... it just needs to
>> know if another OS has already done so.  All Linux needs to do is to be
>> able to derive UTC from whatever the RTC is set to and to be able to
>> keep it consistent.
>>
> 
> It's dependent on a right boot initial priority of distribution.

-ENOPARSE

> Here have a discussion of adjusting system clock by TZ (from ACPI or
> UEFI):
> Discussion on BIOS/CMOS/UEFI clock in local time
> 	http://www.spinics.net/lists/util-linux-ng/msg07639.html
> 
> and,
> from Ted Ts'o in the mail thread
>      https://lkml.org/lkml/2008/1/8/195
> 
> If kernel use the TZ field from ACPI TAD or EFI to adjust system
> clock when booting, then it can avoid buggy distributions adjust
> system clock AFTER e2fsck is run.
> 
> Using ACPI TAD should after DSDT parsing in subsystem initial stage,
> so I choice EFI time services before we can move DSDT parser to
> start_kernel().
> 

Yes, of course.  That is irrelevant to needing to reprogram the clock,
though.

My argument is very simple: if we have to rely on EFI, we can get the
offset in the boot stub before ExitBootServices(), and then simply never
change it.  That way we still pick up if another operating system has
changed it, and it will still reflect the proper UTC time.

	-hpa


