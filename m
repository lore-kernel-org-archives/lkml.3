Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444Ab3HTVwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:52:49 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:43603 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab3HTVws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:52:48 -0400
Message-ID: <1377035565.24869.53.camel@bobble.lax.corp.google.com>
Subject: Re: [dm-devel] dm: Make MIN_IOS, et al, tunable via sysctl.
From: Frank Mayhar <fmayhar@google.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 20 Aug 2013 14:52:45 -0700
In-Reply-To: <alpine.LRH.2.02.1308201742350.8826@file01.intranet.prod.int.rdu2.redhat.com>
References: <1376070533.26057.244.camel@bobble.lax.corp.google.com>
	 <20130819140016.GB27167@redhat.com>
	 <1376934845.24869.43.camel@bobble.lax.corp.google.com>
	 <alpine.LRH.2.02.1308201742350.8826@file01.intranet.prod.int.rdu2.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-20 at 17:44 -0400, Mikulas Patocka wrote:
> On Mon, 19 Aug 2013, Frank Mayhar wrote:
> > On Mon, 2013-08-19 at 10:00 -0400, Mike Snitzer wrote:
> > > Performance isn't the concern.  The concern is: does DM allow for
> > > forward progress if the system's memory is completely exhausted?
> > > 
> > > This is why request-based has such an extensive reserve, because it
> > > needs to account for cloning the largest possible request that comes in
> > > (with multiple bios).
> > 
> > Thanks for the response.  In our particular case, I/O will be file
> > system based and over a network, which makes it pretty easy for us to be
> > sure that large I/Os never happen.  That notwithstanding, however, as
> > you said it just seems reasonable to make these values configurable.
> > 
> > I'm also looking at making some similar constants in dm-verity and
> > dm-bufio configurable in the same way and for similar reasons.
> 
> Regarding dm-bufio: the user of dm-bufio sets the pool size as an argument 
> in dm_bufio_client_create. There is no need to make it configurable - if 
> the user selects too low value, deadlock is possible, if the user selects 
> too high value, there is no additional advantage.

True, but dm-bufio also allocates a a fixed-size 8MB (on a 64-bit
machine) hash table.  I'm still getting performance data but it appears
that reducing this, even by a lot, doesn't impact performance
significantly, at least not with the workload I'm running.  (Which is
using fio, random and sequential reads of varying buffer sizes.)

> Regarding dm-verity: the mempool size is 4, there is no need to make it 
> bigger, there is no advantage from that.

Also true, but there may be an advantage in making it smaller.
-- 
Frank Mayhar
310-460-4042

