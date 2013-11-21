Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978Ab3KUER6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 23:17:58 -0500
Received: from smtprelay0165.hostedemail.com ([216.40.44.165]:54157 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751714Ab3KUERy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 23:17:54 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:966:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3868:3871:3874:4321:4385:5007:6238:7652:7903:10004:10400:10848:11026:11232:11658:11914:12043:12438:12517:12519:12555:12740:13019:13069:13311:13357:13870:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: twig08_44a7ca9e6ea61
X-Filterd-Recvd-Size: 1811
Message-ID: <1385007469.2164.39.camel@joe-AO722>
Subject: Re: [PATCH] wimax: remove dead code
From: Joe Perches <joe@perches.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        Johannes Berg <johannes.berg@intel.com>
Cc: inaky.perez-gonzalez@intel.com, linux-wimax@intel.com, davem@davemloft.net,
        wimax@linuxwimax.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 20 Nov 2013 20:17:49 -0800
In-Reply-To: <1385005391-18379-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1385005391-18379-1-git-send-email-michael.opdenacker@free-electrons.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-11-21 at 04:43 +0100, Michael Opdenacker wrote:
> This removes a code line that is between a "return 0;" and an error label.
> This code line can never be reached.

Adding Johannes Berg who added this oversight.

> Found by Coverity (CID: 1130529)
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  net/wimax/stack.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/net/wimax/stack.c b/net/wimax/stack.c
> index ef2191b969a7..ec8b577db135 100644
> --- a/net/wimax/stack.c
> +++ b/net/wimax/stack.c
> @@ -610,7 +610,6 @@ int __init wimax_subsys_init(void)
>  	d_fnend(4, NULL, "() = 0\n");
>  	return 0;
>  
> -	genl_unregister_family(&wimax_gnl_family);
>  error_register_family:
>  	d_fnend(4, NULL, "() = %d\n", result);
>  	return result;



