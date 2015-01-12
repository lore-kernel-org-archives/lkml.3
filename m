Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbbALRHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 12:07:41 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:43453 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbbALRHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 12:07:39 -0500
Date: Mon, 12 Jan 2015 12:07:34 -0500
From: Tejun Heo <tj@kernel.org>
To: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: SATA link power management issues
Message-ID: <20150112170734.GA22156@htj.dyndns.org>
References: <3352987.ugV1Ipy7Z5@xps13>
 <1437237.yiFxI2gUSM@xps13>
 <20150112131602.GX25319@htj.dyndns.org>
 <3361938.rq9uq9yRiO@xps13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3361938.rq9uq9yRiO@xps13>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Gabriele.

On Mon, Jan 12, 2015 at 06:03:41PM +0100, Gabriele Mazzotta wrote:
> I tried it and got the same result:
> 
> [  451.077463] ahci 0000:00:1f.2: port does not support device sleep
> [  452.162451] ata3.00: exception Emask 0x10 SAct 0x400 SErr 0x50000 action 0xe frozen
> [  452.162461] ata3.00: irq_stat 0x00400008, PHY RDY changed
> [  452.162467] ata3: SError: { PHYRdyChg CommWake }
> [  452.162473] ata3.00: failed command: WRITE FPDMA QUEUED
> [  452.162484] ata3.00: cmd 61/58:50:98:7c:4b/00:00:17:00:00/40 tag 10 ncq 45056 out
>          res 40/00:54:98:7c:4b/00:00:17:00:00/40 Emask 0x10 (ATA bus error)
> [  452.162489] ata3.00: status: { DRDY }
> [  452.162497] ata3: hard resetting link
> [  452.886958] ata3: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [  452.890384] ata3.00: configured for UDMA/133
> [  452.902976] ahci 0000:00:1f.2: port does not support device sleep
> [  452.903002] ata3: EH complete

Hah, that's weird.  Can you please double check that you're actually
running the patched kernel by throwing in a printk around the
commented out section?  If leaving phy irqs turned off doesn't make
the problem go away, I'm not sure there's much we can do.  Hmmm... one
option could be holding off speed-down verdict after LPM state
transition, but it looks like the ssd in question is misbehaving
pretty badly.

Thanks.

-- 
tejun
