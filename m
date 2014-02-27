Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaB0VtM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 16:49:12 -0500
Received: from smtprelay0143.hostedemail.com ([216.40.44.143]:35919 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750942AbaB0VtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 16:49:10 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2110:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:4605:5007:7652:7903:8603:10004:10400:10848:11026:11232:11658:11914:12438:12517:12519:12740:13069:13161:13229:13311:13357:14093:14097,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: shelf66_6cd0ff581362a
X-Filterd-Recvd-Size: 3322
Message-ID: <1393537746.24588.143.camel@joe-AO722>
Subject: Re: [PATCH V2] sparse: Allow override of sizeof(bool) warning
From: Joe Perches <joe@perches.com>
To: Christopher Li <sparse@chrisli.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ben Pfaff <blp@nicira.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Linux-Sparse <linux-sparse@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 27 Feb 2014 13:49:06 -0800
In-Reply-To: <CANeU7QnZika4XsdS_=UwPc5uZgv2-m5vMdmZLyCynKK2YNKLvQ@mail.gmail.com>
References: <1393462087.24588.50.camel@joe-AO722>
	 <530E8C2E.7080307@zytor.com> <1393466619.24588.65.camel@joe-AO722>
	 <20140227022857.GC23659@thin> <1393469594.24588.71.camel@joe-AO722>
	 <20140227025845.GA25145@thin> <530EB103.5070406@zytor.com>
	 <1393472326.24588.82.camel@joe-AO722> <20140227040050.GA8449@nicira.com>
	 <530EBCED.9020705@zytor.com> <20140227042636.GA9592@nicira.com>
	 <530EBFC7.9030309@zytor.com>
	 <CANeU7Q=RNXR00bQcPzJYTOcZmRSn3U31ZcadPTHu6Y_Uk0UnYw@mail.gmail.com>
	 <faa9e231-d561-417b-8b8b-95192cb0e56a@email.android.com>
	 <1393533563.24588.127.camel@joe-AO722>
	 <CANeU7QnZika4XsdS_=UwPc5uZgv2-m5vMdmZLyCynKK2YNKLvQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-27 at 12:55 -0800, Christopher Li wrote:
> On Thu, Feb 27, 2014 at 12:39 PM, Joe Perches <joe@perches.com> wrote:

> > Maybe the evaluate.c "size = bits_in_char;" assignment
> >
> >         if (size == 1 && is_bool_type(type)) {
> > -               warning(expr->pos, "expression using sizeof bool");
> > +               if (Wsizeof_bool)
> > +                       warning(expr->pos, "expression using sizeof bool");
> >                 size = bits_in_char;
> >         }
> >
> > should be
> >
> >         size = sizeof(_Bool) * 8;
> 
> The reason to use bits_in_xxxx is to allow sparse application to over write
> the size of int etc. If you don't like the bits_in_char here. You can introduce
> bits_in_bool and set that to sizeof(Bool)*8 by default. That way you don't
> hard code it.

There already is a bits_in_bool and it's default 1.

$ git grep -E "\bbits_in_\w+\s*=[^=]"
lib.c:          bits_in_long = 64;
lib.c:          bits_in_pointer = 64;
target.c:int bits_in_bool = 1;
target.c:int bits_in_char = 8;
target.c:int bits_in_short = 16;
target.c:int bits_in_int = 32;
target.c:int bits_in_long = 32;
target.c:int bits_in_longlong = 64;
target.c:int bits_in_longlonglong = 128;
target.c:int bits_in_float = 32;
target.c:int bits_in_double = 64;
target.c:int bits_in_longdouble = 80;
target.c:int bits_in_pointer = 32;
target.c:int bits_in_enum = 32;

> > And also, in sparse.1, Josh Triplett is shown as
> > the maintainer.  Maybe that should be changed to
> > Christopher Li
> 
> Maybe a separate patch.

That's fine with me too.  If you're the maintainer,
I think you should do that patch.  I don't see a need
for me to send any more right now though.

cheers, Joe

