Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbaI3HXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 03:23:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51609 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbaI3HXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 03:23:30 -0400
Date: Tue, 30 Sep 2014 09:23:28 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, gregkh@linuxfoundation.org,
        dmitry.torokhov@gmail.com, tiwai@suse.de, arjan@linux.intel.com,
        teg@jklm.no, rmilasan@suse.com, werner@suse.com, oleg@redhat.com,
        hare@suse.com, bpoirier@suse.de, santosh@chelsio.com, pmladek@suse.cz,
        dbueso@suse.com, linux-kernel@vger.kernel.org,
        Doug Thompson <dougthompson@xmission.com>,
        Borislav Petkov <bp@alien8.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-edac@vger.kernel.org
Subject: Re: [PATCH v1 3/5] amd64_edac: enforce synchronous probe
Message-ID: <20140930072328.GD14081@wotan.suse.de>
References: <1411768637-6809-1-git-send-email-mcgrof@do-not-panic.com> <1411768637-6809-4-git-send-email-mcgrof@do-not-panic.com> <20140928144123.GB5023@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140928144123.GB5023@mtj.dyndns.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2014 at 10:41:23AM -0400, Tejun Heo wrote:
> On Fri, Sep 26, 2014 at 02:57:15PM -0700, Luis R. Rodriguez wrote:
> ...
> > [   14.414746]  [<ffffffff814d2cf9>] ? dump_stack+0x41/0x51
> > [   14.414790]  [<ffffffff81061972>] ? warn_slowpath_common+0x72/0x90
> > [   14.414834]  [<ffffffff810619d7>] ? warn_slowpath_fmt+0x47/0x50
> > [   14.414880]  [<ffffffff814d0ac3>] ? printk+0x4f/0x51
> > [   14.414921]  [<ffffffff811f8593>] ? kernfs_remove_by_name_ns+0x83/0x90
> > [   14.415000]  [<ffffffff8137433d>] ? driver_sysfs_remove+0x1d/0x40
> > [   14.415046]  [<ffffffff81374a15>] ? driver_probe_device+0x1d5/0x250
> > [   14.415099]  [<ffffffff81374b4b>] ? __driver_attach+0x7b/0x80
> > [   14.415149]  [<ffffffff81374ad0>] ? __device_attach+0x40/0x40
> > [   14.415204]  [<ffffffff81372a13>] ? bus_for_each_dev+0x53/0x90
> > [   14.415254]  [<ffffffff81373913>] ? driver_attach_workfn+0x13/0x80
> > [   14.415298]  [<ffffffff81077403>] ? process_one_work+0x143/0x3c0
> > [   14.415342]  [<ffffffff81077a44>] ? worker_thread+0x114/0x480
> > [   14.415384]  [<ffffffff81077930>] ? rescuer_thread+0x2b0/0x2b0
> > [   14.415427]  [<ffffffff8107c261>] ? kthread+0xc1/0xe0
> > [   14.415468]  [<ffffffff8107c1a0>] ? kthread_create_on_node+0x170/0x170
> > [   14.415511]  [<ffffffff814d883c>] ? ret_from_fork+0x7c/0xb0
> > [   14.415554]  [<ffffffff8107c1a0>] ? kthread_create_on_node+0x170/0x170
> 
> Do you have CONFIG_FRAME_POINTER turned off?

Yeah..

> Probe failure itself
> aside, the above looks like a bug in really_probe()'s error path.  It
> looks like it can try to remove sysfs directory that it hasn't added
> yet.

I see one area where that can happen, will debug a bit more to see if we
are running into that here with async probe.

  Luis
