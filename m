Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbaGHVkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 17:40:18 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:46526 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbaGHVkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 17:40:15 -0400
Date: Tue, 8 Jul 2014 17:40:10 -0400
From: Tejun Heo <tj@kernel.org>
To: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
Cc: sebastian.hesselbarth@gmail.com, kishon@ti.com,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH v9 3/7] ata: libahci: allow to use multiple PHYs
Message-ID: <20140708214010.GI4979@htj.dyndns.org>
References: <1404728173-20263-1-git-send-email-antoine.tenart@free-electrons.com>
 <1404728173-20263-4-git-send-email-antoine.tenart@free-electrons.com>
 <20140708134000.GC4979@htj.dyndns.org>
 <20140708170353.GA16148@kwain>
 <20140708171817.GH4979@htj.dyndns.org>
 <20140708174900.GC16148@kwain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140708174900.GC16148@kwain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Tue, Jul 08, 2014 at 07:49:00PM +0200, Antoine Ténart wrote:
> > So, yeah, it's being used both as input and output and we also have
> > the arguments which affect port_map, right?  It does seem confusing.
> 
> I do see priv->port_map as being automatically set and then restricted
> if needed by the port_map input here. I don't see how that's confusing.
> The only modification is we restrict the port_map parameter to the set
> of available ports. The port_map argument affected priv->port_map before
> this patch.

It is confusing.  If you wanna pass around available ports in hpriv,
please add a separate field and replace the arguments to
save_initial_config().

> > Well, so does clk.  Let's say clk is more restricted and phy can be
> > one or more per port and thus needs to be dynamic.  If so, shouldn't
> > we at least have some correlation between phys and ports?  It bothers
> > me that now libahci is carrying random number of resources that it has
> > no idea how to associate with the ports it manages.  What if later we
> > want to involve phy driver in power managing unoccupied ports?
> 
> I see. This is a first (working) attempt to have a one node per port. I
> agree that would be nice to have a correlation between ports and PHYs.
> This can definitively be added when needed without changing the dt
> bindings as only the internal representation changes. This would also
> require to get all phys from the port nodes, which is again internal
> stuff.
> 
> Don't you think we can go by steps, and have a following up series for
> this when needed (like in a power managing series for unoccupied ports)?

I don't know.  It isn't exactly difficult to make it per-port, is it?
We already have ahci_port_priv and wouldn't the code actually be
simpler that way?

Thanks.

-- 
tejun
