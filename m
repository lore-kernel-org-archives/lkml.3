Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178Ab3CPKfm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 06:35:42 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:35880 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667Ab3CPKev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 06:34:51 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 5/6] OF: Introduce Device Tree resolve support.
To: Pantelis Antoniou <panto@antoniou-consulting.com>,
        David Gibson <david@gibson.dropbear.id.au>
Cc: Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jon Loeliger <jdl@jdl.com>, Tony Lindgren <tony@atomide.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Benoit Cousson <b-cousson@ti.com>, Mitch Bradley <wmb@firmworks.com>,
        Alan Tull <atull@altera.com>, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Koen Kooi <koen@dominion.thruhere.net>,
        Joel A Fernandes <agnel.joel@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Matt Ranostay <mranostay@gmail.com>
In-Reply-To: <060132B1-BB52-4C7F-B8D3-82B49BE49BB7@antoniou-consulting.com>
References: <1357327870-13615-1-git-send-email-panto@antoniou-consulting.com> <1357327870-13615-6-git-send-email-panto@antoniou-consulting.com> <20130121044836.GB24829@truffula.fritz.box> <EEEDB0B2-7410-456B-BED7-89FD5E407553@antoniou-consulting.com> <20130122040524.GG23500@truffula.fritz.box> <AB11FABF-6A45-493D-869D-7549FD758DD2@antoniou-consulting.com> <20130123044041.GS23500@truffula.fritz.box> <060132B1-BB52-4C7F-B8D3-82B49BE49BB7@antoniou-consulting.com>
Date: Sat, 16 Mar 2013 09:24:35 +0000
Message-Id: <20130316092435.9FA4B3E095B@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jan 2013 12:58:02 +0200, Pantelis Antoniou <panto@antoniou-consulting.com> wrote:
> Hi David,
> 
> On Jan 23, 2013, at 6:40 AM, David Gibson wrote:
> > Ok.  Nonetheless it's not hard to avoid a recursive approach here.
> 
> How can I find the maximum phandle value of a subtree without using recursion.
> Note that the whole function is just 6 lines long.

It's a failure in the existing kernel DT data structures. We need a hash
lookup for the phandles to eliminate the search entirely. Then you'd be
able to allocated new phandles on the fly easily and resolve phandles
without searching the whole tree (which has always been horrible).

That said, I'd like to punt on the whole phandle resolution thing. The
DT overlay support can be merged without the phandle resolution support
if the core rejects any overlays with phandle collisions.

g.
