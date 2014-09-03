Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125AbaICMN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:13:58 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:52015 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341AbaICMN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:13:57 -0400
Date: Wed, 3 Sep 2014 13:13:19 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Loic Pefferkorn <loic@loicp.eu>
Cc: gregkh@linuxfoundation.org, alan@linux.intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] staging: goldfish: document spinlock usage
Message-ID: <20140903131319.79095a43@alan.etchedpixels.co.uk>
In-Reply-To: <1409742827-6048-4-git-send-email-loic@loicp.eu>
References: <1409742827-6048-1-git-send-email-loic@loicp.eu>
	<1409742827-6048-4-git-send-email-loic@loicp.eu>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  3 Sep 2014 13:13:44 +0200
Loic Pefferkorn <loic@loicp.eu> wrote:

> Coding style: document spinlock usage
> 
> Signed-off-by: Loic Pefferkorn <loic@loicp.eu>
> ---
>  drivers/staging/goldfish/goldfish_audio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/goldfish/goldfish_audio.c b/drivers/staging/goldfish/goldfish_audio.c
> index 23a206d..ab723ab 100644
> --- a/drivers/staging/goldfish/goldfish_audio.c
> +++ b/drivers/staging/goldfish/goldfish_audio.c
> @@ -36,7 +36,7 @@ MODULE_VERSION("1.0");
>  struct goldfish_audio {
>  	char __iomem *reg_base;
>  	int irq;
> -	spinlock_t lock;
> +	spinlock_t lock;                /* Serialize access to device */

This tells the reader nothing. It's good to document locking models but

- you lock data not code (which is a detail a lot of programmers get wrong
			  in th design stage too)
- you need to document what objects are protected by the lock


So it should tell the reader what the lock must be held to do

If you look at the audio code it actually protects the status field and
status register of the "hardware"


