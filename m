Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697Ab3ENWXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 18:23:37 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:50316 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758537Ab3ENWXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 18:23:35 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.03.1305141547180.31158@syhkavp.arg>
References: <1367602547-19322-1-git-send-email-will.deacon@arm.com>
	<1367602547-19322-2-git-send-email-will.deacon@arm.com>
	<20130506231554.GB16801@amd.pavel.ucw.cz>
	<5188B8B2.5030601@arm.com>
	<alpine.LFD.2.03.1305141547180.31158@syhkavp.arg>
Date: Tue, 14 May 2013 17:23:35 -0500
Message-ID: <CAL_Jsq+Q5UMGo3J+vKKCRU+w4Kj0YN0exs7UCWTEOxmFjWfo3g@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] ARM: delay: print dummy values for bogomips
From: Rob Herring <robherring2@gmail.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Pavel Machek <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 2:54 PM, Nicolas Pitre <nico@fluxnic.net> wrote:
> [ Yes, I'm late to the party ]
>
> On Tue, 7 May 2013, Marc Zyngier wrote:
>
>> On 07/05/13 00:16, Pavel Machek wrote:
>>
>> Hi Pawel,
>>
>> >> Now that we support a timer-backed delay loop, I'm quickly getting sick
>> >> and tired of people complaining that their beloved bogomips value has
>> >> decreased. You know who you are!
>> >
>> >> Unfortunately, we can't just remove the entry from /proc/cpuinfo, as it
>> >> will likely break fragile userspace code which is parsing that stuff, so
>> >> instead replace it with a dummy value that can be chosen in the
>> >> Kconfig.
>> >
>> > So, instead of removing it you silently report invalid value? Note
>>
>> Removing it would be an ABI breakage. Unfortunately.
>
> Did you really write this with a straight face?
>
>> Name one userspace application that extracts meaningful information out
>> of the BogoMIPS field. Just one.
>
> Waitaminute... Didn't you just claim this would be an ABI break?
>
> So if no application can be found, where is the ABI breakage?

lscpu

But that is already "broken" on ARM because x86 uses "bogomips" and
ARM uses "BogoMIPS". I agree reporting BogoMIPS is silly, but there
are more differences between x86 and ARM. Somewhat meaningful fields
like "cpu MHz" are missing on ARM for example. These are mainly useful
for h/w inventory use which server folks tend to care about.

> This thread must be a joke.  Please just kill the damn thing out of
> /proc/cpuinfo and see if any application notices.  And if some do then
> they are already broken *today* and should be fixed.

And please do so for all arches then.

Rob
