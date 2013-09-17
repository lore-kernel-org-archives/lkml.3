Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab3IQQYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 12:24:30 -0400
Received: from smtprelay0103.hostedemail.com ([216.40.44.103]:36734 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752999Ab3IQQY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 12:24:29 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3867:3868:4321:5007:7652:10004:10400:10848:11026:11232:11473:11658:11914:12043:12438:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sleet11_9be8d7ab0523
X-Filterd-Recvd-Size: 1539
Message-ID: <1379435064.2012.8.camel@joe-AO722>
Subject: Re: [PATCH] ahci: Changing two module params with static and
 __read_mostly
From: Joe Perches <joe@perches.com>
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: tj@kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 17 Sep 2013 09:24:24 -0700
In-Reply-To: <1379436518.26153.31.camel@cliu38-desktop-build>
References: <1379436518.26153.31.camel@cliu38-desktop-build>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-18 at 00:48 +0800, Chuansheng Liu wrote:
> Here module parameters ahci_em_messages and devslp_idle_timeout can
> be set as static and __read_mostly.
> 
> Signed-off-by: Liu, Chuansheng <chuansheng.liu@intel.com>
> ---
>  drivers/ata/libahci.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
[]
> @@ -189,14 +189,15 @@ struct ata_port_operations ahci_pmp_retry_srst_ops = {
>  };
>  EXPORT_SYMBOL_GPL(ahci_pmp_retry_srst_ops);
>  
> -int ahci_em_messages = 1;
> +static int ahci_em_messages __read_mostly = 1;

This one could also be converted to
static bool ahci_em_messages __read_mostly = true;


