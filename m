Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965Ab3HUOiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:38:13 -0400
Received: from a9-58.smtp-out.amazonses.com ([54.240.9.58]:44531 "EHLO
	a9-58.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751816Ab3HUOiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:38:12 -0400
X-Greylist: delayed 316 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Aug 2013 10:38:12 EDT
Date: Wed, 21 Aug 2013 14:32:55 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
cc: Kent Overstreet <kmo@daterainc.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] idr: Use this_cpu_ptr() for percpu_ida
In-Reply-To: <1377033546.32763.4.camel@haakon3.risingtidesystems.com>
Message-ID: <00000140a14ae6bb-f0fca267-cdd6-4039-8c6b-f715999a83c5-000000@email.amazonses.com>
References: <1375896905-6074-1-git-send-email-kmo@daterainc.com>  <1375896905-6074-5-git-send-email-kmo@daterainc.com>  <0000014059ec4c34-1bb53d48-c9ee-4e71-81b8-253026431c5c-000000@email.amazonses.com>  <20130807183345.GA11612@kmo-pixel> 
 <000001405a4b39ef-0715410a-5061-41e9-9414-86559f16570d-000000@email.amazonses.com>  <20130807195733.GB11612@kmo-pixel>  <000001405e5776ba-bcc96088-b5e8-4abe-b98e-2e9d7d9b112b-000000@email.amazonses.com>
 <1377033546.32763.4.camel@haakon3.risingtidesystems.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.08.21-54.240.9.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Aug 2013, Nicholas A. Bellinger wrote:

> On Thu, 2013-08-08 at 14:32 +0000, Christoph Lameter wrote:
> > On Wed, 7 Aug 2013, Kent Overstreet wrote:
> >
> > > One thing that was bugging me - I was never able to figure out for sure
> > > if smp_processor_id() returns a number in the range [0, nr_cpu_ids), at
> > > least I couldn't find where it was documented - could you tell me if
> > > that's true?
> >
> > I always assumed that it was in the range 0 ... nr_cpu_ids - 1 and that is
> > the assumption under which the kernel code was written. Things would break
> > horribly if smp_process_id would return nr_cpu_ids or higher.
> >
>
> Hi guys,
>
> Just a heads up that I've put Kent's standalone percpu-ida patch (with
> Christoph's recommend changes) into target-pending/for-next here:
>
> https://git.kernel.org/cgit/linux/kernel/git/nab/target-pending.git/commit/?h=for-next&id=47bd524a5b3eb6429b058b8b562b45329ab2c9e7
>
> I've got a number of target patches that depend on this code for v3.12,
> and a delay on this particular piece would be painful to endure..
>
> Sooo, please yell loudly if there is an objection to percpu-ida merge as
> a completely standalone item, that does not effect any existing ida
> code.

Well the performance is still going to be limited due to the spinlock in
the percpu handling. You do not need the spinlock. Once preempt is off you
should have exclusive access to the per cpu data. This is already
exploited by idr_layer_alloc before the patch. Doing so is going to
reduce the code size of the patch significantly.

Please post the patch inline so that its easy to comment on it.

