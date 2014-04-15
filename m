Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbaDOUHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 16:07:08 -0400
Received: from smtprelay0125.hostedemail.com ([216.40.44.125]:58956 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754556AbaDOUHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 16:07:03 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:966:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:4250:4321:4385:4605:5007:6119:7652:7903:10004:10400:10848:11026:11657:11658:11914:12043:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: order30_3b35e6f6e0258
X-Filterd-Recvd-Size: 1781
Message-ID: <1397592405.8998.6.camel@joe-AO722>
Subject: Re: [PATCH 1/1]  Drivers/PCI: Logging clean-up [1]
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Bjorn <bhelgaas@google.com>,
        akpm <akpm@linux-foundation.org>
Date: Tue, 15 Apr 2014 13:06:45 -0700
In-Reply-To: <20140415205552.e358a533cf0632026f6bd342@skynet.be>
References: <20140415205552.e358a533cf0632026f6bd342@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-15 at 20:55 +0200, Fabian Frederick wrote:

> diff --git a/drivers/pci/pci-stub.c b/drivers/pci/pci-stub.c
[]
> @@ -15,7 +15,7 @@
>   * # ls -l /sys/bus/pci/devices/0000:00:19.0/driver
>   * .../0000:00:19.0/driver -> ../../../bus/pci/drivers/pci-stub
>   */
> -
> +#define pr_fmt(fmt) "pci-stub: " fmt

When the output prefix matches the module/filename, please use

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

[]

> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
[]
> @@ -903,8 +903,8 @@ legacy_io_err:
>  	kfree(b->legacy_io);
>  	b->legacy_io = NULL;
>  kzalloc_err:
> -	printk(KERN_WARNING "pci: warning: could not create legacy I/O port "
> -	       "and ISA memory resources to sysfs\n");
> +	pr_warn("warning: could not create legacy I/O port "
> +		"and ISA memory resources to sysfs\n");

Please coalesce format fragments too even if the format part
exceeds 80 columns.


