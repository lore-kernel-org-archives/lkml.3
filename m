Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab3LMB4L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 20:56:11 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:63613 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab3LMB4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 20:56:07 -0500
X-AuditID: 9c93017e-b7c17ae000003961-d8-52aa6935f980
Date: Fri, 13 Dec 2013 10:59:09 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: possible regression on 3.13 when calling flush_dcache_page
Message-ID: <20131213015909.GA8845@lge.com>
References: <20131212143149.GI12099@ldesroches-Latitude-E6320>
 <20131212143618.GJ12099@ldesroches-Latitude-E6320>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131212143618.GJ12099@ldesroches-Latitude-E6320>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 03:36:19PM +0100, Ludovic Desroches wrote:
> fix mmc mailing list address error
> 
> On Thu, Dec 12, 2013 at 03:31:50PM +0100, Ludovic Desroches wrote:
> > Hi,
> > 
> > With v3.13-rc3 I have an error when the atmel-mci driver calls
> > flush_dcache_page (log at the end of the message).
> > 
> > Since I didn't have it before, I did a git bisect and the commit introducing
> > the error is the following one:
> > 
> > 106a74e slab: replace free and inuse in struct slab with newly introduced active
> > 
> > I don't know if this commit has introduced a bug or if it has revealed a bug
> > in the atmel-mci driver.

Hello,

I think that this commit may not introduce a bug. This patch remove one
variable on slab management structure and replace variable name. So there
is no functional change.

I doubt that side-effect of this patch reveals a bug in other place.
Side-effect is reduced memory usage for slab management structure. It would
makes some slabs have more objects with more density since slab management
structure is sometimes on the page for objects. So if it diminishes, more
objects can be in the page.

Anyway, I will look at it more. If you have any progress, please let me know.

Thanks.

