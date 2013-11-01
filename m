Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab3KAQIg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 12:08:36 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53429 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab3KAQIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 12:08:35 -0400
Date: Fri, 1 Nov 2013 12:08:02 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Doug Ledford <dledford@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, David Laight <David.Laight@ACULAB.COM>
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
Message-ID: <20131101160802.GB8467@hmsreliant.think-freely.org>
References: <201310300525.r9U5Pdqo014902@ib.usersys.redhat.com>
 <20131030110214.GA10220@localhost.localdomain>
 <52710B09.6090302@redhat.com>
 <20131031183003.GC25894@hmsreliant.think-freely.org>
 <1383320566.1737.0.camel@bwh-desktop.uk.level5networks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383320566.1737.0.camel@bwh-desktop.uk.level5networks.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 03:42:46PM +0000, Ben Hutchings wrote:
> On Thu, 2013-10-31 at 14:30 -0400, Neil Horman wrote:
> [...]
> > It
> > functions, but unfortunately the performance lost to the completely broken
> > branch prediction that this inflicts makes it a non starter:
> [...]
> 
> Conditional branches are no good but conditional moves might be worth a shot.
> 
> Ben.
> 
How would you suggest replacing the jumps in this case?  I agree it would be
faster here, but I'm not sure how I would implement an increment using a single
conditional move.
Neil

> -- 
> Ben Hutchings, Staff Engineer, Solarflare
> Not speaking for my employer; that's the marketing department's job.
> They asked us to note that Solarflare product names are trademarked.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
