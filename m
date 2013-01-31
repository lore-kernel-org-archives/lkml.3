Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab3AaUSz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 15:18:55 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:35701 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755503Ab3AaUSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 15:18:53 -0500
Date: Thu, 31 Jan 2013 14:07:31 -0600
From: Robert Jennings <rcj@linux.vnet.ibm.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCHv4 3/7] zswap: add to mm/
Message-ID: <20130131200731.GA11067@linux.vnet.ibm.com>
Mail-Followup-To: Seth Jennings <sjenning@linux.vnet.ibm.com>,
	Minchan Kim <minchan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Nitin Gupta <ngupta@vflare.org>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Dan Magenheimer <dan.magenheimer@oracle.com>,
	Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
	Johannes Weiner <jweiner@redhat.com>,
	Rik van Riel <riel@redhat.com>, Larry Woodman <lwoodman@redhat.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
References: <1359495627-30285-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <1359495627-30285-4-git-send-email-sjenning@linux.vnet.ibm.com>
 <20130131070716.GF23548@blaptop>
 <510AC0C6.4020705@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <510AC0C6.4020705@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13013120-5806-0000-0000-00001F003290
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Seth Jennings (sjenning@linux.vnet.ibm.com) wrote:
> On 01/31/2013 01:07 AM, Minchan Kim wrote:
> > On Tue, Jan 29, 2013 at 03:40:23PM -0600, Seth Jennings wrote:
> >> zswap is a thin compression backend for frontswap. It receives
> >> pages from frontswap and attempts to store them in a compressed
> >> memory pool, resulting in an effective partial memory reclaim and
> >> dramatically reduced swap device I/O.
> >>
> >> Additionally, in most cases, pages can be retrieved from this
> >> compressed store much more quickly than reading from tradition
> >> swap devices resulting in faster performance for many workloads.
> >>
> >> This patch adds the zswap driver to mm/
> >>
> >> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> >> ---
> >>  mm/Kconfig  |  15 ++
> >>  mm/Makefile |   1 +
> >>  mm/zswap.c  | 656 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >>  3 files changed, 672 insertions(+)
> >>  create mode 100644 mm/zswap.c
> >>
> >> diff --git a/mm/Kconfig b/mm/Kconfig
> >> index 278e3ab..14b9acb 100644
> >> --- a/mm/Kconfig
> >> +++ b/mm/Kconfig
> >> @@ -446,3 +446,18 @@ config FRONTSWAP
> >>  	  and swap data is stored as normal on the matching swap device.
> >>  
> >>  	  If unsure, say Y to enable frontswap.
> >> +
> >> +config ZSWAP
> >> +	bool "In-kernel swap page compression"
> >> +	depends on FRONTSWAP && CRYPTO
> >> +	select CRYPTO_LZO
> >> +	select ZSMALLOC
> > 
> > Again, I'm asking why zswap should have a dependent on CRPYTO?
> > Couldn't we support it as a option? I'd like to use zswap without CRYPTO
> > like zram.
> 
> The reason we need CRYPTO is that zswap uses it to support a pluggable
> compression model.  zswap can use any compressor that has a crypto API
> driver.  zswap has _symbol dependencies_ on CRYPTO.  If it isn't
> selected, the build breaks.

And we went with a pluggable model so that we could support hardware
accelerated compression engines like:

0e16aaf powerpc/crypto: add 842 hardware compression driver

--Rob Jennings

