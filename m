Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab3EUVG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 17:06:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535Ab3EUVG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 17:06:56 -0400
Date: Tue, 21 May 2013 18:06:32 -0300
From: Rafael Aquini <aquini@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, hughd@google.com, shli@kernel.org,
        kzak@redhat.com, jmoyer@redhat.com, riel@redhat.com,
        lwoodman@redhat.com, mgorman@suse.de
Subject: Re: [RFC PATCH 01/02] swap: discard while swapping only if
 SWAP_FLAG_DISCARD_CLUSTER
Message-ID: <20130521210628.GD20178@optiplex.redhat.com>
References: <cover.1369092449.git.aquini@redhat.com>
 <e3ae11727f13e1580ae66ce80845e9002ec90ea6.1369092449.git.aquini@redhat.com>
 <519AC605.4070709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519AC605.4070709@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Howdy Kosaki-san,

Thanks for your time over this one :)

On Mon, May 20, 2013 at 08:55:33PM -0400, KOSAKI Motohiro wrote:
> (5/20/13 8:04 PM), Rafael Aquini wrote:
> > Intruduce a new flag to make page-cluster fine-grained discards while swapping
> > conditional, as they can be considered detrimental to some setups. However,
> > keep allowing batched discards at sys_swapon() time, when enabled by the
> > system administrator. 
> > 
> > Signed-off-by: Rafael Aquini <aquini@redhat.com>
> > ---
> >  include/linux/swap.h |  8 +++++---
> >  mm/swapfile.c        | 12 ++++++++----
> >  2 files changed, 13 insertions(+), 7 deletions(-)
> > 
> > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > index 1701ce4..ab2e742 100644
> > --- a/include/linux/swap.h
> > +++ b/include/linux/swap.h
> > @@ -19,10 +19,11 @@ struct bio;
> >  #define SWAP_FLAG_PREFER	0x8000	/* set if swap priority specified */
> >  #define SWAP_FLAG_PRIO_MASK	0x7fff
> >  #define SWAP_FLAG_PRIO_SHIFT	0
> > -#define SWAP_FLAG_DISCARD	0x10000 /* discard swap cluster after use */
> > +#define SWAP_FLAG_DISCARD	0x10000 /* enable discard for swap areas */
> > +#define SWAP_FLAG_DISCARD_CLUSTER 0x20000 /* discard swap clusters after use */
> 
> From point of backward compatibility view, 0x10000 should be disable both discarding
> when mount and when IO.

I think you mean 0x10000 should be enable both here, then. That's a nice catch. I'll
try to think a way to accomplish it in a simple fashion.


> And, introducing new two flags, enable mount time discard and enable IO time discard.
> 
> IOW, Please consider newer kernel and older swapon(8) conbination.
> Other than that, looks good to me.
> 
> 
