Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab3KAUs4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 16:48:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53954 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888Ab3KAUsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 16:48:54 -0400
Date: Fri, 1 Nov 2013 13:48:53 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        NeilBrown <neilb@suse.de>, Rob Herring <rob.herring@calxeda.com>,
        devicetree@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Strange location and name for platform  devices when device-tree
 is used.
Message-ID: <20131101204853.GB19662@kroah.com>
References: <20131101145925.66e22f73@notabene.brown>
 <1383279744.28909.26.camel@pasglop>
 <1383280054.28909.30.camel@pasglop>
 <20131101160329.37f3707b@notabene.brown>
 <1383282516.28909.36.camel@pasglop>
 <20131101180459.81793C40A28@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131101180459.81793C40A28@trevor.secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 11:04:59AM -0700, Grant Likely wrote:
> Second, I expect there is going to be userspace breakage to move them.
> I've considered moving them before, but so far have felt that being
> tidier hasn't been worth the potential breakage. Userspace /shouldn't/
> be relying on the node name, but we all know that userspace always does
> what it should, right?

Userspace should _never_ rely on where in the /sys/devices/ tree a
device is, if so, it's _really_ broken.  They should be iterating and
getting to the device from within the bus and class section of the tree
as devices move all over the place when the box boots different times.

thanks,

greg k-h
