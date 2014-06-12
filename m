Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbaFLOSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 10:18:44 -0400
Received: from smtprelay0141.hostedemail.com ([216.40.44.141]:45585 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752874AbaFLOSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 10:18:39 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2551:2553:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3870:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:7652:7904:9025:10004:10400:10848:11232:11658:11914:12043:12050:1229
X-HE-Tag: trip37_67d8dded62226
X-Filterd-Recvd-Size: 2466
Message-ID: <1402582711.9947.17.camel@joe-AO725>
Subject: Re: [PATCH V2 08/19] irqchip: crossbar: fix checkpatch warning
From: Joe Perches <joe@perches.com>
To: Sricharan R <r.sricharan@ti.com>
Cc: Jason Cooper <jason@lakedaemon.net>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, tony@atomide.com,
        santosh.shilimkar@ti.com, nm@ti.com, rnayak@ti.com,
        linux@arm.linux.org.uk, tglx@linutronix.de
Date: Thu, 12 Jun 2014 07:18:31 -0700
In-Reply-To: <5399AC9C.4080602@ti.com>
References: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
	 <1402574007-13987-9-git-send-email-r.sricharan@ti.com>
	 <20140612131042.GU8664@titan.lakedaemon.net> <5399AC9C.4080602@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-12 at 19:05 +0530, Sricharan R wrote:
> On Thursday 12 June 2014 06:40 PM, Jason Cooper wrote:
> > On Thu, Jun 12, 2014 at 05:23:16PM +0530, Sricharan R wrote:
> >> diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
[]
> >> @@ -34,7 +34,8 @@ struct crossbar_device {
> >>  	uint *irq_map;
> >>  	void __iomem *crossbar_base;
> >>  	int *register_offsets;
> >> -	void (*write) (int, int);
> >> +
> >> +	void (*write)(int, int);
> > 
> > The empty line here looks bogus to me.

Good eye.  It's unnecessary.

>   Did you re-run checkpatch after
> > fixing the unnecessary space to see if it still complained about having
> > a 'blank line after declarations'?
> > 
>  Yes, it still complains even after fixing unnecessary space.

It's a checkpatch defect.

It's been fixed by:
https://lkml.org/lkml/2014/6/6/426

> > I'm generally opposed to these sorts of checkpatch patches, especially
> > when they are just warnings.  It's great for a new driver in the staging
> > tree, but it makes backporting future bugfixes that much harder when
> > drivers have been live in mainline.

Blind adherence to checkpatch isn't always a great idea.

But bugfix backports haven't been much of an issue in
other subsystems with fairly active whitespace/style
changes.


