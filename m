Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbaA3DvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 22:51:09 -0500
Received: from smtprelay0175.hostedemail.com ([216.40.44.175]:58273 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750905AbaA3DvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 22:51:06 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1801:2110:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3872:4250:4321:4605:5007:6119:7652:7904:9149:10004:10400:10848:11026:11232:11658:11914:12438:12517:12519:12740,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,
X-HE-Tag: shop96_7d61e124a5e1b
X-Filterd-Recvd-Size: 3579
Message-ID: <1391053859.2422.34.camel@joe-AO722>
Subject: Re: [PATCH v4 1/2] mm: add kstrimdup function
From: Joe Perches <joe@perches.com>
To: Sebastian Capella <sebastian.capella@linaro.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>, Shaohua Li <shli@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Date: Wed, 29 Jan 2014 19:50:59 -0800
In-Reply-To: <20140130034137.2769.50210@capellas-linux>
References: <1391039304-3172-1-git-send-email-sebastian.capella@linaro.org>
	 <1391039304-3172-2-git-send-email-sebastian.capella@linaro.org>
	 <alpine.LRH.2.02.1401291956510.8304@file01.intranet.prod.int.rdu2.redhat.com>
	 <1391045068.2422.30.camel@joe-AO722>
	 <20140130034137.2769.50210@capellas-linux>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-29 at 19:41 -0800, Sebastian Capella wrote:
> Quoting Joe Perches (2014-01-29 17:24:28)
> > Why not minimize the malloc length too?
> > 

> I figured it would be mostly for small trimming, but it seems like
> it could be and advantage and used more generally this way.
> 
> I have a couple of small changes to return NULL in empty string/all ws
> cases and fix a buffer underrun.
> 
> How does this look?
[]
> char *kstrimdup(const char *s, gfp_t gfp)
> {                                                                                
>         char *buf;                                                               
>         const char *begin = skip_spaces(s);                                      
>         size_t len = strlen(begin);                                              

removing begin and just using s would work

>         if (len == 0)                                                            
>                 return NULL;                                                     
>                                                                                  
>         while (len > 1 && isspace(begin[len - 1]))                               
>                 len--;                                                           
>                                                                                  
>         buf = kmalloc_track_caller(len + 1, gfp);                                
>         if (!buf)                                                                
>                 return NULL;                                                     
>                                                                                  
>         memcpy(buf, begin, len);                                                 
>         buf[len] = '\0';                                                            
>                                                                                  
>         return buf;                                                              
> }

What should the return be to this string?

" "

Should it be "" or " " or NULL?

I don't think it should be NULL.
I don't think it should be " ".

cheers, Joe

