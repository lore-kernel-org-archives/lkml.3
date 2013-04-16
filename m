Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935604Ab3DPIYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 04:24:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932147Ab3DPIYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 04:24:04 -0400
Date: Tue, 16 Apr 2013 09:23:59 +0100
From: Joe Thornber <thornber@redhat.com>
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        device-mapper development <dm-devel@redhat.com>,
        Kent Overstreet <koverstreet@google.com>,
        Amit Kale <akale@stec-inc.com>, ejt@redhat.com
Subject: Re: bcache/dmcache/enhanceio bake-off
Message-ID: <20130416082358.GA30728@debian>
Mail-Followup-To: Mike Snitzer <snitzer@redhat.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
	device-mapper development <dm-devel@redhat.com>,
	Kent Overstreet <koverstreet@google.com>,
	Amit Kale <akale@stec-inc.com>, ejt@redhat.com
References: <20130411072239.GD8910@blackbox.djwong.org>
 <20130413160925.GA5236@debian>
 <20130413193319.GD8156@redhat.com>
 <20130415135539.GA19977@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130415135539.GA19977@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 09:55:39AM -0400, Mike Snitzer wrote:
> On Sat, Apr 13 2013 at  3:33pm -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > On Sat, Apr 13 2013 at 12:09pm -0400,
> > Joe Thornber <thornber@redhat.com> wrote:
> > 
> > > Hi Darrick,
> > > 
> > > On Thu, Apr 11, 2013 at 12:22:39AM -0700, Darrick J. Wong wrote:
> > > > Hi all,
> > > > 
> > > > Lately I've been having some fun playing with bcache, dmcache, and enhanceio.
> > > 
> > > I pushed some tweaks to the mq policy today to my thin-dev tree.  They
> > > show some improvements to these fio based tests.
> > > 
> > > In addition I've written a blog post trying to explain what's going on in dm-cache:
> > > http://device-mapper.org/blog/2013/04/13/benchmarking-dm-cache-with-fio/
> > 
> > Darrick,
> > 
> > Joe has a few other dm-cache-target.c changes in his thin-dev branch
> > that are required in order to realize the gains from his mq changes.  I
> > haven't yet isolated which changes are important but if I just use the
> > 3.9-rc6's dm-cache-tagret.c with thin-dev's mq changes I cannot
> > reproduce the improved performance Joe mentions in his blog post.
> 
> I've now isolated the dm-cache-target.c commit in Joe's thin-dev that is
> important to have in conjunction with the mq changes (from commit 7362f43a):
> 
> commit f134e6382a534dd3622c3850e4824ae5929885d9
> Author: Joe Thornber <ejt@redhat.com>
> Date:   Wed Mar 27 14:46:57 2013 +0000
> 
>     [dm-cache] Change the default migration_threshold to something more suitable.
> 
> diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
> index 8a4bcf3..f215307 100644
> --- a/drivers/md/dm-cache-target.c
> +++ b/drivers/md/dm-cache-target.c
> @@ -1948,7 +1948,7 @@ static sector_t calculate_discard_block_size(sector_t cache_block_size,
>  	return discard_block_size;
>  }
>  
> -#define DEFAULT_MIGRATION_THRESHOLD (2048 * 100)
> +#define DEFAULT_MIGRATION_THRESHOLD 2048
>  
>  static int cache_create(struct cache_args *ca, struct cache **result)
>  {

You'll certainly need the new mq writeback stuff too.  I don't know
why you're intent on cherry picking.

- Joe
