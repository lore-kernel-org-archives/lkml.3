Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbaHaWxS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 18:53:18 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:36283 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbaHaWxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 18:53:16 -0400
Date: Sun, 31 Aug 2014 18:53:12 -0400
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
Message-ID: <20140831225312.GA29948@mtj.dyndns.org>
References: <1409475800-17573-1-git-send-email-mcgrof@do-not-panic.com>
 <540334B2.7000009@linux.intel.com>
 <20140831175040.GA17827@core.coreip.homeip.net>
 <5403767E.1020107@linux.intel.com>
 <20140831193140.GA12678@kroah.com>
 <20140831201407.GB19881@core.coreip.homeip.net>
 <20140831204035.GA4793@kroah.com>
 <20140831215313.GA28690@mtj.dyndns.org>
 <20140831221534.GA18064@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140831221534.GA18064@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Aug 31, 2014 at 03:15:34PM -0700, Greg KH wrote:
> For the use cases we have today, it would work.  We have a few drivers
> that take a _long_ time in their probe callback, and they need to be
> made async for various reasons (modprobe timeout killer, touchscreen
> init sequence stalling boot, etc.)

Oh, but there already is a reported case which fails.  Hard drives
with a lot of platters take > 10secs to spin up and there are
configurations which regularly fail the initial reset and it's quite
rare but probing time taking over 30s does happen in the wild.  We
can't mark libata as requiring async probing on module load
unconditionally but at the same time we need them to be asynchronous
for use cases which don't depend on synchronous behavior has has
timeout.

> I'm not saying to mark drivers that require synchronous probing with
> this flag, that would be broken and wrong.

I don't think we can distinguish the two sets by drivers.

Thanks.

-- 
tejun
