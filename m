Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493Ab3L2AWf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 19:22:35 -0500
Received: from [65.19.176.90] ([65.19.176.90]:18386 "EHLO srv.ahhyes.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751047Ab3L2AWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 19:22:34 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sun, 29 Dec 2013 11:21:19 +1100
From: Alex <xor@xor.bz>
To: <linux-kernel@vger.kernel.org>
Subject: Re: TSC Problems (warp between CPUs)
In-Reply-To: <20131228143547.38d0a0b9@alan.etchedpixels.co.uk>
References: <b65bbca027bb2a473f989e60871c2dd2@xor.bz>
 <fcade74fbf715ff965b5a1d3b21e2c21@xor.bz>
 <20131228143547.38d0a0b9@alan.etchedpixels.co.uk>
Message-ID: <e44ff95b0f7962a11cfcdb83da6c5595@xor.bz>
User-Agent: Roundcube Webmail/0.8.4
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: xor@xor.bz
X-SA-Exim-Scanned: No (on srv.ahhyes.net); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-12-29 01:35, One Thousand Gnomes wrote:
>> not guaranteed to be precise. For example a SMI (System Management
>> Interrupt) could interrupt the software flow that is attempting to 
>> write
>> the time-stamp counter immediately prior to the WRMSR. This could 
>> mean
>> the value written to the TSC could vary by thousands to millions of
>> clocks.
>
> Yes SMI is a disaster area for any real time activity (and many other
> things ;) ), but many systems actually make little use of it, 
> especially
> once the USB is owned by the OS.
>
> For synchronization you can retry the sync if it isn't within an
> acceptable range. The odds of getting an SMI mid sync setup should be
> very very low, so the odds of repeating the failure several times 
> should
> be negligible and after a few tries you could give up and assume the
> hardware is buggered then fall back to HPET.

Hi Alan,

The sync retry sounds like an interesting strategy but is outside my 
knowledge
scope as a regular end user (I do have a reasonable understanding of C 
and can patch+
recompile) but I lack the architecture knowledge to implement a patch 
to do this.

Any suggestions?

-- 
Kind Regards,
Alex.

