Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbaHaVxS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 17:53:18 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:57985 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbaHaVxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 17:53:17 -0400
Date: Sun, 31 Aug 2014 17:53:13 -0400
From: Tejun Heo <tj@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, falcon@meizu.com,
        tiwai@suse.de, linux-kernel@vger.kernel.org, oleg@redhat.com,
        akpm@linux-foundation.org, penguin-kernel@i-love.sakura.ne.jp,
        joseph.salisbury@canonical.com, bpoirier@suse.de,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [RFC v1 0/3] driver-core: add asynch module loading support
Message-ID: <20140831215313.GA28690@mtj.dyndns.org>
References: <1409475800-17573-1-git-send-email-mcgrof@do-not-panic.com>
 <540334B2.7000009@linux.intel.com>
 <20140831175040.GA17827@core.coreip.homeip.net>
 <5403767E.1020107@linux.intel.com>
 <20140831193140.GA12678@kroah.com>
 <20140831201407.GB19881@core.coreip.homeip.net>
 <20140831204035.GA4793@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140831204035.GA4793@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Greg.

On Sun, Aug 31, 2014 at 01:40:35PM -0700, Greg KH wrote:
> > Right, all (well almost all) I wanted is for individual drivers to declare
> > their probe() functions asynchronous and driver core scheduling async attach
> > and properly handle failures from it.
> 
> Yes, that's what I want as well.
> 
> Luis, care to redo the patches in this way?  It should be a lot simpler
> (no messing around with init levels and linker fun...)

I don't think binding that switch to the driver is gonna work.  This
is mainly about the behavior expected by the entity which initiated
module loading not about specific drivers.  I'm fairly certain that
there are userland scripts which depend on synchronous device probing
on module loading, especially for storage devices, so we can't simply
mark, say, libata as needing async probing and do it always
asynchronously.

Thanks.

-- 
tejun
