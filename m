Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbaHaXDM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 19:03:12 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:35114 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaHaXDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 19:03:10 -0400
Date: Sun, 31 Aug 2014 19:03:06 -0400
From: Tejun Heo <tj@kernel.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, falcon@meizu.com,
        tiwai@suse.de, linux-kernel@vger.kernel.org, oleg@redhat.com,
        akpm@linux-foundation.org, penguin-kernel@i-love.sakura.ne.jp,
        joseph.salisbury@canonical.com, bpoirier@suse.de,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [RFC v1 0/3] driver-core: add asynch module loading support
Message-ID: <20140831230306.GB29948@mtj.dyndns.org>
References: <1409475800-17573-1-git-send-email-mcgrof@do-not-panic.com>
 <540334B2.7000009@linux.intel.com>
 <20140831175040.GA17827@core.coreip.homeip.net>
 <5403767E.1020107@linux.intel.com>
 <20140831193140.GA12678@kroah.com>
 <20140831201407.GB19881@core.coreip.homeip.net>
 <20140831204035.GA4793@kroah.com>
 <20140831215313.GA28690@mtj.dyndns.org>
 <20140831225140.GA20569@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140831225140.GA20569@core.coreip.homeip.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Dmitry.

On Sun, Aug 31, 2014 at 03:51:40PM -0700, Dmitry Torokhov wrote:
> > > Luis, care to redo the patches in this way?  It should be a lot simpler
> > > (no messing around with init levels and linker fun...)
> > 
> > I don't think binding that switch to the driver is gonna work.  This
> > is mainly about the behavior expected by the entity which initiated
> > module loading not about specific drivers.
> 
> Why would you say that? In my particular userspace we do not have modules.

Heh, I think we're just thinking about different problems.  For me,
this is all from the bug report that I was cc'd on where systemd times
out module load after 30s and sends SIG_KILL to the module loading
thread which aborts module loading which in turn leads to nasty
things.  The logical way to address that is separating out module
loading and device probing.  Given the way we associate drivers with
devices these days, it makes a lot of sense to separate them out
anyway.

> >  I'm fairly certain that
> > there are userland scripts which depend on synchronous device probing
> > on module loading, especially for storage devices, so we can't simply
> > mark, say, libata as needing async probing and do it always
> > asynchronously.
> 
> Right. But for many devices (input ones for example, USB as well, etc) that are
> essentially hot-pluggable userspace has been long ready to handle async order.

Sure, all modern userspace should be completely fine without ordering
but there are niche userspaces out in the wild which don't do much of
the dynamic things and just expect devices to be assigned consistent
nodes across multiple boots, so keeping the order is mostly about
backward compatibility.

Thanks.

-- 
tejun
