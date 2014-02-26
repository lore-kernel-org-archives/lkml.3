Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538AbaBZOnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 09:43:21 -0500
Received: from smtprelay0171.hostedemail.com ([216.40.44.171]:57308 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750813AbaBZOnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 09:43:20 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2393:2559:2562:2693:2828:2894:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3871:3873:3874:4250:4321:4362:4605:5007:7652:7903:8957:9149:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12740:13069:13095:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sun34_741437688614b
X-Filterd-Recvd-Size: 2443
Message-ID: <1393425796.407.19.camel@joe-AO722>
Subject: Re: [PATCH 2/8] security: apparmor: Use a more current logging style
From: Joe Perches <joe@perches.com>
To: John Johansen <john.johansen@canonical.com>
Cc: linux-kernel@vger.kernel.org, James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org
Date: Wed, 26 Feb 2014 06:43:16 -0800
In-Reply-To: <530D9862.1070108@canonical.com>
References: <cover.1393279025.git.joe@perches.com>
	 <ff8a7d422cfa605de40dc64c103f27ed7a76e0cf.1393279025.git.joe@perches.com>
	 <530D9862.1070108@canonical.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-25 at 23:31 -0800, John Johansen wrote:
> On 02/24/2014 01:59 PM, Joe Perches wrote:
> > Convert printks to pr_<level>.
> > Add pr_fmt.
> > Coalesce formats.
> > Remove embedded prefixes from logging.
> > 
> 
> you missed one place,

No, not really.

pr_debug differs from printk(KERN_DEBUG in that
pr_debug is only enabled with a #define DEBUG
or CONFIG_DYNAMIC_DEBUG setting.

I did not want to convert any of the printks
with KERN_DEBUG in this pass as that would
change the message logging by requiring
dynamic debugging be included in the CONFIG.

A subsequent pass converting these uses will
be done if or after these initial patches are
applied.

thanks, Joe

> --- a/security/apparmor/include/apparmor.h
> +++ b/security/apparmor/include/apparmor.h
> @@ -50,7 +50,7 @@ extern unsigned int aa_g_path_max;
>  #define AA_DEBUG(fmt, args...)                                         \
>         do {                                                            \
>                 if (aa_g_debug && printk_ratelimit())                   \
> -                       printk(KERN_DEBUG "AppArmor: " fmt, ##args);    \
> +                       pr_debug(fmt, ##args);                          \
>         } while (0)
>  
>  #define AA_ERROR(fmt, args...)                                         \
> 
> other than that looks good.
> 
> > Signed-off-by: Joe Perches <joe@perches.com>
> Acked-by: John Johansen <john.johansen@canonical.com>


