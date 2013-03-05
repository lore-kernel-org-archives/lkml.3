Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072Ab3CERg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 12:36:57 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:46722 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab3CERgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 12:36:55 -0500
Message-ID: <1362505012.15793.128.camel@edumazet-glaptop>
Subject: Re: [RFC PATCH 3/5] ixgbe: Add support for ndo_ll_poll
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Eliezer Tamir <eliezer.tamir@linux.jf.intel.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dave Miller <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Tue, 05 Mar 2013 09:36:52 -0800
In-Reply-To: <1362504520.2791.46.camel@bwh-desktop.uk.solarflarecom.com>
References: <20130227175549.10611.82188.stgit@gitlad.jf.intel.com>
	 <20130227175606.10611.55498.stgit@gitlad.jf.intel.com>
	 <1362504410.2791.44.camel@bwh-desktop.uk.solarflarecom.com>
	 <1362504520.2791.46.camel@bwh-desktop.uk.solarflarecom.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-05 at 17:28 +0000, Ben Hutchings wrote:
> On Tue, 2013-03-05 at 17:26 +0000, Ben Hutchings wrote:
> > On Wed, 2013-02-27 at 09:56 -0800, Eliezer Tamir wrote:
> > > Add the ixgbe driver code implementing ndo_ll_poll.
> > > It should be easy for other drivers to do something similar
> > > in order to enable support for CONFIG_INET_LL_RX_POLL
> > 
> > Yes... in fact I wonder whether the lock and state couldn't be added to
> > napi_struct instead of being driver-specific.
> [...]
> 
> That would potentially allow GRO to detect that it's being called in
> low-latency context...

Not sure we have to add another test in fast path.

Users wanting polling support should disable GRO (ethtool -K eth0 gro
off)

Doing this dynamically would be nice of course.



