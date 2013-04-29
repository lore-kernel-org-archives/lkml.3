Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242Ab3D2O4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 10:56:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49905 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757203Ab3D2O4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 10:56:41 -0400
Message-ID: <517E8A26.7060705@suse.de>
Date: Mon, 29 Apr 2013 16:56:38 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
Cc: scameron@beardog.cce.hp.com, axboe@kernel.dk, neilb@suse.de,
        hch@infradead.org, jmoyer@redhat.com, vgoyal@redhat.com,
        stephenmcameron@gmail.com, linux-kernel@vger.kernel.org,
        lsorense@csclub.uwaterloo.ca
Subject: Re: [RFC PATCH] block: Add new generic block device naming interface
References: <20130425202215.20557.75283.stgit@beardog.cce.hp.com> <20130425204033.GB10990@mtj.dyndns.org> <20130425210726.GL7917@beardog.cce.hp.com> <20130425211459.GC10990@mtj.dyndns.org> <20130425221220.GM7917@beardog.cce.hp.com> <20130426190327.GC1433@mtj.dyndns.org>
In-Reply-To: <20130426190327.GC1433@mtj.dyndns.org>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2013 09:03 PM, Tejun Heo wrote:
> hey,
> 
> On Thu, Apr 25, 2013 at 05:12:20PM -0500, scameron@beardog.cce.hp.com wrote:
>> It looks like these are called from a function called init_device_map() 
>> that is called from grub_stage2() at least in the version of grub I looked
>> at (0.97, from rhel6).
>>
>> So my assumption is that adding a new block driver with yet another name space
>> would require adding another bit of code into grub like those above.  When I
>> asked about "best practices" for new block driver device names on the grub devel
>> mailing list to minimize required changes to grub, nobody argued against that
>> assumption. 
> 
> I think we kinda need to get down to the root cause of the issue.
> Nothing against giving common names to devices in itself but there's a
> non-insigificant chance that we end up with something half-way if the
> original problem isn't properly understodd.
> 
Oh, the problem _is_ well understood.

It's the design of grub :-)

grub requires you to re-implement _every_ device naming scheme which
is present in the kernel.
And no, you cannot use the kernel itself as grub is run _prior_ to
the kernel.

As there is no common naming scheme for block devices each and
every block device driver has implemented it own.
So grub need to re-implement each and every device naming
for these drivers.
The approach from Stephen would solve that.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
