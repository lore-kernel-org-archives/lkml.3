Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbaKERQA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:16:00 -0500
Received: from smtprelay0052.hostedemail.com ([216.40.44.52]:52606 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756071AbaKERPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:15:52 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:2914:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3873:3874:4321:5007:6261:7901:7903:8957:10004:10400:10848:11026:11232:11658:11914:12043:12296:12517:12519:12679:12740:13069:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: robin31_6cfc4a673d643
X-Filterd-Recvd-Size: 1804
Message-ID: <1415207747.6634.15.camel@perches.com>
Subject: Re: [PATCH v2] staging:rtl8723au: core: Fix error reported by
 checkpatch.
From: Joe Perches <joe@perches.com>
To: Sanjeev Sharma <sanjeev_sharma@mentor.com>
Cc: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
        gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Wed, 05 Nov 2014 09:15:47 -0800
In-Reply-To: <1415187303-28541-1-git-send-email-sanjeev_sharma@mentor.com>
References: <wrfjy4rxzk5b.fsf@redhat.com>
	 <1415187303-28541-1-git-send-email-sanjeev_sharma@mentor.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-05 at 17:05 +0530, Sanjeev Sharma wrote:
> This is a patch to the rtw_cmd.c file that fixes
> Error reported by checkpatch.

Please run your patches through checkpatch before
sending them.

WARNING: suspect code indent for conditional statements (24, 24)
#178: FILE: drivers/staging/rtl8723au/core/rtw_cmd.c:1025:
+			if (check_fwstate(pmlmepriv, _FW_LINKED))
 			LPS_Leave23a(padapter);

Also, there are a couple of different things
you changing here.

This should be 2 separate patches.

One to use the temporary for:
+	struct rt_link_detect *ldi = &pmlmepriv->LinkDetectInfo;

(and that bit has a defect here:


+	} else {
 		LPS_Leave23a(padapter);
+		}

where the indentation for the last close brace is wrong)

and another for the whitespace only changes


