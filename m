Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbaFKJg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:36:28 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37926 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaFKJg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 05:36:26 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 11 Jun 2014 11:36:16 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] firewire: ohci: enable MSI for VIA VT6315 rev 1,
 drop cycle timer quirk
Message-ID: <20140611113616.5fc973f1@kant>
In-Reply-To: <20140611112525.67b06fb4@kant>
References: <20140416010100.786a4c04@stein>
	<20140416010808.2ab9d416@stein>
	<20140611112525.67b06fb4@kant>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 11 Stefan Richter wrote:
> Nice -- yesterday, just a few days after this patch went into the
> mainline, this VT6315 card suddenly stopped to generate any interrupt
> while being in use with a soundcard and jackd.  Until then it ran
> perfectly for many days, with jackd+ffado's combined workload of
> AT/AR/IT/IR but also with SBP-2 workloads and one or another other
> application as well.
> 
> Now I apparently need to run long-term tests with MSI switched off in order
> to find out whether this malfunction is MSI related.

PS, this is the state of the card just now after this failure:

10:00.0 FireWire (IEEE 1394): VIA Technologies, Inc. VT6315 Series Firewire Controller (rev 01) (prog-if 10 [OHCI])
        Subsystem: VIA Technologies, Inc. VT6315 Series Firewire Controller
        Flags: bus master, fast devsel, latency 0, IRQ 74

$ grep "74:" /proc/interrupts 
 74:  132906417   17969317   15309448   18166551   42716375   33292391   30609551   28301206   PCI-MSI-edge      firewire_ohci

I am used to defective MSI support manifesting itself right after driver
initialization, not after long periods of use with, say, 319271256 proper
interrupts before it goes belly-up.  And indeed, the issue with VT6315
rev 0 was an instantaneous malfunction, not a rare and random one
(http://linux.derkeiler.com/Mailing-Lists/Kernel/2010-12/msg02301.html).
I wonder what's up with my VT6315 rev 1.
-- 
Stefan Richter
-=====-====- -==- -=-==
http://arcgraph.de/sr/
