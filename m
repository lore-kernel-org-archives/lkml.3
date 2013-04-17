Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966816Ab3DQWCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 18:02:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37224 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965728Ab3DQWC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 18:02:28 -0400
Date: Wed, 17 Apr 2013 15:02:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>,
        LKML-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [Patch 1/1] cciss: bug fix, prevent cciss from loading in kdump
 kernel
Message-Id: <20130417150227.8608817c009dad51cb5983b1@linux-foundation.org>
In-Reply-To: <20130415175906.GA16955@beardog.cce.hp.com>
References: <20130415175906.GA16955@beardog.cce.hp.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Apr 2013 12:59:06 -0500 Mike Miller <mike.miller@hp.com> wrote:

> Patch 1/1
> 
> If hpsa is selected as the Smart Array driver cciss may try to load in the
> kdump kernel. When this happens kdump fails and a core file cannot be created.
> This patch prevents cciss from trying to load in this scenario. This effects
> primarily older Smart Array controllers.
> 
> ...
>
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -4960,6 +4960,12 @@ static int cciss_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	ctlr_info_t *h;
>  	unsigned long flags;
>  
> +	/*
> +	 * if this is the kdump kernel and the user has set the flags to
> +	 * use hpsa rather than cciss just bail
> +	 */
> +	if ((reset_devices) && (cciss_allow_hpsa == 1))
> +		return -ENODEV;

OK, wazzup.  That's the only occurrence of the symbol
"cciss_allow_hpsa" in Linux and needless to say, the compiler laughed
at me.

