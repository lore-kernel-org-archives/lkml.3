Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359AbaKUBnL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 20:43:11 -0500
Received: from smtprelay0031.hostedemail.com ([216.40.44.31]:45635 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756702AbaKUBnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 20:43:09 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:966:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2559:2562:2828:2914:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:4321:4385:5007:6261:7903:10004:10400:10848:11026:11232:11658:11914:12296:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: join19_1b3fc2d46292d
X-Filterd-Recvd-Size: 1797
Message-ID: <1416534185.6651.30.camel@perches.com>
Subject: Re: [PATCH 1/8] of: Use vargs in __of_node_alloc
From: Joe Perches <joe@perches.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Rob Herring <robh+dt@kernel.org>
Date: Thu, 20 Nov 2014 17:43:05 -0800
In-Reply-To: <1416533715-9758-2-git-send-email-grant.likely@linaro.org>
References: <1416533715-9758-1-git-send-email-grant.likely@linaro.org>
	 <1416533715-9758-2-git-send-email-grant.likely@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-21 at 01:35 +0000, Grant Likely wrote:
> The overlay code needs to construct a new full_name from the parent name
> and the node name, but the current method has to allocate and then free
> an temporary string which is wasteful. Fix this problem by using vargs
> to pass in a format and arguments into __of_node_alloc().
[]
> diff --git a/drivers/of/of_private.h b/drivers/of/of_private.h
[]
> @@ -61,7 +61,7 @@ static inline int of_property_notify(int action, struct device_node *np,
>   * own the devtree lock or work on detached trees only.
>   */
>  struct property *__of_prop_dup(const struct property *prop, gfp_t allocflags);
> -struct device_node *__of_node_alloc(const char *full_name, gfp_t allocflags);

Please add

__printf(1, 2)
> +struct device_node *__of_node_alloc(const char *fmt, ...);


