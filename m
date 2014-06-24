Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbaFXPs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:48:56 -0400
Received: from smtprelay0099.hostedemail.com ([216.40.44.99]:45750 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751582AbaFXPsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:48:42 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3868:3871:4321:5007:7652:7875:10004:10400:10848:11026:11232:11658:11914:12043:12296:12517:12519:12740:13069:13161:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: grass47_85d685a7bac2a
X-Filterd-Recvd-Size: 1675
Message-ID: <1403624918.29061.16.camel@joe-AO725>
Subject: Re: [PATCH 1/1] ar7: replace mac address parsing
From: Joe Perches <joe@perches.com>
To: Daniel Walter <dwalter@google.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Date: Tue, 24 Jun 2014 08:48:38 -0700
In-Reply-To: <20140624153959.GA19564@google.com>
References: <20140624153959.GA19564@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-24 at 16:39 +0100, Daniel Walter wrote:
> Replace sscanf() with mac_pton().
[]
> diff --git a/arch/mips/ar7/platform.c b/arch/mips/ar7/platform.c
[]
> @@ -307,10 +307,7 @@ static void __init cpmac_get_mac(int instance, unsigned char *dev_addr)
>  	}
>  
>  	if (mac) {
> -		if (sscanf(mac, "%hhx:%hhx:%hhx:%hhx:%hhx:%hhx",
> -					&dev_addr[0], &dev_addr[1],
> -					&dev_addr[2], &dev_addr[3],
> -					&dev_addr[4], &dev_addr[5]) != 6) {
> +		if (!mac_pton(mac, dev_addr)) {

There is a slight functional change with this conversion.

mac_pton is strict about leading 0's and requires a 17 char strlen.

sscanf will accept 0:1:2:3:4:5, mac_pton will not.

>  			pr_warning("cannot parse mac address, "
>  					"using random address\n");

could be coalesced and pr_warn

			pr_warn("cannot parse mac address - using random address\n");


