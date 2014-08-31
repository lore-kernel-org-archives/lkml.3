Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaHaULp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 16:11:45 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:64733 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbaHaULl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 16:11:41 -0400
Date: Sun, 31 Aug 2014 13:11:37 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Tejun Heo <tj@kernel.org>, "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        gregkh@linuxfoundation.org, falcon@meizu.com, tiwai@suse.de,
        linux-kernel@vger.kernel.org, oleg@redhat.com,
        akpm@linux-foundation.org, penguin-kernel@i-love.sakura.ne.jp,
        joseph.salisbury@canonical.com, bpoirier@suse.de,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [RFC v1 0/3] driver-core: add asynch module loading support
Message-ID: <20140831201137.GA19881@core.coreip.homeip.net>
References: <1409475800-17573-1-git-send-email-mcgrof@do-not-panic.com>
 <20140831101358.GB19853@htj.dyndns.org>
 <20140831110200.GC19853@htj.dyndns.org>
 <20140831110526.GE19853@htj.dyndns.org>
 <20140831175243.GB17827@core.coreip.homeip.net>
 <540376CE.2050007@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540376CE.2050007@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2014 at 12:26:06PM -0700, Arjan van de Ven wrote:
> On 8/31/2014 10:52 AM, Dmitry Torokhov wrote:
> >On Sun, Aug 31, 2014 at 07:05:26AM -0400, Tejun Heo wrote:
> >>On Sun, Aug 31, 2014 at 07:02:00AM -0400, Tejun Heo wrote:
> >>>So, something like the following.  A couple things to note
> >>>
> >>>* driver_attach() can never fail but is marked with __must_check.  We
> >>>   prolly should change it to void.
> >>>
> >>>* Old/weird userspace which depends on insmod to wait for device
> >>>   probing might choke and the new behavior might need to be switched
> >>>   somehow (sysctl, insmod param or whatever).
> >>
> >>One more thing.
> >>
> >>* Use of ordered workqueue probably isn't necessary and using
> >>   system_unbound_wq should be fine.
> >>
> >
> >For my use case (touchpad taking long time to initialize) I explicitly do not
> >want it to keep order of initialization. I want to make sure the rest of the
> >kernel continues initialization while touchpad device resets.
> 
> but we do that right now
> 
> you know its there synchronous
> and do the heavy stuff async

No, in general we do not. I have hacked in serio (i.e. PS/2 support to do
registration/probing in a separate thread - and I'd love to drop that code),
but PS/2 is in its way out and we need the same for devices on I2C. SPI and
other slow buses.

Thanks.

-- 
Dmitry
