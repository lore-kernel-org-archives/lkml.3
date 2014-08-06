Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbaHFM4F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 08:56:05 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:39034 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755850AbaHFM4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 08:56:00 -0400
Date: Wed, 6 Aug 2014 13:55:50 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mattis Lorentzon <Mattis.Lorentzon@autoliv.com>
Cc: Fredrik Noring <fredrik.noring@autoliv.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Oops: 17 SMP ARM (v3.16-rc2)
Message-ID: <20140806125550.GO30282@n2100.arm.linux.org.uk>
References: <C4A61A5CA4AD2246942F4BA6F20ACB804356534D@ALVA-EXMB04.alv.autoliv.int> <20140626140115.GQ32514@n2100.arm.linux.org.uk> <C4A61A5CA4AD2246942F4BA6F20ACB80435655E9@ALVA-EXMB04.alv.autoliv.int> <20140626151424.GT32514@n2100.arm.linux.org.uk> <20140627112151.GF32514@n2100.arm.linux.org.uk> <3FFB61A7A8473C49831AF20FA193534A43CADFA7@ALVA-EXMB01.alv.autoliv.int> <20140627163108.GP32514@n2100.arm.linux.org.uk> <C4A61A5CA4AD2246942F4BA6F20ACB8043575072@ALVA-EXMB04.alv.autoliv.int> <20140806095012.GN30282@n2100.arm.linux.org.uk> <C4A61A5CA4AD2246942F4BA6F20ACB8043575172@ALVA-EXMB04.alv.autoliv.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C4A61A5CA4AD2246942F4BA6F20ACB8043575172@ALVA-EXMB04.alv.autoliv.int>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 11:10:06AM +0000, Mattis Lorentzon wrote:
> Russell,
> 
> > What is on the other end of the link?
> 
> 16 ARM cards connected to a 3Com Switch 4400 connected to a Linux FC 20
> machine (Intel Corporation 82541PI Gigabit Ethernet Controller rev 05).
> 
> There may be multiple problems. The backtrace has only been seen a few
> times, on two different cards. Most of the time, the network for a random
> card just stalls without any visible backtrace or error messages. The other
> cards seem to be unaffected when this happens.

Can you ascertain whether these stalls are a result of some failure of the
receive side or the transmit side - you should be able to tell that if you
watch the packet counts via ifconfig on the stalled card.  Also, it would
be useful to know whether the FEC interrupt was firing.

I hope you have some kind of serial console on these cards?

> > What I would like to do is to stamp each packet in some way with an
> > identifier marking its ring position, and then monitor the network to find out
> > whether the packet at slot 85 was actually transmitted - that's made slightly
> > harder because packets may be dropped at the receiver when operating in
> > promisc mode.  This would then allow us to work out some likely causes.
> 
> We would be glad to run this test on our setup, do you have more detailed
> information on how to set it up?

One of the problems is to find some way to stamp each packet with a 10-bit
number without having any side effects.  I guess one possibility would be
to overwrite the source MAC address on transmit, which hopefully should not
cause any side effects.

> After a network stall, we usually have to powercycle the ARM hardware to
> get it back to a usable state. These stalls last at least several minutes,
> perhaps indefinitely. It does not seem to recover properly, and is no longer
> reachable via the network.

Hmm.  Okay, I think the first thing we need to do is to work out why
the silent stalls are happening.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
