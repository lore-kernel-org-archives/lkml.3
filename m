Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795Ab3CSLvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 07:51:13 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:52793 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752023Ab3CSLvK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 07:51:10 -0400
Subject: Re: [PATCH 5/6] OF: Introduce Device Tree resolve support.
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20130316092435.9FA4B3E095B@localhost>
Date: Tue, 19 Mar 2013 13:51:01 +0200
Cc: David Gibson <david@gibson.dropbear.id.au>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
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
Content-Transfer-Encoding: 8BIT
Message-Id: <6BBAEB5D-D4E0-4276-B3B8-468C30547E75@antoniou-consulting.com>
References: <1357327870-13615-1-git-send-email-panto@antoniou-consulting.com> <1357327870-13615-6-git-send-email-panto@antoniou-consulting.com> <20130121044836.GB24829@truffula.fritz.box> <EEEDB0B2-7410-456B-BED7-89FD5E407553@antoniou-consulting.com> <20130122040524.GG23500@truffula.fritz.box> <AB11FABF-6A45-493D-869D-7549FD758DD2@antoniou-consulting.com> <20130123044041.GS23500@truffula.fritz.box> <060132B1-BB52-4C7F-B8D3-82B49BE49BB7@antoniou-consulting.com> <20130316092435.9FA4B3E095B@localhost>
To: Grant Likely <grant.likely@secretlab.ca>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Mar 16, 2013, at 11:24 AM, Grant Likely wrote:

> On Wed, 23 Jan 2013 12:58:02 +0200, Pantelis Antoniou <panto@antoniou-consulting.com> wrote:
>> Hi David,
>> 
>> On Jan 23, 2013, at 6:40 AM, David Gibson wrote:
>>> Ok.  Nonetheless it's not hard to avoid a recursive approach here.
>> 
>> How can I find the maximum phandle value of a subtree without using recursion.
>> Note that the whole function is just 6 lines long.
> 
> It's a failure in the existing kernel DT data structures. We need a hash
> lookup for the phandles to eliminate the search entirely. Then you'd be
> able to allocated new phandles on the fly easily and resolve phandles
> without searching the whole tree (which has always been horrible).
> 

Yes, it is pretty obvious that the in-kernel data structures are sub-optimal.
But I was not after modifying them, since that's a different kind of problem.

Since we're having a 'sub-optimal' data structures, I'd like to point out that
the usage of of_find_by_name(), mostly by drivers trying to find a child
of their own node, works by a lucky accident of how the device nodes are instantiated
by the flat tree loader. Most of the use cases should be replaced by a call
to of_get_child_by_name() which does the right thing.

> That said, I'd like to punt on the whole phandle resolution thing. The
> DT overlay support can be merged without the phandle resolution support
> if the core rejects any overlays with phandle collisions.
> 


Fair enough, but be warned that phandle resolution the overlay feature is mostly useless.

In actual practice the amount of driver nodes that can be overlaid without a single case
of referencing phandles outside (or within) their own blob is close to zero.

> g.

Regards

-- Pantelis

