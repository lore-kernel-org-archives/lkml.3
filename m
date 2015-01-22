Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbbAVTLF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 14:11:05 -0500
Received: from smtprelay0103.hostedemail.com ([216.40.44.103]:53369 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753262AbbAVTLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 14:11:04 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:4250:4321:5007:6261:9010:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12740:13069:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: grade60_7d236d38e1d0e
X-Filterd-Recvd-Size: 2330
Message-ID: <1421953858.2702.5.camel@perches.com>
Subject: Re: [PATCH] staging: dgnc: fix long lines in PCI device table
From: Joe Perches <joe@perches.com>
To: Krzysztof Adamski <k@japko.eu>
Cc: Lidza Louina <lidza.louina@gmail.com>, Mark Hounschell <markh@compro.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Thu, 22 Jan 2015 11:10:58 -0800
In-Reply-To: <20150122185524.GA18274@box2.japko.eu>
References: <20150122185524.GA18274@box2.japko.eu>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-22 at 19:55 +0100, Krzysztof Adamski wrote:
> This patch fixes coding style of PCI device table declaration.
[]
> diff --git a/drivers/staging/dgnc/dgnc_driver.c b/drivers/staging/dgnc/dgnc_driver.c
[]
> @@ -98,11 +98,11 @@ static struct timer_list dgnc_poll_timer;
>  
> 
>  static struct pci_device_id dgnc_pci_tbl[] = {

const

> -	{	DIGI_VID, PCI_DEVICE_CLASSIC_4_DID, PCI_ANY_ID, PCI_ANY_ID, 0, 0,	0 },
> -	{	DIGI_VID, PCI_DEVICE_CLASSIC_4_422_DID, PCI_ANY_ID, PCI_ANY_ID, 0, 0,	1 },
> -	{	DIGI_VID, PCI_DEVICE_CLASSIC_8_DID, PCI_ANY_ID, PCI_ANY_ID, 0, 0,	2 },
> -	{	DIGI_VID, PCI_DEVICE_CLASSIC_8_422_DID, PCI_ANY_ID, PCI_ANY_ID, 0, 0,	3 },
> -	{0,}						/* 0 terminated list. */
> +	{PCI_DEVICE(DIGI_VID, PCI_DEVICE_CLASSIC_4_DID), .driver_data = 0},
> +	{PCI_DEVICE(DIGI_VID, PCI_DEVICE_CLASSIC_4_422_DID), .driver_data = 1},
> +	{PCI_DEVICE(DIGI_VID, PCI_DEVICE_CLASSIC_8_DID), .driver_data = 2},
> +	{PCI_DEVICE(DIGI_VID, PCI_DEVICE_CLASSIC_8_422_DID), .driver_data = 3},
> +	{0,}

Maybe better to keep the alignment of .driver_data

+	{PCI_DEVICE(DIGI_VID, PCI_DEVICE_CLASSIC_4_DID),     .driver_data = 0},
+	{PCI_DEVICE(DIGI_VID, PCI_DEVICE_CLASSIC_4_422_DID), .driver_data = 1},
+	{PCI_DEVICE(DIGI_VID, PCI_DEVICE_CLASSIC_8_DID),     .driver_data = 2},
+	{PCI_DEVICE(DIGI_VID, PCI_DEVICE_CLASSIC_8_422_DID), .driver_data = 3},


