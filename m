Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab3FZQYP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 12:24:15 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:49168 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751466Ab3FZQYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 12:24:14 -0400
Date: Wed, 26 Jun 2013 09:24:07 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>
Subject: Re: 'Timed out waiting for forcewake old ack to clear' and hangup
 on IvyBridge system
Message-ID: <20130626092407.270ea60b@jbarnes-desktop>
In-Reply-To: <20130622200409.GA24545@roeck-us.net>
References: <20130622065808.GA20980@roeck-us.net>
	<20130622121646.0afcc207@jbarnes-desktop>
	<20130622200409.GA24545@roeck-us.net>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Jun 2013 13:04:09 -0700
Guenter Roeck <linux@roeck-us.net> wrote:

> On Sat, Jun 22, 2013 at 12:16:46PM -0700, Jesse Barnes wrote:
> > On Fri, 21 Jun 2013 23:58:08 -0700
> > Guenter Roeck <linux@roeck-us.net> wrote:
> > 
> > > Hi all,
> > > 
> > > after upgrading one of my servers to 3.8, then 3.9.7 and 3.10-rc6, I started to
> > > see lots of "Timed out waiting for forcewake old ack to clear" error messages,
> > > including hang-ups especially if the system was highly loaded. With 3.5.24
> > > everything was fine.
> > > 
> > > After backing out commit 36ec8f877 (drm/i915: unconditionally use mt forcewake
> > > on hsw/ivb), everything is back to normal. The log message is still there, but
> > > only once during boot, and the system runs stable.
> > > 
> > > CPU is "Intel(R) Core(TM) i7-3770K CPU @ 3.50GHz", mainboard is Supermicro
> > > C7H61, BIOS version 2.00 dated 11/02/2012. Configuration file is whatever
> > > comes with Ubuntu; I'll be happy to provide a copy if anyone thinks it might
> > > help.
> > > 
> > > Any idea what else I can do besides using a special kernel with the backed out
> > > commit ? Is it possible that others have the same problem ?
> > 
> > Ouch, so a BIOS that uses the other forcewake mechanism seems to have
> > escaped.  Is there a newer one available for your system?  I'm hoping
> > it'll fix the issue, otherwise we may have to introduce both methods
> > for IVB again...
> > 
> I installed the latest BIOS version (2.00b), but it did not fix the problem.
> 
> Is there some info (such as an Intel document describing what needs to be done)
> which I could pass on to Supermicro ?
> 
> I think it would be helpful if the condition was detected and reported, if that
> is possible. I spent two days so far tracking this down. It would be nice
> if others would not have to go through the same experience.

I don't think there's anything public to share, but it's not a big deal
to simply revert the patch in question.  That seems like the right
thing to do anyway since we'd like stuff to work "out of the box" as
much as possible.

Daniel?

-- 
Jesse Barnes, Intel Open Source Technology Center
