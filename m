Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830Ab3HTVon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:44:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718Ab3HTVol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:44:41 -0400
Date: Tue, 20 Aug 2013 17:44:39 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: device-mapper development <dm-devel@redhat.com>
cc: linux-kernel@vger.kernel.org, Frank Mayhar <fmayhar@google.com>
Subject: Re: [dm-devel] dm: Make MIN_IOS, et al, tunable via sysctl.
In-Reply-To: <1376934845.24869.43.camel@bobble.lax.corp.google.com>
Message-ID: <alpine.LRH.2.02.1308201742350.8826@file01.intranet.prod.int.rdu2.redhat.com>
References: <1376070533.26057.244.camel@bobble.lax.corp.google.com> <20130819140016.GB27167@redhat.com> <1376934845.24869.43.camel@bobble.lax.corp.google.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 19 Aug 2013, Frank Mayhar wrote:

> On Mon, 2013-08-19 at 10:00 -0400, Mike Snitzer wrote:
> > Performance isn't the concern.  The concern is: does DM allow for
> > forward progress if the system's memory is completely exhausted?
> > 
> > This is why request-based has such an extensive reserve, because it
> > needs to account for cloning the largest possible request that comes in
> > (with multiple bios).
> 
> Thanks for the response.  In our particular case, I/O will be file
> system based and over a network, which makes it pretty easy for us to be
> sure that large I/Os never happen.  That notwithstanding, however, as
> you said it just seems reasonable to make these values configurable.
> 
> I'm also looking at making some similar constants in dm-verity and
> dm-bufio configurable in the same way and for similar reasons.

Regarding dm-bufio: the user of dm-bufio sets the pool size as an argument 
in dm_bufio_client_create. There is no need to make it configurable - if 
the user selects too low value, deadlock is possible, if the user selects 
too high value, there is no additional advantage.

Regarding dm-verity: the mempool size is 4, there is no need to make it 
bigger, there is no advantage from that.

Mikulas
