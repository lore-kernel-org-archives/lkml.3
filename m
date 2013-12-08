Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab3LHQFb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 11:05:31 -0500
Received: from smtprelay0202.hostedemail.com ([216.40.44.202]:42437 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754768Ab3LHQF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 11:05:28 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3167:3352:3622:3865:3866:3867:3868:3872:3873:4321:4605:5007:6119:6120:7576:7652:7901:8660:10004:10400:10848:11026:11232:11657:11658:11914:12043:12296:12517:12519:12740:13069:13148:13230:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bed28_699e8eb562c2b
X-Filterd-Recvd-Size: 2105
Message-ID: <1386518724.31845.66.camel@joe-AO722>
Subject: Re: [PATCH 1/2] PCI, AER: Add a TLP header print helper
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Bjorn Helgaas <bhelgaas@google.com>, Lance Ortiz <lance.ortiz@hp.com>,
        Tony Luck <tony.luck@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-pci@vger.kernel.org
Date: Sun, 08 Dec 2013 08:05:24 -0800
In-Reply-To: <1386515571-23252-1-git-send-email-bp@alien8.de>
References: <1386515571-23252-1-git-send-email-bp@alien8.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-12-08 at 16:12 +0100, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> ... and call it instead of duplicating the large printk format
> statement.
> 
> No functionality change.

You do change the output.
Perhaps it'd be better to pass the header prefix too.

> diff --git a/drivers/pci/pcie/aer/aerdrv_errprint.c b/drivers/pci/pcie/aer/aerdrv_errprint.c
[]
> @@ -124,6 +124,21 @@ static const char *aer_agent_string[] = {

> +static void __print_tlp_header(struct pci_dev *dev,
> +			       struct aer_header_log_regs *t)
> +{
> +	unsigned char *tlp = (unsigned char *)&t;
> +
> +	dev_err(&dev->dev, "  TLP Header:"

Always indents and emits "  TLP Header:"

> @@ -250,18 +256,10 @@ void cper_print_aer(struct pci_dev *dev, int cper_severity,
>  	if (aer_severity != AER_CORRECTABLE)
>  		dev_err(&dev->dev, "aer_uncor_severity: 0x%08x\n",
>  		       aer->uncor_severity);
> -	if (tlp_header_valid) {
> -		const unsigned char *tlp;
> -		tlp = (const unsigned char *)&aer->header_log;
> -		dev_err(&dev->dev, "aer_tlp_header:"

vs removing this "aer_tlp_header:"


