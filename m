Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab3EVJC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 05:02:28 -0400
Received: from gatzka.org ([85.214.228.118]:39489 "EHLO mail.gatzka.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139Ab3EVJCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 05:02:23 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 22 May 2013 10:53:38 +0200
From: Stephan Gatzka <stephan.gatzka@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        linux1394-devel@lists.sourceforge.net, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: function call =?UTF-8?Q?fw=5Fiso=5Fresource=5Fmange=28=2E=2E?=
 =?UTF-8?Q?=29=20=28core-iso=2Ec=29=20does=20not=20return?=
Reply-To: stephan.gatzka@gmail.com
Mail-Reply-To: stephan.gatzka@gmail.com
In-Reply-To: <20130521231346.1fec9142@stein>
References: <8ac7ca3200325ddf85ba57aa6d000f70@gatzka.org>
 <519BA6AC.1080600@hurleysoftware.com> <20130521231346.1fec9142@stein>
Message-ID: <d12dc75ae4092c04a3594cc8a5374927@gatzka.org>
User-Agent: Roundcube Webmail/0.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I am a friend of the self-ID-complete worklet, for two reasons:
>   - Even if there was no need for the TI TSB41BA3D workaround (e.g. 
> even
>     if we simply stopped supporting TSB41BA3D), it would still be
>     worthwhile to have at least the self-ID-complete IRQ BH performed 
> in
>     a non-atomic context.  We should try to move as much of the
>     firewire-core self-ID-complete handler as possible out of the 
> currently
>     spinlock protected section in order make more of this stuff
>     preemptible and replace a few GFP_ATOMIC slab allocations by 
> GFP_NOFS
>     ones.  (Could be GFP_KERNEL in absence of firewire-sbp2.)
>     I would have liked to work on this already long ago, but such is 
> life.
>   - How do you propose to access the PHY registers without sleeping?
>     Or more to the point:  How do you propose to mix sleeping and
>     non-sleeping PHY register accesses?  (Since we can't get rid of
>     the sleeping ones.)  If the accesses are not fully serialized, you 
> will
>     get corrupt PHY reg reads or writes.  If they are fully serialized, 
> the
>     non-sleeping PHY reg accesses need to go a try-lock route and will 
> be
>     forced to error out during periods when a sleeping PHY reg access 
> goes
>     on, without even the ability to reschedule if it is done in a 
> tasklet
>     context.

I totally agree.

Stephan
