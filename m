Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab3KGU2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 15:28:19 -0500
Received: from smtprelay0059.hostedemail.com ([216.40.44.59]:40770 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753794Ab3KGU2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 15:28:12 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:538:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2828:2904:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3870:3872:3874:4321:5007:6119:6120:7652:7875:8603:8957:9165:10004:10400:10429:10430:10431:10848:10967:11026:11232:11658:11914:12043:12517:12519:12555:12663:12681:12740:13069:13095:13311:13357:13870:19903:19997,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: form18_d384aefcdd1c
X-Filterd-Recvd-Size: 2419
Message-ID: <1383856098.9263.28.camel@joe-AO722>
Subject: Re: [RFC PATCH] hda_intel: ratelimit "spurious response" message
From: Joe Perches <joe@perches.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel <alsa-devel@alsa-project.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 07 Nov 2013 12:28:18 -0800
In-Reply-To: <s5h61s4dkqs.wl%tiwai@suse.de>
References: <1383854115.9263.21.camel@joe-AO722>
	 <s5h61s4dkqs.wl%tiwai@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-11-07 at 21:23 +0100, Takashi Iwai wrote:
> At Thu, 07 Nov 2013 11:55:15 -0800,
> Joe Perches wrote:
> > 
> > dmesg here has a 100+ consecutive lines of:
> > 
> > [ 1464.219446] hda-intel 0000:00:14.2: spurious response 0x0:0x0, last cmd=0x170500
> > [ 1464.219451] hda-intel 0000:00:14.2: spurious response 0x0:0x0, last cmd=0x170500
> > [ 1464.219454] hda-intel 0000:00:14.2: spurious response 0x0:0x0, last cmd=0x170500
> > ...
> > 
> > Ratelimit the message to reduce the dmesg log noise.
> > 
> > Coalesce the format while at it.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> Thanks, applied.
> 
> BTW, which hardware shows this problem?
> I'm interested rather in that...

It's a little Acer netbook AO725

# lspci -v -v -s0:14.2
00:14.2 Audio device: Advanced Micro Devices, Inc. [AMD] FCH Azalia Controller (rev 01)
	Subsystem: Acer Incorporated [ALI] Device 0740
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 46
	Region 0: Memory at f0240000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 41b3
	Kernel driver in use: snd_hda_intel


