Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591AbaC1XvG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 19:51:06 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:53391 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbaC1XvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 19:51:03 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC 0/5] of: Automatic console registration cleanups
To: Christoffer Dall <christoffer.dall@linaro.org>,
        Rob Herring <robherring2@gmail.com>
Cc: Olof Johansson <olof@lixom.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rob Herring <rob.herring@linaro.org>
In-Reply-To: <20140328205836.GN25519@cbox>
References: <1396022885-6102-1-git-send-email-grant.likely@linaro.org> < 20140328185653.GB26433@quad.lixom.net> < CAL_JsqKFO+OSz83f=XdyKgCqByUvHe7qLzgn5QLU1x1V1A5Fng@mail.gmail.com> < 20140328205836.GN25519@cbox>
Date: Fri, 28 Mar 2014 16:50:58 -0700
Message-Id: <20140328235058.BEAD3C41FF4@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Mar 2014 13:58:36 -0700, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> On Fri, Mar 28, 2014 at 02:19:23PM -0500, Rob Herring wrote:
> > On Fri, Mar 28, 2014 at 1:56 PM, Olof Johansson <olof@lixom.net> wrote:
> > > On Fri, Mar 28, 2014 at 09:08:00AM -0700, Grant Likely wrote:
> > >> Hi all,
> > >>
> > >> This is a series that I've been playing with over the last few days to
> > >> clean up the selection of default console devices when using the device
> > >> tree. The device tree defines a way of specifying the console by using a
> > >> "stdout-path" property in the /chosen node, but very few drivers
> > >> actually attempt to use that data, and so for most platforms there needs
> > >> to be a "console=" line in the command line if a serial port is intended
> > >> to be used as the console.
> > >>
> > >> With this series, if there is a /chosen/stdout-path property, and if
> > >> that property points to a serial port node, then when the serial driver
> > >> registers the port, the core uart_add_one_port() function will notice
> > >> and if no console= argument was provided then add it as a preferred
> > >> console.
> > >>
> > >> I've not tested this very extensively yet, but I want to get some
> > >> feedback before I go further.
> > >>
> > >> The one downside with this approach is that it doesn't do anything for
> > >> early console setup. That still needs to be added on a per-driver basis,
> > >> but at least it shouldn't conflict with this approach.
> > 
> > I'm working on the early aspect. I've got things working with either
> > command line (which I sent out recently) and with parsing the FDT
> > (which I haven't sent out yet).
> > 
> > > Looks sane to me (as discussed in person). I gave it a run on PWRficient with
> > > and without console= line (8250-based uart), and it behaved as expected.
> > >
> > > A couple of nits on the series, replied to two of the patches.
> > >
> > > I'll give it a run through the board farm here too, but I'll keep console=
> > > bootargs there for those boots at this time, too much to change to take it out
> > > everywhere. :-)
> > 
> > It would be good to know if removing console= causes userspace any
> > issues. For example, if getty's were setup based on console params. I
> > know ubuntu does some detection of serial ports, but I don't recall
> > what it looks at. Hopefully it's just checking /dev nodes.
> > 
> In Ubuntu, recent versions at least, it's all just hardcoded in
> /etc/init/*.conf files.  The Linaro OE FS does check /proc/cmdline for
> console= in there - not sure if we care, or at least we can have it
> fixed quickly.

For real hardware using a serial console, I think we want to fix this.
Right my embedded rootfs (buildroot) isn't portable between machines
only because the getty device gets hard coded. /proc/cmdline doesn't
really solve the problem since it doesn't handle non-cmdline selected
consoles. However, /proc/consoles should do the job.

g.

