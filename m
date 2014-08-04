Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbaHDO1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:27:23 -0400
Received: from smtprelay0222.hostedemail.com ([216.40.44.222]:51449 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752263AbaHDO1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:27:22 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3871:3873:3874:4321:4605:5007:7652:9010:9040:9121:10004:10400:10848:11026:11232:11473:11658:11914:12043:12438:12517:12519:12740:13069:13255:13311:13357:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: yard18_401a80d20eb14
X-Filterd-Recvd-Size: 2043
Message-ID: <1407162439.16152.67.camel@joe-AO725>
Subject: Re: checkpatch.pl report about "Missing blank line after
 declarations" in a structure definition
From: Joe Perches <joe@perches.com>
To: Dotan Barak <dotanb@mellanox.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 04 Aug 2014 07:27:19 -0700
In-Reply-To: <e68ad593255b4094a79de9b22cbc2a7a@DB3PR05MB380.eurprd05.prod.outlook.com>
References: <3219ba81002f41d99c8651755dc2a920@DB3PR05MB380.eurprd05.prod.outlook.com>
	 <1407159342.16152.63.camel@joe-AO725>
	 <e68ad593255b4094a79de9b22cbc2a7a@DB3PR05MB380.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-08-04 at 14:14 +0000, Dotan Barak wrote:
> Hi Joe.
> 
> The patch that you mentioned solved most of the issues, thanks!
> 
> However, there is still one more warning of this type within a struct declaration.
> 
> # ./checkpatch.pl --file --no-tree ../include/linux/mlx5/driver.h
> 
> WARNING: Missing a blank line after declarations
> #508: FILE: ../include/linux/mlx5/driver.h:508:
> +       struct mlx5_uuar_info   uuari;
> +       MLX5_DECLARE_DOORBELL_LOCK(cq_uar_lock);
> 
> 
> <snip start>
> struct mlx5_priv {
>         char                    name[MLX5_MAX_NAME_LEN];
>         struct mlx5_eq_table    eq_table;
>         struct mlx5_uuar_info   uuari;
>         MLX5_DECLARE_DOORBELL_LOCK(cq_uar_lock);

MLX5_DECLARE_DOORBELL is not a "normal" DECLARE macro.

Perhaps the exception for the DECLARE_<FOO> declaration
macros in the exceptions list:

	(?:$Storage\s+)?(?:DECLARE|DEFINE)_[A-Z]+\s*\(|

could be expanded to:

	(?:$Storage\s+)?[A-Z0-9_]*(?:DECLARE|DEFINE)_[A-Z]+\s*\(|


