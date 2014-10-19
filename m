Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbaJSPFt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 11:05:49 -0400
Received: from smtprelay0027.hostedemail.com ([216.40.44.27]:54786 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752001AbaJSPFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 11:05:47 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2393:2525:2560:2563:2682:2685:2692:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3354:3622:3865:3867:3868:3870:3871:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4470:4605:5007:6117:6119:6261:6691:7903:9025:10004:10400:10848:11232:11233:11658:11914:12043:12517:12519:12740:13019:13069:13161:13229:13311:13357:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: glove60_15345ab2c884a
X-Filterd-Recvd-Size: 3019
Message-ID: <1413731134.14629.13.camel@perches.com>
Subject: Re: [PATCH 1/5] lib: string.c: Added a function strzcpy
From: Joe Perches <joe@perches.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 19 Oct 2014 08:05:34 -0700
In-Reply-To: <CAFo99gaLyzQoLAyBw9uEU=qiDnESH-rP1NL_+w8JLDw6BQMhaw@mail.gmail.com>
References: <1413669800-6058-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	 <1413682735.14629.11.camel@perches.com>
	 <CAFo99gaLyzQoLAyBw9uEU=qiDnESH-rP1NL_+w8JLDw6BQMhaw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-10-19 at 14:19 +0200, Rickard Strandqvist wrote:
> 2014-10-19 3:38 GMT+02:00 Joe Perches <joe@perches.com>:
> > On Sun, 2014-10-19 at 00:03 +0200, Rickard Strandqvist wrote:
> >> Added a function strzcpy which works the same as strncpy,
> >> but guaranteed to produce the trailing null character.
> >>
> >> There are many places in the code where strncpy used although it
> >> must be zero terminated, and switching to strlcpy is not an option
> >> because the string must nonetheless be fyld with zero characters.
> > []
> >> diff --git a/lib/string.c b/lib/string.c
> > []
> >> +char *strzcpy(char *dest, const char *src, size_t count)
> >> +{
> >> +     char *tmp = dest;
> >> +
> >> +     while (count) {
> >> +             if ((*tmp = *src) != 0)
> >> +                     src++;
> >> +             tmp++;
> >> +             count--;
> >> +     }
> >> +
> >> +     if (dest != tmp)
> >> +             *--tmp = '\0';
> >> +
> >> +     return dest;
> >> +}
> >
> > why not
> >
> > char *strzcpy(char *dest, const char *src, size_t count)
> > {
> >         strncpy(dest, src, count)
> >         if (count)
> >                 dest[count - 1] = 0; /* or '\0' or whatever */
> >
> >         return dest;
> > }
> >
> > maybe use static inline too.
> >
> 
> Hi Joe
> 
> Yes this solution have also been discussed.
> https://lkml.org/lkml/2014/10/16/682
> 
> Very possible that it is a better solution.
> The code that I use in strzcpy is not the way I'd written it, but is
> the same as in strncpy now.
> 
> But as I understand it the real strncpy code is normally highly
> optimized for the hardware it runs on.
> Ex: arch/x86/lib/string_32.c

The fact that optimized strncpy variants exist
for any platform is the argument _for_ using it
in strzcpy.

> But missing for x86 64 bit and Arm..?



