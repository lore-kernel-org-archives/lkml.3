Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757688Ab3D2QGN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:06:13 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:48773 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757620Ab3D2QGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:06:10 -0400
Date: Mon, 29 Apr 2013 09:06:04 -0700
From: Tejun Heo <tj@kernel.org>
To: Hannes Reinecke <hare@suse.de>
Cc: scameron@beardog.cce.hp.com, axboe@kernel.dk, neilb@suse.de,
        hch@infradead.org, jmoyer@redhat.com, vgoyal@redhat.com,
        stephenmcameron@gmail.com, linux-kernel@vger.kernel.org,
        lsorense@csclub.uwaterloo.ca
Subject: Re: [RFC PATCH] block: Add new generic block device naming interface
Message-ID: <20130429160604.GA19814@mtj.dyndns.org>
References: <20130425202215.20557.75283.stgit@beardog.cce.hp.com>
 <20130425204033.GB10990@mtj.dyndns.org>
 <20130425210726.GL7917@beardog.cce.hp.com>
 <20130425211459.GC10990@mtj.dyndns.org>
 <20130425221220.GM7917@beardog.cce.hp.com>
 <20130426190327.GC1433@mtj.dyndns.org>
 <517E8A26.7060705@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <517E8A26.7060705@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Mon, Apr 29, 2013 at 04:56:38PM +0200, Hannes Reinecke wrote:
> grub requires you to re-implement _every_ device naming scheme which
> is present in the kernel.

Are you saying that it's just a limitation in grub?

> And no, you cannot use the kernel itself as grub is run _prior_ to
> the kernel.

I don't get this part.  While booting, it's all about the number BIOS
assigned to disks.  After boot, we might as well just do mknod
/dev/grub-device-N if grub is picky about the names it accept.  What
am I missing here?

> As there is no common naming scheme for block devices each and
> every block device driver has implemented it own.
> So grub need to re-implement each and every device naming
> for these drivers.

Sure, I heard that a couple times but nobody really explained why
that's the case.  Is it something fundamental or is it just an
implementation artifact?  Can't it be fixed from grub side?  If not,
why?

> The approach from Stephen would solve that.

At the cost of losing per-driver semi-stable enumeration.  I don't
think we want to lose that in favor of working around an
implementation detail in grub.

Thanks.

-- 
tejun
