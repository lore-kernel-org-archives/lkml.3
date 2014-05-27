Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbaE0Std (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:49:33 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:57414 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbaE0Stb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:49:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Stanislav Meduna <stano@meduna.org>, Corey Minyard <cminyard@mvista.com>,
        linux-rt-users@vger.kernel.org, minyard@acm.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: Set hardirq tracing to on when idling
Date: Tue, 27 May 2014 20:49:27 +0200
Message-ID: <4475199.26Fs5MKAfh@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5384BF89.6010509@meduna.org>
References: <1401045323-7116-1-git-send-email-minyard@acm.org> <4559339.apo3Fd10HK@wuerfel> <5384BF89.6010509@meduna.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ZLRKxKVzkyOwR0OEF+QzBUmnEwVQTOiY08E5Vy8M/TB
 iCnyqQM+NfOHXzgfeSQYVX9Qn3ilBaKM1omwX2GxwsnMIKos6h
 BdzAdiWt47Spg7cARxE0U8H3YNsa0T4fv7EABwr2Xobi1rs7JI
 2KWm2e/M74v49oVF0mhVdOHwOAqqxD0bjNLiBA8lFkXvT/BA54
 hGcndn78xL9PRygbf6r2WiUmIdpNrV0Af2n6jF17d+YnWHNa8F
 Jdzb6PXo+Ts83EJeVrGjWnN82z8IUNm3E+rZszrC1qEnp2RXCL
 zeMsI29C2xlEfbUQKnAxHKlID1yQoSEASyOREQi/wJiDyuJegn
 69yggpg8hbioTwCXf83U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 May 2014 18:38:33 Stanislav Meduna wrote:
> On 26.05.2014 11:26, Arnd Bergmann wrote:
> 
> > It seems like the right thing to do, I just don't understand
> > why nobody hit this before.
> 
> Looks like this is what I did hit a month ago and
> was not able to find the culprit:
> http://www.spinics.net/lists/linux-rt-users/msg11656.html

Ok, so you get a 2.2ms latency on i.mx28 here, which comes
from exactly the same code location, and is quite alarming
by itself, but much less so than the 4 second latency that
Corey is seeing. This could just be an artifact of i.mx28
not staying idle for as long as vexpress.

> > How exactly do you see this manifest? If it's clear
> > that the trace comes from the idle function, maybe
> > everybody just ignores it?
> 
> That was definitely what I did 

You also commented in that thread about stop_critical_timings()/
start_critical_timings(). Corey, can you look at that, too? I
think it's designed to avoid the issue you are seeing but
for some reason doesn't.

Maybe the problem is that the tracing infrastructure gets confused
when the irq_disable() happens in a different function from
irq_enable().

	Arnd
