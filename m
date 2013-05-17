Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab3EQQEk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 12:04:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41060 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601Ab3EQQEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 12:04:39 -0400
Date: Fri, 17 May 2013 17:04:31 +0100
From: Mel Gorman <mgorman@suse.de>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@sr71.net>, Joe Perches <joe@perches.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Hugh Dickens <hughd@google.com>, Paul Mackerras <paulus@samba.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCHv11 4/4] zswap: add documentation
Message-ID: <20130517160431.GO11497@suse.de>
References: <1368448803-2089-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <1368448803-2089-5-git-send-email-sjenning@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1368448803-2089-5-git-send-email-sjenning@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 07:40:03AM -0500, Seth Jennings wrote:
> This patch adds the documentation file for the zswap functionality
> 
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> ---
>  Documentation/vm/zswap.txt |   72 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 72 insertions(+)
>  create mode 100644 Documentation/vm/zswap.txt
> 
> diff --git a/Documentation/vm/zswap.txt b/Documentation/vm/zswap.txt
> new file mode 100644
> index 0000000..88384b3
> --- /dev/null
> +++ b/Documentation/vm/zswap.txt
> @@ -0,0 +1,72 @@
> +Overview:
> +
> +Zswap is a lightweight compressed cache for swap pages. It takes pages that are
> +in the process of being swapped out and attempts to compress them into a
> +dynamically allocated RAM-based memory pool.  If this process is successful,
> +the writeback to the swap device is deferred and, in many cases, avoided
> +completely.  This results in a significant I/O reduction and performance gains
> +for systems that are swapping.
> +

*Potentially* reduces IO and *potentially* shows performance gains. If the
system is swap trashing, this may make things worse as you're generating
the same amount of IO but having to compress/decompress as well. If there
is less physical memory available because zswap pool is fragmented then an
application may be pushed to swap prematurely and again, the performance
is worse. Don't oversell this and the comment applies throughout the
documentation.

I also think it should be marked with a bit fat warning that it's a WIP
and an additional warning that the performance characteristics are very
heavily workload dependant.

-- 
Mel Gorman
SUSE Labs
