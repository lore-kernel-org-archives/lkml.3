Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab3IRV1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 17:27:12 -0400
Received: from smtprelay0202.hostedemail.com ([216.40.44.202]:50886 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751556Ab3IRV1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 17:27:11 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2198:2199:2200:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:4385:5007:6119:6120:7652:7901:7903:10004:10400:10848:10967:11232:11658:11914:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:
X-HE-Tag: crack43_5b63492eaf02b
X-Filterd-Recvd-Size: 2389
Message-ID: <1379539625.1787.77.camel@joe-AO722>
Subject: Re: [PATCH v2 2/4] gcov: add support for gcc 4.7 gcov format
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frantisek Hrbata <fhrbata@redhat.com>, linux-kernel@vger.kernel.org,
        jstancek@redhat.com, keescook@chromium.org,
        peter.oberparleiter@de.ibm.com, rusty@rustcorp.com.au,
        linux-arch@vger.kernel.org, arnd@arndb.de, mgahagan@redhat.com,
        agospoda@redhat.com
Date: Wed, 18 Sep 2013 14:27:05 -0700
In-Reply-To: <20130918142259.8c504e7cfbc8318a0550a891@linux-foundation.org>
References: <1378305776-3644-1-git-send-email-fhrbata@redhat.com>
	 <1378305776-3644-3-git-send-email-fhrbata@redhat.com>
	 <20130918142259.8c504e7cfbc8318a0550a891@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-18 at 14:22 -0700, Andrew Morton wrote:
> On Wed,  4 Sep 2013 16:42:54 +0200 Frantisek Hrbata <fhrbata@redhat.com> wrote:
> > The gcov in-memory format changed in gcc 4.7. The biggest change, which
> > requires this special implementation, is that gcov_info no longer contains
> > array of counters for each counter type for all functions and gcov_fn_info is
> > not used for mapping of function's counters to these arrays(offset). Now each
> > gcov_fn_info contans it's counters, which makes things a little bit easier.
> > 
> > This is heavily based on the previous gcc_3_4.c implementation and patches
> > provided by Peter Oberparleiter. Specially the buffer gcda implementation for
> > iterator.
> 
> A couple of little tweaks:
[]
> +++ a/kernel/gcov/gcc_4_7.c
[]
> @@ -267,8 +266,8 @@ struct gcov_info *gcov_info_dup(struct g
>  	if (!dup->filename)
>  		goto err_free;
>  
> -	dup->functions = kzalloc(sizeof(struct gcov_fn_info *) *
> -			info->n_functions, GFP_KERNEL);
> +	dup->functions = kcalloc(sizeof(struct gcov_fn_info *),
> +				 info->n_functions, GFP_KERNEL);

kcalloc(n, size_t, flags)

	dup->functions = kcalloc(info->n_functions,
				 sizeof(struct gcov_fn_info *), GFP_KERNEL);


