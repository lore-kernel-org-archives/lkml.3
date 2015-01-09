Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230AbbAIWAY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 17:00:24 -0500
Received: from mail-qg0-f46.google.com ([209.85.192.46]:37541 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbbAIWAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 17:00:21 -0500
Date: Fri, 9 Jan 2015 17:00:18 -0500
From: Tejun Heo <tj@kernel.org>
To: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: SATA link power management issues
Message-ID: <20150109220018.GH2785@htj.dyndns.org>
References: <3352987.ugV1Ipy7Z5@xps13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3352987.ugV1Ipy7Z5@xps13>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Gabriele.

On Thu, Jan 08, 2015 at 08:37:35PM +0100, Gabriele Mazzotta wrote:
> I'm having some problems with the link_power_management_policy on my
> Dell XPS13 9333.
> Changing policy from min_power or medium_power to max_performance
> causes the following errors:
> 
> [ 3955.667086] ahci 0000:00:1f.2: port does not support device sleep
> [ 3958.257106] ata3.00: exception Emask 0x10 SAct 0x40 SErr 0x50000 action 0xe frozen
> [ 3958.257110] ata3.00: irq_stat 0x00400000, PHY RDY changed
> [ 3958.257113] ata3: SError: { PHYRdyChg CommWake }
> [ 3958.257116] ata3.00: failed command: READ FPDMA QUEUED
> [ 3958.257120] ata3.00: cmd 60/00:30:c8:60:10/01:00:1d:00:00/40 tag 6 ncq 131072 in
>          res 40/00:34:c8:60:10/00:00:1d:00:00/40 Emask 0x10 (ATA bus error)
> [ 3958.257122] ata3.00: status: { DRDY }
> [ 3958.257126] ata3: hard resetting link
> [ 3958.981727] ata3: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [ 3958.984994] ata3.00: configured for UDMA/133
> [ 3958.997686] ahci 0000:00:1f.2: port does not support device sleep

Ah, it actually happens.

> [ 3958.997698] ata3: EH complete
> 
> Sometimes I get "failed command: WRITE FPDMA QUEUED" multiple times.
> 
> As far as I know, this had always happened and it was confirmed
> by another user. I've also come across some logs of the same system
> and saw the same errors here and there, so it shouldn't be a problem
> of my laptop in particular.
> 
> What I find interesting is that transitions from min_power to
> medium_power and vice versa do not cause these errors. There are only
> problem switching from min_power and medium_power to max_performance.
> Doing the opposite, i.e. from max_performance to min_power or
> medium_power, seems to work fine.
> 
> As a consequence of these continuous errors, the speed is reduced
> from 6.0 Gbps to 1.5 Gbps.

Always?  Or does it sometimes get lucky and stabilize at a higher
speed?

> I'd prefer not to disable LPM as it saves a considerable amount of
> power when I'm using the battery. For this reason I'm currently using
> medium_power and min_power only to prevent errors.
> 
> Is it normal that these errors appears only when I switch to
> max_performance? Was something similar observed on other systems?

It's not normal.  It definitely doesn't happen with all devices.  I
guess it could be a quirk from the device side.  What's on the other
side of the connector?  Can you post the full kernel log after such
incidence?

Thanks.

-- 
tejun
