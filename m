Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750994AbaKXUfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 15:35:23 -0500
Received: from mail-1.atlantis.sk ([80.94.52.57]:38754 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaKXUfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 15:35:22 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/3] wd719x: Introduce Western Digital WD7193/7197/7296 PCI SCSI card driver
Date: Mon, 24 Nov 2014 21:34:43 +0100
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
References: <1416831074-24282-1-git-send-email-linux@rainbow-software.org> <1416831074-24282-3-git-send-email-linux@rainbow-software.org> <54732F83.6070306@suse.de>
In-Reply-To: <54732F83.6070306@suse.de>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201411242134.43508.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 November 2014 14:15:47 Hannes Reinecke wrote:
> On 11/24/2014 01:11 PM, Ondrej Zary wrote:
> > Introduce wd719x, a driver for Western Digital WD7193, WD7197 and WD7296
> > PCI SCSI controllers based on WD33C296A chip.
> > Tested with WD7193 card.
> >
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

[...]

> > +	result = wd719x_send_scb(scb);
> > +	if (result != DID_OK) {
> > +		dev_warn(&wd->pdev->dev, "can't queue SCB\n");
> > +		wd719x_finish_cmd(cmd, result);
> > +	}
> > +
> > +	spin_unlock_irqrestore(wd->sh->host_lock, flags);
> > +
> > +	return 0;
> > +}
>
> Why did you use 'wait_ready' here?
> Any sane HBA driver should set the queue depth parameters
> correctly to avoid this from happening.
> Wouldn't it be far better to just return HOST_BUSY here if
> the command register isn't free and submit the command
> directly otherwise?

It probably comes from the original driver. Will send a new version.

-- 
Ondrej Zary
