Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbaDPFlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 01:41:21 -0400
Received: from smtprelay0036.hostedemail.com ([216.40.44.36]:47306 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751845AbaDPFlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 01:41:19 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3867:3868:3871:3872:4250:4321:4605:5007:7652:10004:10400:10848:11026:11658:11914:12043:12296:12517:12519:12679:12740:13069:13160:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: badge81_7fa787cc3163f
X-Filterd-Recvd-Size: 1686
Message-ID: <1397626875.15177.3.camel@joe-AO722>
Subject: Re: [PATCH v2] Drivers/PCI: Logging clean-up [1]
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>, Bjorn <bhelgaas@google.com>
Date: Tue, 15 Apr 2014 22:41:15 -0700
In-Reply-To: <20140416073736.8ae3ea7cd0f94f0e056fca84@skynet.be>
References: <20140416073736.8ae3ea7cd0f94f0e056fca84@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-16 at 07:37 +0200, Fabian Frederick wrote:
> -Convert printk(KERN_WARNING|KERN_ERR|KERN_INFO to pr_foo()
> -Define pr_fmt where it doesn't break existing format.
[]
>  (other ones ?)
[]
> diff --git a/drivers/pci/hotplug/cpqphp_core.c b/drivers/pci/hotplug/cpqphp_core.c
[]
> @@ -830,8 +831,8 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  
>  	err = pci_enable_device(pdev);
>  	if (err) {
> -		printk(KERN_ERR MY_NAME ": cannot enable PCI device %s (%d)\n",
> -			pci_name(pdev), err);
> +		pr_err("cannot enable PCI device %s (%d)\n", pci_name(pdev),
> +		       err);

trivia:

My preference is to keep format and argument
on a single line where possible and on
separate lines when not.

		pr_err("cannot enable PCI device %s (%d)\n",
		       pci_name(pdev), err);


