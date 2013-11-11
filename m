Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab3KLCho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 21:37:44 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:62184 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab3KLChK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 21:37:10 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/5] OF: Clear detach flag on attach
To: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>
Cc: Gerhard Sittig <gsi@denx.de>, Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <99B265B8-F5D0-4138-BA1E-0F09C95A60F4@antoniou-consulting.com>
References: <1383673816-29293-1-git-send-email-panto@antoniou-consulting.com> <1383673816-29293-2-git-send-email-panto@antoniou-consulting.com> <20131105194310.GB17929@book.gsilab.sittig.org> <033B1C12-1AD8-44E3-A9BE-C216AEBA45F2@antoniou-consulting.com> <527A01C9.2090306@nsn.com> <99B265B8-F5D0-4138-BA1E-0F09C95A60F4@antoniou-consulting.com>
Date: Mon, 11 Nov 2013 16:05:32 +0000
Message-Id: <20131111160533.07E8BC42303@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Nov 2013 10:49:44 +0200, Pantelis Antoniou <panto@antoniou-consulting.com> wrote:
> On Nov 6, 2013, at 10:46 AM, Alexander Sverdlin wrote:
> 
> > Hello Pantelis,
> > 
> > On 05/11/13 21:03, ext Pantelis Antoniou wrote:
> >> On Nov 5, 2013, at 9:43 PM, Gerhard Sittig wrote:
> >>>> --- a/drivers/of/base.c
> >>>> +++ b/drivers/of/base.c
> >>>> @@ -1641,6 +1641,7 @@ int of_attach_node(struct device_node *np)
> >>>> 	np->allnext = of_allnodes;
> >>>> 	np->parent->child = np;
> >>>> 	of_allnodes = np;
> >>>> +	of_node_clear_flag(np, OF_DETACHED);
> >>>> 	raw_spin_unlock_irqrestore(&devtree_lock, flags);
> >>>> 
> >>>> 	of_add_proc_dt_entry(np);
> >>> 
> >>> Does this add a call to a routine which only gets introduced in a
> >>> subsequent patch (2/5)?  If so, it would break builds during the
> >>> series, and thus would hinder bisection.
> >>> 
> >> 
> >> You're right, I'll re-order on the next series.
> > 
> > Is it necessary at all now, after these fixes:
> > 9e401275 of: fdt: fix memory initialization for expanded DT
> > 0640332e of: Fix missing memory initialization on FDT unflattening
> > 92d31610 of/fdt: Remove duplicate memory clearing on FDT unflattening
>
> Hi Alexander,
> 
> I'm not exactly sure, but I think it is still needed.
> Since at that point the tree is attached.
> 
> Grant?

In one sense it is a little odd because it isn't something that any of
the existing users (of which there are 2) would be affected by. It isn't
a bad idea though. Merged patches 2 & 1.

g.


