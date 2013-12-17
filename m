Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab3LQVgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 16:36:21 -0500
Received: from smtprelay0220.hostedemail.com ([216.40.44.220]:41548 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751112Ab3LQVgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 16:36:20 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:599:960:967:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1500:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4605:4823:5007:7652:9025:10004:10400:10848:11232:11233:11658:11914:12043:12517:12519:12663:12679:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rain38_5542071307917
X-Filterd-Recvd-Size: 1712
Message-ID: <1387310726.8859.5.camel@joe-AO722>
Subject: Re: Lindent formatting issues
From: Joe Perches <joe@perches.com>
To: Laszlo Papp <lpapp@kde.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <CAOMwXhPPN2h2boAOn1=BaHuWa+9nYw=oe1u1bYHtHGyad9Kw8A@mail.gmail.com>
References: <CAOMwXhPPN2h2boAOn1=BaHuWa+9nYw=oe1u1bYHtHGyad9Kw8A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 17 Dec 2013 12:05:26 -0800
Mime-Version: 1.0
X-Mailer: Evolution 3.8.4-0ubuntu1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-17 at 15:06 +0000, Laszlo Papp wrote:
> ./scripts/Lindent seems to be working OK, but there are a few minor
> issues like this:
> 
> static struct i2c_driver max6651_driver = {
>         .driver = {
> -               .name = "gpio-max6651",
> -               .owner = THIS_MODULE,
> -       },
> +                  .name = "gpio-max6651",
> +                  .owner = THIS_MODULE,
> +                  },
> 
> Is there an option or something to mkae it work automatically? I am
> referring to the "}," line which should not have changed.

Assuming that was a copy/paste translation of
tabs to spaces, the first form is more common
in kernel sources and Lindent isn't doing the
right thing here.

You could also use scripts/checkpatch.pl with
the --fix option.

./scripts/checkpatch.pl -f --fix <file>

with various --types=<TYPE,...> options.

Maybe use: https://lkml.org/lkml/2013/9/23/504


