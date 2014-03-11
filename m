Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbaCKRt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 13:49:26 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:52936 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232AbaCKRtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 13:49:22 -0400
X-Originating-IP: 98.158.13.34
Date: Tue, 11 Mar 2014 10:49:15 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/5] bug: When !CONFIG_BUG, simplify WARN_ON_ONCE and
 family
Message-ID: <20140311174914.GA3101@leaf>
References: <469b5dc113cb468232291527642f8dc47663e945.1393385236.git.josh@joshtriplett.org>
 <6915585.VegnvotSUi@wuerfel>
 <17c859aa7dcccec43df0a0c8908911b982764c76.1394412745.git.josh@joshtriplett.org>
 <201403111740.25606.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201403111740.25606.arnd@arndb.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 05:40:25PM +0100, Arnd Bergmann wrote:
> On Monday 10 March 2014, Josh Triplett wrote:
> > 
> > When !CONFIG_BUG, WARN_ON and family become simple passthroughs of their
> > condition argument; however, WARN_ON_ONCE and family still have
> > conditions and a boolean to detect one-time invocation, even though the
> > warning they'd emit doesn't exist.  Make the existing definitions
> > conditional on CONFIG_BUG, and add definitions for !CONFIG_BUG that map
> > to the passthrough versions of WARN and WARN_ON.
> > 
> > This saves 4.4k on a minimized configuration (smaller than
> > allnoconfig), and 20.6k with defconfig plus CONFIG_BUG=n.
> > 
> > Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> > ---
> > v3: Patch unchanged from v2.
> > 
> > Andrew, can you please replace the entire v2 series currently in -mm
> > with this new series?
> 
> 
> [all patches]
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Thanks!

- Josh Triplett
