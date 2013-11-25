Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab3KYVLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 16:11:19 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:43217 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab3KYVLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 16:11:16 -0500
Date: Mon, 25 Nov 2013 21:08:42 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Michele Baldessari <michele@acksyn.org>
Cc: linux-ide@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add ATA_HORKAGE_BROKEN_FPDMA_AA quirk for Seagate
 Momentus SpinPoint M8
Message-ID: <20131125210842.0c68ee92@alan.etchedpixels.co.uk>
In-Reply-To: <1385406014-4877-1-git-send-email-michele@acksyn.org>
References: <1385406014-4877-1-git-send-email-michele@acksyn.org>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Reported-by: Nicholas <arealityfarbetween@googlemail.com>
> Signed-off-by: Michele Baldessari <michele@acksyn.org>
> Tested-by: Nicholas <arealityfarbetween@googlemail.com>

Acked-by: Alan Cox <gnomes@lxorguk.ukuu.org.uk>

Going for a dig in google turns this up against multiple controllers,
multiple kernels, multiple distros..


> ---
>  drivers/ata/libata-core.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 81a94a3..f6b0892 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -4156,6 +4156,9 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
>  	{ "ST3320[68]13AS",	"SD1[5-9]",	ATA_HORKAGE_NONCQ |
>  						ATA_HORKAGE_FIRMWARE_WARN },
>  
> +	/* Seagate Momentus SpinPoint M8 seem to have FPMDA_AA issues */
> +	{ "ST1000LM024 HN-M101MBB", "2AR10001",	ATA_HORKAGE_BROKEN_FPDMA_AA },
> +
>  	/* Blacklist entries taken from Silicon Image 3124/3132
>  	   Windows driver .inf file - also several Linux problem reports */
>  	{ "HTS541060G9SA00",    "MB3OC60D",     ATA_HORKAGE_NONCQ, },
