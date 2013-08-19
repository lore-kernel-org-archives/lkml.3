Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750864Ab3HSPEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 11:04:16 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:35986 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab3HSPEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 11:04:15 -0400
Message-ID: <1376924652.24869.39.camel@bobble.lax.corp.google.com>
Subject: Re: dm: Make MIN_IOS, et al, tunable via sysctl.
From: Frank Mayhar <fmayhar@google.com>
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
Date: Mon, 19 Aug 2013 08:04:12 -0700
In-Reply-To: <20130819134038.GA27167@redhat.com>
References: <1376070533.26057.244.camel@bobble.lax.corp.google.com>
	 <20130817123039.GR1762@agk-dp.fab.redhat.com>
	 <20130819134038.GA27167@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-19 at 09:40 -0400, Mike Snitzer wrote:
> On Sat, Aug 17 2013 at  8:30am -0400,
> Alasdair G Kergon <agk@redhat.com> wrote:
> 
> > On Fri, Aug 16, 2013 at 03:55:21PM -0700, Frank Mayhar wrote:
> > > This patch fixes that by changing the hardcoded MIN_IOS (and certain
> > > other) #defines in dm-crypt, dm-io, dm-mpath, dm-snap and dm itself to
> > > sysctl-modifiable values.  This lets us change the size of these pools
> > > on the fly, we can reduce the size of the pools and reduce memory
> > > pressure.
> >  
> > Did you consider using module_param_named()?
> > (E.g. dm_verity_prefetch_cluster in dm-verity.)
> 
> Right, I'd prefer to see this be implemented in terms of
> module_param_named().  Aside from dm-verity, dm-bufio.c makes the most
> use of it.

Yeah, I can do that.
-- 
Frank Mayhar
310-460-4042

