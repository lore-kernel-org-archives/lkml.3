Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbaFGPz3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 11:55:29 -0400
Received: from smtprelay0153.hostedemail.com ([216.40.44.153]:55258 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753070AbaFGPz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 11:55:28 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1567:1593:1594:1711:1714:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:3871:3872:4321:5007:7652:10004:10400:10848:11026:11232:11658:11914:12043:12114:12296:12438:12517:12519:12740:13019:13069:13138:13231:13311:13357:13894,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: gold65_4ca09d3cc5e34
X-Filterd-Recvd-Size: 1395
Message-ID: <1402156524.28369.4.camel@joe-AO725>
Subject: Re: [PATCH] media-device: Remove duplicated memset() in
 media_enum_entities()
From: Joe Perches <joe@perches.com>
To: Salva =?ISO-8859-1?Q?Peir=F3?= <speiro@ai2.upv.es>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@kernel.org
Date: Sat, 07 Jun 2014 08:55:24 -0700
In-Reply-To: <1402152104-16865-1-git-send-email-speiro@ai2.upv.es>
References: <1402152104-16865-1-git-send-email-speiro@ai2.upv.es>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-06-07 at 16:41 +0200, Salva Peiró wrote:
> After the zeroing the whole struct struct media_entity_desc u_ent,
> it is no longer necessary to memset(0) its u_ent.name field.

trivia:

> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
[]
> @@ -106,8 +106,6 @@ static long media_device_enum_entities(struct media_device *mdev,
>  	if (ent->name) {
>  		strncpy(u_ent.name, ent->name, sizeof(u_ent.name));
>  		u_ent.name[sizeof(u_ent.name) - 1] = '\0';

this could be strlcpy too.



