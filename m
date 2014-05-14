Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210AbaENQNq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 12:13:46 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:33950 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280AbaENQNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 12:13:44 -0400
Date: Wed, 14 May 2014 09:13:31 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Michael Stickel <ms@mycable.de>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: Re: [PATCH v4 2/8] OF: Introduce DT overlay support.
Message-ID: <20140514161331.GA18032@roeck-us.net>
References: <1396615441-29630-1-git-send-email-pantelis.antoniou@konsulko.com>
 <1396615441-29630-3-git-send-email-pantelis.antoniou@konsulko.com>
 <20140514100856.5198DC4153D@trevor.secretlab.ca>
 <53735D88.5090108@mycable.de>
 <20140514154907.BC65DC40BD2@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140514154907.BC65DC40BD2@trevor.secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 04:49:07PM +0100, Grant Likely wrote:
> On Wed, 14 May 2014 14:11:52 +0200, Michael Stickel <ms@mycable.de> wrote:
> > Hi Grant,
> > 
> > Am 14.05.2014 12:08, schrieb Grant Likely:
> > > More generally I am concerned about whether or not overlays
> > > will introduce corner cases that can never be handled correctly,
> > > particularly in how multiple overlays will get handled. I want to see
> > > very clear rules on what happens when multiple overlays are applied, and
> > > then removed again. Is it possible to remove overlays out of order? If
> > > so, what are the conditions that would not be allowed?
> > 
> > Yes, it is possible that an overlay depends on another.
> > 
> > The problem is not, that an overlay is removed other overlays depend on,
> > but that nodes of an overlay may depend on the to-be-removed overlay and
> > the resulting devicetree can become inconsistent.
> 
> So what should the rule be then? It sounds to me that it should be a
> hard and fast rule for overlays to always be removed in-order. If two
> overlays are applied, and the first one needs to be removed again, then
> that forces a removal of the second. The code needs to enforce it too.
> 
> The question can be revisited if someone can find a way to validate
> overlays do not conflict.
> 
We'll need to find a way to determine if overlays are nested. Only nested
overlays must be removed in order. Otherwise the entire concept falls apart.
In our case, overlays are used for hot plugged cards. Obviously there can
and will be more than one of those cards in the system, and they can
and will be inserted and removed in any order.

Maybe a nesting level counter in each property would do it ? Or a reference
pointing to overlay specific objects / data ?

Guenter
