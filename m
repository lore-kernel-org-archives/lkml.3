Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab3EaHiI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 03:38:08 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40434 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751195Ab3EaHiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 03:38:03 -0400
Message-ID: <1369985881.10556.54.camel@joe-AO722>
Subject: Re: [alsa-devel] Improving or replacing snd_printk()
From: Joe Perches <joe@perches.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>, Alan Stern <stern@rowland.harvard.edu>,
        alsa-devel@alsa-project.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Date: Fri, 31 May 2013 00:38:01 -0700
In-Reply-To: <s5hd2s7iouz.wl%tiwai@suse.de>
References: <Pine.LNX.4.44L0.1305301411370.1137-100000@iolanthe.rowland.org>
	 <51A79F25.6040007@perex.cz> <s5hr4gniri4.wl%tiwai@suse.de>
	 <1369983967.10556.48.camel@joe-AO722> <s5hip1zipde.wl%tiwai@suse.de>
	 <1369985409.10556.51.camel@joe-AO722> <s5hd2s7iouz.wl%tiwai@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-31 at 09:35 +0200, Takashi Iwai wrote:
> At Fri, 31 May 2013 00:30:09 -0700, Joe Perches wrote:
> > On Fri, 2013-05-31 at 09:23 +0200, Takashi Iwai wrote:
> > > At Fri, 31 May 2013 00:06:07 -0700, Joe Perches wrote:
> > > > On Fri, 2013-05-31 at 08:37 +0200, Takashi Iwai wrote:
> > > > > I think most of snd_printd() and snd_printdd() can be kept as is.
> > > > > These are just debug messages, after all.
> > > > Some of those are emitted at levels other than KERN_DEBUG.
> > > > I think that odd.
> > > Yeah, they aren't good, but it's a different topic.
> > 
> > Not really, I think it's systemic and fallout from
> > accretive implementation rather than design.
> 
> Maybe.
> 
> But you shouldn't mix up with the fix for the missing verbosity and
> the fix for wrong KERN_ prefix, at least, in the patch level.  They
> need to be fixed individually.

I think that's best too.

I don't see the complexity/hell in adding functions
for specific types of struct * to reduce the complexity
of the code though.  Centralizing those indirections
into functions also generally reduces overall code size.


