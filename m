Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab3JGWd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 18:33:29 -0400
Received: from smtprelay0028.hostedemail.com ([216.40.44.28]:36827 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751456Ab3JGWd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 18:33:28 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3872:3874:4250:4321:5007:7652:10004:10400:10848:11026:11232:11658:11914:12295:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: help58_1e04aba836636
X-Filterd-Recvd-Size: 1680
Message-ID: <1381185204.2081.221.camel@joe-AO722>
Subject: Re: [PATCH] 9p: unsigned/signed wrap in p9/unix modes.
From: Joe Perches <joe@perches.com>
To: "Geyslan G. Bem" <geyslan@gmail.com>
Cc: ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net,
        v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel-br@googlegroups.com
Date: Mon, 07 Oct 2013 15:33:24 -0700
In-Reply-To: <1381184340-11190-1-git-send-email-geyslan@gmail.com>
References: <1381184340-11190-1-git-send-email-geyslan@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-07 at 19:19 -0300, Geyslan G. Bem wrote:
> Changes the sign type to unsigned, avoiding the possibility of
> wrap when ORing the p9 or unix bit modes.
[]
> diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
[]
> @@ -144,7 +144,7 @@ static umode_t p9mode2unixmode(struct v9fs_session_info *v9ses,
>  	else if ((mode & P9_DMDEVICE) && (v9fs_proto_dotu(v9ses))
>  		 && (v9ses->nodev == 0)) {
>  		char type = 0, ext[32];
> -		int major = -1, minor = -1;
> +		u32 major = 0, minor = 0;
>  
>  		strlcpy(ext, stat->extension, sizeof(ext));
>  		sscanf(ext, "%c %u %u", &type, &major, &minor);

This bit changes the MKDEV below it.

I would think that the sscanf return should be
checked for 3 and maybe MKDEV should not be
constructed when it's not.


