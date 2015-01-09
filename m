Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbbAIWuL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 17:50:11 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:48126 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbbAIWuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 17:50:08 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: SATA link power management issues
Date: Fri, 09 Jan 2015 23:50:05 +0100
Message-ID: <1437237.yiFxI2gUSM@xps13>
In-Reply-To: <20150109220253.GI2785@htj.dyndns.org>
References: <3352987.ugV1Ipy7Z5@xps13> <20150109220018.GH2785@htj.dyndns.org> <20150109220253.GI2785@htj.dyndns.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 January 2015 17:02:53 Tejun Heo wrote:
> On Fri, Jan 09, 2015 at 05:00:18PM -0500, Tejun Heo wrote:
> > It's not normal.  It definitely doesn't happen with all devices.  I
> > guess it could be a quirk from the device side.  What's on the other
> > side of the connector?  Can you post the full kernel log after such
> > incidence?
> 
> What happens if you comment out the DIPM part of ata_eh_set_lpm() -
> the first ata_for_each_dev() loop in the function?

I commented the first loop and something seems to have changed.
I was able to get back to max_performance with no errors once, but
most of the times I get errors.
The last policy change here below went fine for instance:

[   32.368603] setting min_power
[   32.368670] ahci 0000:00:1f.2: port does not support device sleep
[   38.550840] setting max_performance
[   38.564932] ahci 0000:00:1f.2: port does not support device sleep
[   38.579716] ata3: exception Emask 0x10 SAct 0x0 SErr 0x50000 action 0xe frozen
[   38.579722] ata3: irq_stat 0x00400000, PHY RDY changed
[   38.579726] ata3: SError: { PHYRdyChg CommWake }
[   38.579731] ata3: hard resetting link
[   39.301543] ata3: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[   39.304783] ata3.00: configured for UDMA/133
[   39.317499] ahci 0000:00:1f.2: port does not support device sleep
[   39.317509] ata3: EH complete
[   46.412652] setting min_power
[   46.412769] ahci 0000:00:1f.2: port does not support device sleep
[   53.869869] setting max_performance
[   53.885083] ahci 0000:00:1f.2: port does not support device sleep
[   53.898857] ata3: exception Emask 0x10 SAct 0x0 SErr 0x50000 action 0xe frozen
[   53.898865] ata3: irq_stat 0x00400000, PHY RDY changed
[   53.898870] ata3: SError: { PHYRdyChg CommWake }
[   53.898877] ata3: hard resetting link
[   54.621720] ata3: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[   54.624864] ata3.00: configured for UDMA/133
[   54.637674] ahci 0000:00:1f.2: port does not support device sleep
[   54.637680] ata3: EH complete
[   58.837307] setting min_power
[   58.837427] ahci 0000:00:1f.2: port does not support device sleep
[   63.269078] setting max_performance
[   63.284571] ahci 0000:00:1f.2: port does not support device sleep
[   63.297954] ata3: exception Emask 0x10 SAct 0x0 SErr 0x50000 action 0xe frozen
[   63.297958] ata3: irq_stat 0x00400000, PHY RDY changed
[   63.297961] ata3: SError: { PHYRdyChg CommWake }
[   63.297966] ata3: hard resetting link
[   64.021185] ata3: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[   64.024291] ata3.00: configured for UDMA/133
[   64.037206] ahci 0000:00:1f.2: port does not support device sleep
[   64.037214] ata3: EH complete
[   69.282264] setting min_power
[   69.282320] ahci 0000:00:1f.2: port does not support device sleep
[   74.933589] setting max_performance
[   74.945847] ahci 0000:00:1f.2: port does not support device sleep
