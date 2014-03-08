Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaCHQ0s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 11:26:48 -0500
Received: from smtprelay0157.hostedemail.com ([216.40.44.157]:45036 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751573AbaCHQ0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 11:26:47 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:2893:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:4250:4321:5007:7652:7903:8556:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12296:12438:12517:12519:12555:12740:13019:13069:13071:13095:13181:13229:13311:13357:14093:14097:21060:21067,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: hill37_cd106f32757
X-Filterd-Recvd-Size: 2780
Message-ID: <1394296003.6972.26.camel@joe-AO722>
Subject: Re: [PATCH] eeh_pseries: Missing break?
From: Joe Perches <joe@perches.com>
To: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Sat, 08 Mar 2014 08:26:43 -0800
In-Reply-To: <20140308161647.GA24296@shangw.(null)>
References: <1394238692.16156.115.camel@joe-AO722>
	 <20140308161647.GA24296@shangw.(null)>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-03-09 at 00:16 +0800, Gavin Shan wrote:
> On Fri, Mar 07, 2014 at 04:31:32PM -0800, Joe Perches wrote:
> >Looks like this is unintentional as the
> >result = EEH_STATE_UNAVAILABLE is being
> >overwritten by EEH_STATE_NOT_SUPPORT in the
> >fallthrough to the default case.
> 
> Thanks, Joe. It wasn't unintentional.

Hi Gavin.

English usages of "double negatives" are different
than other languages.  "it wasn't unintentional"
means the same thing as "it was intentional".

> Could you have better commit log
> and subject, then repost it?
> 
> The format looks like:
> 
> ---
> 
> powerpc/eeh: Fix overwritten PE state
> 
> In pseries_eeh_get_state(), we always have EEH_STATE_UNAVAILABLE
> overwritten by EEH_STATE_NOT_SUPPORT because of the missed "break"
> the patch fixes the issue.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

>From my perspective, you should write up a commit
message of your own choice (I wouldn't use "we",
but the rest seems OK) and add a Reported-by:

All I did was notice it and bring it to your
attention.

> ---
> 
> With the better commit log/subject, please have:
> 
> Acked-by: Gavin Shan <shangw@linux.vnet.ibm.com>
> 
> >---
> >diff --git a/arch/powerpc/platforms/pseries/eeh_pseries.c b/arch/powerpc/platforms/pseries/eeh_pseries.c
> >index 8a8f047..83da53f 100644
> >--- a/arch/powerpc/platforms/pseries/eeh_pseries.c
> >+++ b/arch/powerpc/platforms/pseries/eeh_pseries.c
> >@@ -460,14 +460,15 @@ static int pseries_eeh_get_state(struct eeh_pe *pe, int *state)
> > 		case 5:
> > 			if (rets[2]) {
> > 				if (state) *state = rets[2];
> > 				result = EEH_STATE_UNAVAILABLE;
> > 			} else {
> > 				result = EEH_STATE_NOT_SUPPORT;
> > 			}
> >+			break;
> > 		default:
> > 			result = EEH_STATE_NOT_SUPPORT;
> > 		}
> > 	} else {
> > 		result = EEH_STATE_NOT_SUPPORT;
> > 	}
> >
> 
> Thanks,
> Gavin
> 



