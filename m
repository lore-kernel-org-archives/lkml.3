Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbaG1Ohp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 10:37:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbaG1Oho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 10:37:44 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Stefan Weinhuber <wein@de.ibm.com>,
        Stefan Haberland <stefan.haberland@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s390: block: dasd_devmap.c:  Cleaning up missing null-terminate in conjunction with strncpy
References: <1406384860-2775-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 28 Jul 2014 10:37:34 -0400
In-Reply-To: <1406384860-2775-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	(Rickard Strandqvist's message of "Sat, 26 Jul 2014 16:27:40 +0200")
Message-ID: <x49k36xpn0x.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> writes:

> Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/s390/block/dasd_devmap.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/s390/block/dasd_devmap.c b/drivers/s390/block/dasd_devmap.c
> index 2ead7e7..4a60ef8 100644
> --- a/drivers/s390/block/dasd_devmap.c
> +++ b/drivers/s390/block/dasd_devmap.c
> @@ -424,7 +424,7 @@ dasd_add_busid(const char *bus_id, int features)
>  	if (!devmap) {
>  		/* This bus_id is new. */
>  		new->devindex = dasd_max_devindex++;
> -		strncpy(new->bus_id, bus_id, DASD_BUS_ID_SIZE);
> +		strlcpy(new->bus_id, bus_id, DASD_BUS_ID_SIZE);

NACK

kzalloc'd.

Did you put thought into *any* of these conversions?
