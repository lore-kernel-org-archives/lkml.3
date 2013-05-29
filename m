Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965997Ab3E2MQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 08:16:42 -0400
Received: from smtp.citrix.com ([66.165.176.89]:45403 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965895Ab3E2MQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 08:16:41 -0400
X-IronPort-AV: E=Sophos;i="4.87,763,1363132800"; 
   d="scan'208";a="27956061"
Message-ID: <51A5F1A6.6080204@citrix.com>
Date: Wed, 29 May 2013 13:16:38 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: <xen-devel@lists.xen.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] x86: increase precision of x86_platform.get/set_wallclock()
References: <1368467768-2316-1-git-send-email-david.vrabel@citrix.com> <1368467768-2316-2-git-send-email-david.vrabel@citrix.com> <51A54939.10905@linaro.org>
In-Reply-To: <51A54939.10905@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/05/13 01:18, John Stultz wrote:
> On 05/13/2013 10:56 AM, David Vrabel wrote:
>> From: David Vrabel <david.vrabel@citrix.com>
>>
>> All the virtualized platforms (KVM, lguest and Xen) have persistent
>> wallclocks that have more than one second of precision.
>>
>> read_persistent_wallclock() and update_persistent_wallclock() allow
>> for nanosecond precision but their implementation on x86 with
>> x86_platform.get/set_wallclock() only allows for one second precision.
>> This means guests may see a wallclock time that is off by up to 1
>> second.
>>
>> Make set_wallclock() and get_wallclock() take a struct timespec
>> parameter (which allows for nanosecond precision) so KVM and Xen
>> guests may start with a more accurate wallclock time and a Xen dom0
>> can maintain a more accurate wallclock for guests.
>>
>> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
>> ---
>>   arch/x86/include/asm/mc146818rtc.h |    4 ++--
>>   arch/x86/include/asm/x86_init.h    |    6 ++++--
>>   arch/x86/kernel/kvmclock.c         |    9 +++------
>>   arch/x86/kernel/rtc.c              |   17 +++++++----------
>>   arch/x86/lguest/boot.c             |    4 ++--
>>   arch/x86/platform/efi/efi.c        |   10 ++++++----
>>   arch/x86/xen/time.c                |   19 ++++++-------------
>>   include/linux/efi.h                |    4 ++--
> 
> Just FYI, David: You missed the vrtc code with this conversion.
> 
> I finally got around to pushing my current queue to my public tree and
> the kbuild robot noticed the build failure (required INTEL_MID config to
> trigger).
> 
> The fix I've queued is here:
> https://git.linaro.org/gitweb?p=people/jstultz/linux.git;a=commitdiff;h=52d8e9cc6718ae9e6c44b7723028e4717ba91c8b;hp=1dd5234774b33a17743ae62e8b46b5cd0059e1c7

Oops. Sorry about that.  That fix looks fine.

David
