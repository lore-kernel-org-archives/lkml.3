Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304Ab3BFWYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:24:43 -0500
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:51882 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152Ab3BFWYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:24:40 -0500
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Wed, 6 Feb 2013 17:24:38 -0500
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Li Yang <leoli@freescale.com>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: ethtool occationally fails to communicate with with ucc_geth
Message-ID: <20130206222438.GK30788@csclub.uwaterloo.ca>
References: <20130206200504.GJ30788@csclub.uwaterloo.ca>
 <1360184912.2659.27.camel@bwh-desktop.uk.solarflarecom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360184912.2659.27.camel@bwh-desktop.uk.solarflarecom.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 09:08:32PM +0000, Ben Hutchings wrote:
> This seems to be a workaround for a bug in phylib: phy_state_machine()
> calls netif_carrier_on() before adjust_link(), so the TX scheduler can
> start immediately even though the MAC has not been configured.
> 
> A better workaround would be to use netif_carrier_{off,on}() in
> ugeth_{quiesce,activate}() respectively instead of
> netif_device_{detach,attach}().  But I think phylib really ought to be
> fixed.

I am willing to try things, but this is certainly in parts of the network
stack I don't normally poke around in and hence don't know how works.

I just managed to track it down this far. :)

I can try the carrier_off/on in place of the detach/attach and see if
it works.

-- 
Len Sorensen
