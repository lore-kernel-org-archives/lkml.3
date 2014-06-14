Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbaFNDbq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 23:31:46 -0400
Received: from smtprelay0046.hostedemail.com ([216.40.44.46]:35526 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753722AbaFNDbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 23:31:44 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:4321:5007:6119:7652:7903:10004:10400:10848:11232:11657:11658:11914:12043:12296:12517:12519:12740:13069:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: vein84_663404017740b
X-Filterd-Recvd-Size: 1983
Message-ID: <1402716700.2756.3.camel@joe-AO725>
Subject: Re: [PATCH 2/2] staging: tidspbridge: Fix function pointer spacing
 in struct definition
From: Joe Perches <joe@perches.com>
To: Jeff Oczek <jeffoczek@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Fri, 13 Jun 2014 20:31:40 -0700
In-Reply-To: <1402714093-15404-2-git-send-email-jeffoczek@gmail.com>
References: <1402714093-15404-1-git-send-email-jeffoczek@gmail.com>
	 <1402714093-15404-2-git-send-email-jeffoczek@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-13 at 22:48 -0400, Jeff Oczek wrote:
> Simple coding style changes
[]
> diff --git a/drivers/staging/tidspbridge/include/dspbridge/dblldefs.h b/drivers/staging/tidspbridge/include/dspbridge/dblldefs.h
[]
> @@ -168,11 +168,11 @@ struct dbll_attrs {
[]
> -	 s32(*fread) (void *, size_t, size_t, void *);
> -	 s32(*fseek) (void *, long, int);
> -	 s32(*ftell) (void *);
> -	 s32(*fclose) (void *);
> -	void *(*fopen) (const char *, const char *);
> +	 s32 (*fread)(void *, size_t, size_t, void *);
> +	 s32 (*fseek)(void *, long, int);
> +	 s32 (*ftell)(void *);
> +	 s32 (*fclose)(void *);
> +	void *(*fopen)(const char *, const char *);
>  };

Better would be to describe the arguments with
variable names and align all the return values

	void *(*fopen

	s32 (*fread)(void *arg1, size_t val1, size_t val2, void *ptr1);
	s32 (*fseek)(void *ptr1, long arg2, int arg3);
	s32 (*ftell)(void * ptr);
	s32 (*fclose)(void *ptr);
	void *(*fopen)(const char *ptr1, const char *ptr2);

where arg, val, ptr are actually useful descriptors

