Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab3LTVGO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 16:06:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47898 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201Ab3LTVGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 16:06:08 -0500
Message-ID: <52B4B0ED.7030600@zytor.com>
Date: Fri, 20 Dec 2013 13:04:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>,
        "bp@alien8.de" <bp@alien8.de>
CC: "samer.el-haj-mahmoud@hp.com" <samer.el-haj-mahmoud@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jlee@suse.com" <jlee@suse.com>,
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
References: <1387439515-8926-1-git-send-email-jlee@suse.com>	 <1387439515-8926-7-git-send-email-jlee@suse.com>	 <20131219140918.GF3145@console-pimps.org>	 <1387513491.3539.4345.camel@linux-s257.site> <52B3C7F8.3040901@zytor.com>	 <20131220103755.GA14784@pd.tnic> <1387552463.17961.2.camel@x230>
In-Reply-To: <1387552463.17961.2.camel@x230>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2013 07:14 AM, Matthew Garrett wrote:
> On Fri, 2013-12-20 at 11:37 +0100, Borislav Petkov wrote:
>> On Thu, Dec 19, 2013 at 08:30:48PM -0800, H. Peter Anvin wrote:
>>> On 12/19/2013 08:24 PM, joeyli wrote:
>>>> I agreed, but userspace application should not be too often to access
>>>> RTC. Maybe only when system boot and set timezone.
>>>
>>> This is, quite frankly, an idiotic argument.
>>
>> TBH, I've been struggling with the question too - and it might even be a
>> stupid question - but what is that absolute need to be able to get the
>> TZ in userspace? Why should I care?
>>
>> Can we get some use cases for stupid people like me please?
> 
> Dual-boot environments will tend to have the RTC in local time, not UTC.
> That means that userspace has to reprogram the clock over daylight
> savings changes, and to do that it must know whether another OS has
> already done so.
> 

Actually, it doesn't have to reprogram the clock ... it just needs to
know if another OS has already done so.  All Linux needs to do is to be
able to derive UTC from whatever the RTC is set to and to be able to
keep it consistent.

	-hpa

