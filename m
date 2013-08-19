Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750816Ab3HSNkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 09:40:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707Ab3HSNkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 09:40:42 -0400
Date: Mon, 19 Aug 2013 09:40:39 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Frank Mayhar <fmayhar@google.com>, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Subject: Re: dm: Make MIN_IOS, et al, tunable via sysctl.
Message-ID: <20130819134038.GA27167@redhat.com>
References: <1376070533.26057.244.camel@bobble.lax.corp.google.com>
 <20130817123039.GR1762@agk-dp.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130817123039.GR1762@agk-dp.fab.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 17 2013 at  8:30am -0400,
Alasdair G Kergon <agk@redhat.com> wrote:

> On Fri, Aug 16, 2013 at 03:55:21PM -0700, Frank Mayhar wrote:
> > This patch fixes that by changing the hardcoded MIN_IOS (and certain
> > other) #defines in dm-crypt, dm-io, dm-mpath, dm-snap and dm itself to
> > sysctl-modifiable values.  This lets us change the size of these pools
> > on the fly, we can reduce the size of the pools and reduce memory
> > pressure.
>  
> Did you consider using module_param_named()?
> (E.g. dm_verity_prefetch_cluster in dm-verity.)

Right, I'd prefer to see this be implemented in terms of
module_param_named().  Aside from dm-verity, dm-bufio.c makes the most
use of it.

Mike
