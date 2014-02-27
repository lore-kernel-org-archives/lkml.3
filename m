Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568AbaB0Uj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 15:39:28 -0500
Received: from smtprelay0097.hostedemail.com ([216.40.44.97]:54656 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751202AbaB0Uj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 15:39:26 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2198:2199:2393:2553:2559:2562:2731:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:4605:5007:7652:8603:9121:10004:10400:10848:11026:11232:11658:11914:12296:12517:12519:12663:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: talk84_522441b30a50e
X-Filterd-Recvd-Size: 2479
Message-ID: <1393533563.24588.127.camel@joe-AO722>
Subject: Re: [PATCH V2] sparse: Allow override of sizeof(bool) warning
From: Joe Perches <joe@perches.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christopher Li <sparse@chrisli.org>, Ben Pfaff <blp@nicira.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Linux-Sparse <linux-sparse@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 27 Feb 2014 12:39:23 -0800
In-Reply-To: <faa9e231-d561-417b-8b8b-95192cb0e56a@email.android.com>
References: <1393462087.24588.50.camel@joe-AO722>
	 <530E8C2E.7080307@zytor.com> <1393466619.24588.65.camel@joe-AO722>
	 <20140227022857.GC23659@thin> <1393469594.24588.71.camel@joe-AO722>
	 <20140227025845.GA25145@thin> <530EB103.5070406@zytor.com>
	 <1393472326.24588.82.camel@joe-AO722> <20140227040050.GA8449@nicira.com>
	 <530EBCED.9020705@zytor.com> <20140227042636.GA9592@nicira.com>
	 <530EBFC7.9030309@zytor.com>
	 <CANeU7Q=RNXR00bQcPzJYTOcZmRSn3U31ZcadPTHu6Y_Uk0UnYw@mail.gmail.com>
	 <faa9e231-d561-417b-8b8b-95192cb0e56a@email.android.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-27 at 12:26 -0800, H. Peter Anvin wrote:
> On February 27, 2014 12:22:45 PM PST, Christopher Li <sparse@chrisli.org> wrote:
> >OK. I get it nobody wants a sizeof(_Bool) warning.
> >I am going to apply this patch.

Please use V3 as I stuffed up the alphabetic order
of sizeof and shadow.

> >Should we change the default to off then?
> I would.

I'm not sure it matters much, but the linux-kernel
Makefile wouldn't need to be changed if Wsizeof_bool
is default 0.

Here's a couple of other nits:

Maybe the evaluate.c "size = bits_in_char;" assignment

        if (size == 1 && is_bool_type(type)) {
-               warning(expr->pos, "expression using sizeof bool");
+               if (Wsizeof_bool)
+                       warning(expr->pos, "expression using sizeof bool");
                size = bits_in_char;
        }

should be

	size = sizeof(_Bool) * 8;

And also, in sparse.1, Josh Triplett is shown as
the maintainer.  Maybe that should be changed to
Christopher Li


