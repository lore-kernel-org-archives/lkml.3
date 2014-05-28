Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbaE1RGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 13:06:40 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:47288 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbaE1RGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 13:06:38 -0400
Subject: Re: [PATCH] misc: genwqe: fix uninitialized return value in
 genwqe_free_sync_sgl()
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Christian Engelmayer <cengelma@gmx.at>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
In-Reply-To: <1400014023-7570-1-git-send-email-cengelma@gmx.at>
References: <1400014023-7570-1-git-send-email-cengelma@gmx.at>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Wed, 28 May 2014 19:06:32 +0200
Message-ID: <1401296792.10079.0.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052817-3548-0000-0000-000009472750
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christian,

thanks for the contribution to our driver.

Am Dienstag, den 13.05.2014, 22:47 +0200 schrieb Christian Engelmayer:
> Function genwqe_free_sync_sgl() returns the value of variable 'rc'. 'rc' is
> only set in the error paths, thus initialize it by 0. Coverity CID 1204242.
> 
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
> ---
> Compile tested and applies against branch char-misc-next of tree
> git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
> ---
>  drivers/misc/genwqe/card_utils.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/misc/genwqe/card_utils.c b/drivers/misc/genwqe/card_utils.c
> index d049d27..5babf40 100644
> --- a/drivers/misc/genwqe/card_utils.c
> +++ b/drivers/misc/genwqe/card_utils.c
> @@ -454,7 +454,7 @@ int genwqe_setup_sgl(struct genwqe_dev *cd, struct genwqe_sgl *sgl,
>   */
>  int genwqe_free_sync_sgl(struct genwqe_dev *cd, struct genwqe_sgl *sgl)
>  {
> -	int rc;
> +	int rc = 0;
>  	struct pci_dev *pci_dev = cd->pci_dev;
> 
>  	if (sgl->fpage) {

Acked-by: Frank Haverkamp <haver@linux.vnet.ibm.com>

