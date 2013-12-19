Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab3LSQcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:32:18 -0500
Received: from smtprelay0148.hostedemail.com ([216.40.44.148]:36785 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752854Ab3LSQcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:32:14 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:599:800:960:967:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1801:2194:2199:2393:2525:2553:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3870:3871:3872:3873:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4605:5007:7652:7903:9025:9108:10004:10400:10848:11026:11232:11658:11914:12043:12295:12438:12517:12519:12740:13095:13161:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: front03_6a9b04746ce27
X-Filterd-Recvd-Size: 3143
Message-ID: <1387470731.2353.7.camel@joe-AO722>
Subject: Re: Lindent formatting issues
From: Joe Perches <joe@perches.com>
To: Laszlo Papp <lpapp@kde.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Thu, 19 Dec 2013 08:32:11 -0800
In-Reply-To: <CAOMwXhNVJ8HPCe6t=VkCthEiOqNtOczz5Xqy_ciM7rsqWRVOYw@mail.gmail.com>
References: <CAOMwXhPPN2h2boAOn1=BaHuWa+9nYw=oe1u1bYHtHGyad9Kw8A@mail.gmail.com>
	 <1387310726.8859.5.camel@joe-AO722>
	 <CAOMwXhNVJ8HPCe6t=VkCthEiOqNtOczz5Xqy_ciM7rsqWRVOYw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-19 at 16:17 +0000, Laszlo Papp wrote:
> On Tue, Dec 17, 2013 at 8:05 PM, Joe Perches <joe@perches.com> wrote:
[]
> > You could also use scripts/checkpatch.pl with
> > the --fix option.
> >
> > ./scripts/checkpatch.pl -f --fix <file>
> >
> > with various --types=<TYPE,...> options.
> >
> > Maybe use: https://lkml.org/lkml/2013/9/23/504
> 
> Thanks Joe. I seem to have further issues with this tool... I tried to
> run it on a file I patched, but it generated a lot of noise unrelated
> to my logical change... :(

checkpatch is really for patches.  Using -f is a
convenience ability.  You can limit what messages
checkpatch emits by using "--types=<FOO[,BAR...]>"

You can show what message classifications are being
used by adding "--show-types".

> Do you happen to know what the best way is to fix it in such cases? I
> am providing some examples below:
> 
>         if (devattr == &sensor_dev_attr_fan1_max_alarm.dev_attr
> -        || devattr == &sensor_dev_attr_fan1_min_alarm.dev_attr
> -        || devattr == &sensor_dev_attr_fan1_fault.dev_attr
> -        || devattr == &sensor_dev_attr_gpio1_alarm.dev_attr
> -        || devattr == &sensor_dev_attr_gpio2_alarm.dev_attr) {
> +           || devattr == &sensor_dev_attr_fan1_min_alarm.dev_attr
> +           || devattr == &sensor_dev_attr_fan1_fault.dev_attr
> +           || devattr == &sensor_dev_attr_gpio1_alarm.dev_attr
> +           || devattr == &sensor_dev_attr_gpio2_alarm.dev_attr) {

Well, here the general kernel style is to put
the logical && or || test at the end of the
previous line so:

	if (devattr == &sensor_dev_attr_fan1_max_alarm.dev_attr ||
	    devattr == &sensor_dev_attr_fan1_min_alarm.dev_attr ||
	    devattr == &sensor_dev_attr_fan1_fault.dev_attr ||
	    devattr == &sensor_dev_attr_gpio1_alarm.dev_attr ||
	    devattr == &sensor_dev_attr_gpio2_alarm.dev_attr) {

would likely be preferred.

> -                                   int n)
> +                                    int n)

This may be indentation alignment but I don't follow
how this is a problem.

> -       int sysfs_modes[4] = {0, 1, 2, 1};
> +       int sysfs_modes[4] = { 0, 1, 2, 1 };

Is this change from Lindent or checkpatch?

