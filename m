Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbaKHVXu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 16:23:50 -0500
Received: from smtprelay0215.hostedemail.com ([216.40.44.215]:35541 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751231AbaKHVXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 16:23:49 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:968:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3868:3870:3872:4321:5007:6261:10004:10400:10848:11026:11657:11658:11914:12043:12296:12517:12519:12740:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bait70_78578bc727501
X-Filterd-Recvd-Size: 1698
Message-ID: <1415481824.23530.35.camel@perches.com>
Subject: Re: [PATCH] rtl8188eu: Remove unnecessary braces for simple return
 in xmit_linux.c
From: Joe Perches <joe@perches.com>
To: Krzysztof Konopko <kris@konagma.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        navin patidar <navin.patidar@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>, trivial@kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Sat, 08 Nov 2014 13:23:44 -0800
In-Reply-To: <1415481253-12281-1-git-send-email-kris@konagma.com>
References: <1415481253-12281-1-git-send-email-kris@konagma.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-11-08 at 22:14 +0100, Krzysztof Konopko wrote:
> scripts/checkpatch.pl reports a coding style problem in xmit_linux.c
[]
> diff --git a/drivers/staging/rtl8188eu/os_dep/xmit_linux.c b/drivers/staging/rtl8188eu/os_dep/xmit_linux.c
[]
> @@ -67,9 +67,8 @@ uint _rtw_pktfile_read(struct pkt_file *pfile, u8 *rmem, uint rlen)
>  int rtw_endofpktfile(struct pkt_file *pfile)
>  {
>  
> -	if (pfile->pkt_len == 0) {
> +	if (pfile->pkt_len == 0)
>  		return true;
> -	}
>  
> 
>  	return false;

This should probably be

bool rtw_endofpktfile(const struct pkt_file *pfile_
{
	return !pfile->pkt_len;
}

or just removed altogether and tested directly
in the one place it's used.


