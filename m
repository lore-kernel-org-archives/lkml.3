Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab3HUCB1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 22:01:27 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:36133 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab3HUCB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 22:01:26 -0400
Date: Tue, 20 Aug 2013 19:01:32 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Christoph Lameter <cl@gentwo.org>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] idr: Use this_cpu_ptr() for percpu_ida
Message-ID: <20130821020132.GA4051@kmo-pixel>
References: <1375896905-6074-1-git-send-email-kmo@daterainc.com>
 <1375896905-6074-5-git-send-email-kmo@daterainc.com>
 <0000014059ec4c34-1bb53d48-c9ee-4e71-81b8-253026431c5c-000000@email.amazonses.com>
 <20130807183345.GA11612@kmo-pixel>
 <000001405a4b39ef-0715410a-5061-41e9-9414-86559f16570d-000000@email.amazonses.com>
 <20130807195733.GB11612@kmo-pixel>
 <000001405e5776ba-bcc96088-b5e8-4abe-b98e-2e9d7d9b112b-000000@email.amazonses.com>
 <1377033546.32763.4.camel@haakon3.risingtidesystems.com>
 <20130820142956.1194d8c798abf53f884a1fb6@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130820142956.1194d8c798abf53f884a1fb6@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 02:29:56PM -0700, Andrew Morton wrote:
> On Tue, 20 Aug 2013 14:19:06 -0700 "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > On Thu, 2013-08-08 at 14:32 +0000, Christoph Lameter wrote:
> > > On Wed, 7 Aug 2013, Kent Overstreet wrote:
> > > 
> > > > One thing that was bugging me - I was never able to figure out for sure
> > > > if smp_processor_id() returns a number in the range [0, nr_cpu_ids), at
> > > > least I couldn't find where it was documented - could you tell me if
> > > > that's true?
> > > 
> > > I always assumed that it was in the range 0 ... nr_cpu_ids - 1 and that is
> > > the assumption under which the kernel code was written. Things would break
> > > horribly if smp_process_id would return nr_cpu_ids or higher.
> > > 
> > 
> > Hi guys,
> > 
> > Just a heads up that I've put Kent's standalone percpu-ida patch (with
> > Christoph's recommend changes) into target-pending/for-next here:
> > 
> > https://git.kernel.org/cgit/linux/kernel/git/nab/target-pending.git/commit/?h=for-next&id=47bd524a5b3eb6429b058b8b562b45329ab2c9e7
> > 
> > I've got a number of target patches that depend on this code for v3.12,
> > and a delay on this particular piece would be painful to endure..
> > 
> > Sooo, please yell loudly if there is an objection to percpu-ida merge as
> > a completely standalone item, that does not effect any existing ida
> > code.
> 
> Was hoping that Tejun had time.  I'll take a look...

I think Tejun and I might be at a bit of an impasse with the ida rewrite
itself, but I don't think there were any outstanding objections to the
percpu ida code itself - and this is a standalone version.

I was meaning to ask you Andrew, if you could take a look at the ida
discussion and lend your opinion - I don't think there's any _specific_
technical objections left to my ida code, and it's now on a more
philisophical "complexity vs. ..." level.
