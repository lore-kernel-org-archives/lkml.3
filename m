Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab3LaVZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 16:25:28 -0500
Received: from [65.19.176.90] ([65.19.176.90]:36925 "EHLO srv.ahhyes.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756459Ab3LaVZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 16:25:27 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 01 Jan 2014 08:24:08 +1100
From: Alex <xor@xor.bz>
To: <linux-kernel@vger.kernel.org>
Subject: Re: TSC Problems (warp between CPUs)
In-Reply-To: <e44ff95b0f7962a11cfcdb83da6c5595@xor.bz>
References: <b65bbca027bb2a473f989e60871c2dd2@xor.bz>
 <fcade74fbf715ff965b5a1d3b21e2c21@xor.bz>
 <20131228143547.38d0a0b9@alan.etchedpixels.co.uk>
 <e44ff95b0f7962a11cfcdb83da6c5595@xor.bz>
Message-ID: <5d63695a1ad08aea5673a833e5055c6b@xor.bz>
User-Agent: Roundcube Webmail/0.8.4
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: xor@xor.bz
X-SA-Exim-Scanned: No (on srv.ahhyes.net); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A Happy new year to all :)

Just wondering whether anyone has any ideas on how I could force the 
TSC to resync?

Starting to get a bit desperate. The motherboard manufacturers support 
is useless.... They keep telling me to install Windows *groan*. I dont 
think there is any easy way to expose what clock source the OS is using 
even in windows.

I even tried firing an email at the AmiBios guys. I think I have 
exhausted every avenue of help as far as the hardware goes.

Any suggestions?

Kind regards,
Alex

On 2013-12-29 11:21, Alex wrote:
> On 2013-12-29 01:35, One Thousand Gnomes wrote:
>>> not guaranteed to be precise. For example a SMI (System Management
>>> Interrupt) could interrupt the software flow that is attempting to 
>>> write
>>> the time-stamp counter immediately prior to the WRMSR. This could 
>>> mean
>>> the value written to the TSC could vary by thousands to millions of
>>> clocks.
>>
>> Yes SMI is a disaster area for any real time activity (and many 
>> other
>> things ;) ), but many systems actually make little use of it, 
>> especially
>> once the USB is owned by the OS.
>>
>> For synchronization you can retry the sync if it isn't within an
>> acceptable range. The odds of getting an SMI mid sync setup should 
>> be
>> very very low, so the odds of repeating the failure several times 
>> should
>> be negligible and after a few tries you could give up and assume the
>> hardware is buggered then fall back to HPET.
>
> Hi Alan,
>
> The sync retry sounds like an interesting strategy but is outside my 
> knowledge
> scope as a regular end user (I do have a reasonable understanding of
> C and can patch+
> recompile) but I lack the architecture knowledge to implement a patch
> to do this.
>
> Any suggestions?

-- 
Kind Regards,
Alex.
