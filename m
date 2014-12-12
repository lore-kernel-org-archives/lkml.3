Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbaLLWpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 17:45:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58569 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779AbaLLWpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 17:45:18 -0500
Date: Fri, 12 Dec 2014 23:45:15 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Vinson Lee <vlee@twopensource.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Michal Hocko <mhocko@suse.cz>, Josh Triplett <josh@joshtriplett.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Fabian Frederick <fabf@skynet.be>,
        Bertrand Jacquin <beber@meleeweb.net>,
        Andy Lutomirski <luto@amacapital.net>,
        Pranith Kumar <bobby.prani@gmail.com>,
        Peter Foley <pefoley2@pefoley.com>,
        Clark Williams <clark.williams@gmail.com>,
        Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        Nate Stahl <stahl@twitter.com>, Vinson Lee <vlee@twitter.com>
Subject: Re: [PATCH] Increase maximum size of dmesg buffer to 16MB.
Message-ID: <20141212224515.GU25677@wotan.suse.de>
References: <1418423906-5461-1-git-send-email-vlee@twopensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418423906-5461-1-git-send-email-vlee@twopensource.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 02:38:26PM -0800, Vinson Lee wrote:
> From: Nate Stahl <stahl@twitter.com>
> 
> A full task stack dump of all tasks on a machine can generate more than
> 4MB of output to dmesg. Dumping this data to the serial console causes
> the machine to hang for a number of minutes (an unacceptable impact),
> but dumping the same data to memory is feasible if the dmesg buffer is
> sized large enough to hold the output. Set to 16MB which will hopefully
> be large enough to handle a dump from any of our servers at this time.
> 
> Signed-off-by: Nate Stahl <stahl@twitter.com>
> Signed-off-by: Vinson Lee <vlee@twitter.com>

Isn't this the perpetual issue of having large number of CPUs? If so
consider use of LOG_CPU_MAX_BUF_SHIFT instead, otherwise clarifying how
this would be a different issue would be good. LOG_CPU_MAX_BUF_SHIFT
should scale nicely but you can increase it as well, is it being used?

 Luis
