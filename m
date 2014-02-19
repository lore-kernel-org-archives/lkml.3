Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbaBSSvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 13:51:48 -0500
Received: from mailout3.w2.samsung.com ([211.189.100.13]:22397 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653AbaBSSvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 13:51:46 -0500
X-AuditID: cbfec372-b7fa96d000006a7b-23-5304fd411610
Date: Thu, 20 Feb 2014 03:51:28 +0900
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rui Wang <ruiv.wang@gmail.com>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH v6 4/4] i2c, i2c_imc: Add DIMM bus code
Message-id: <20140220035128.14da0f79.m.chehab@samsung.com>
In-reply-to: <CALCETrVBPzGqaXbZVgUZMw7D5U5YnUMJOEsw1r=TceLYjJ39JA@mail.gmail.com>
References: <cover.1387588711.git.luto@amacapital.net>
 <15eccfa508fd0f55230c4274e3e968f91a123b73.1387588711.git.luto@amacapital.net>
 <20140219151626.GA13973@katana>
 <CALCETrVBPzGqaXbZVgUZMw7D5U5YnUMJOEsw1r=TceLYjJ39JA@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t/hEF3HvyzBBn9WMFk0/o206Pj7hdHi
	8q45bBZPFp5hsli9toHVYuKhJ2wWby7cY7FYeWIWswOHx/03f1k8ds66y+6xeM9LJo8rDSfZ
	PHZ+b2D3OHnqCYvH501yAexRXDYpqTmZZalF+nYJXBkHtn5kLdhvWDHp0yLGBsZJ6l2MnBwS
	AiYSE/9MY4OwxSQu3FsPZHNxCAksYZRoPLCUEcJpYJLo7DvDAlLFIqAqsXfLc2YQm03ASOJV
	YwsriC0ioCnxcsp8FpAGZoEeJonbW9+BNQgLWEvs6D0IZvMKWElMvXAczOYUCJa4tO8HC8SG
	94wS3Sd2MUHc4STx6vVkJogGQYkfk++BNTALaEls3tbECmHLS2xe85Z5AqPALCRls5CUzUJS
	toCReRWjaGlxckFxUnquoV5xYm5xaV66XnJ+7iZGSBwU7WB8tsHqEKMAB6MSD2/EdZZgIdbE
	suLK3EOMEhzMSiK8t98BhXhTEiurUovy44tKc1KLDzEycXBKNTDmps9j22nL9vDT2gVLK0Mm
	9s1a/tJQ8b1xbavlnilT2o+4fJydfjIi44Wnn3U065qo3tIYAdW732vLl03/xlvr/TfbzDly
	l07yvEdeEy+6budY9fVlTVzpJ96iAr1304Idr03qnHTy3JYie6m5anLyK3/KZQqvSZGTWHV3
	W8UludlLom/UXGJQYinOSDTUYi4qTgQAbEq9U2ECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I'm c/c Tony here, as he also shared the same concern that I had on a 
previous feedback about using I2C to talk with the DIMM).

Em Wed, 19 Feb 2014 09:30:46 -0800
Andy Lutomirski <luto@amacapital.net> escreveu:

> On Wed, Feb 19, 2014 at 7:16 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
> > On Fri, Dec 20, 2013 at 05:45:13PM -0800, Andy Lutomirski wrote:
> >> Add i2c_scan_dimm_bus to declare that a particular i2c_adapter
> >> contains DIMMs.  This will probe (and autoload modules!) for useful
> >> SMBUS devices that live on DIMMs.  i2c_imc calls it.
> >
> > Hmm, after thinking about it for a while and a couple of times, I get
> > the impression that the functionality of i2c_scan_dimm_bus() should
> > better be in userspace, i.e. a udev helper. I could imagine introducing
> > a new functionality macro I2C_FUNC_DIMM_BUS which can be detected in
> > userspace via i2c-dev. Based on that, the helper can do whatever
> > necessary. What do you think?
> >
> 
> Hmm.  So there would be udev rules that detect an I2C_FUNC_DIMM_BUS
> driver and probe it appropriately.
> 
> I'm not sure I like it.  It would mean that any future kernel code
> that wants to use things hanging off the dimm bus would need to stay
> in sync with the udev rules, and it would make things like sticking
> platform_data into the probed devices complicated or impossible.

As I said already a few times, my main concern with such patches is that it
could eventually cause really bad things, especially since we're using
experimental data collected on a system (or maybe on more than one, but
still a limited set of systems), to infere that the same behavior will
be valid for all.

Even assuming that you covered all existing systems, couldn't a BIOS 
or microcode upgrade do some changes that could increase the chances 
that the above-described problems to happen more likely? I'm afraid so.

Let me also cut-and-paste a few relevant parts taken from patch 4/4:

> >> +       It is possibly, although unlikely, that the use of this driver will
> >> +       interfere with your platform's RAM thermal management.
> >
> > This sounds scary and thus needs some more detail :) How does that show?
> > What can happen? Anything to take care of?
> >
> 
> Here's how this works, as far as I can figure it out:
> 
> The Sandy Bridge (and presumably Ivy Bridge) platforms make some
> effort to avoid overheating system DRAM, and they can dynamically
> adjust the refresh interval depending on DIMM temperature.  This
> happens in one of a few modes:

...

> OLTT (open loop thermal throttling):  the memory controller will
> estimate recent heat output based on access patterns and will adjust
> accordingly.  There are lots of registers related to this in the
> public docs, but the overall algorithm and purpose is not described
> anywhere that I've looked.  In this mode, something (SMI? P-code?) can
> still poll the TSOD, but it respects the POLL_EN bit.

...

> The interesting case is OLTT.  If we fail to twiddle the POLL_EN bit
> correctly, then, in principle, we could cause a problem.  I don't know
> what that problem would be -- the memory controller's P-code could
> malfunction with unknown results.  I've abused a test system quite a
> bit, and I've been completely unable to cause a problem, though.
>
> There may be other modes, too, but, if so, I can't find them.  Maybe
> some day there will be CLTT with i2c access.  If so, presumably the
> driver will need updating.

...

> * This is not documented at all AFAIK.  I figured it out by trial and error.

...

> >> +             udelay(70);
> >
> > usleep_range?
> 
> No -- see the comment just above this excerpt.  There's an erratum
> (which I can trigger on occasion but not reliably) that causes the i2c
> hardware to return bogus results if the system enters a sufficiently
> deep sleep while a transaction is running.  udelay prevents that.

Well, I've seen already very bad things happening on I2C.

For example, some I2C eeproms miss-understands 0-sized I2C bus read 
messages, even sent to other I2C chips. On such eeproms, sometimes,
instead of doing an eeprom read, they actually do an I2C write.

There are enough known reported cases of such troubles with TV boards
that we even added a contrib perl code at v4l2-utils to allow one to
try to restore the board's EEPROM content, in order to allow fixing an 
accidental card brick, due to an EEPROM content loss caused by this bug.

Of course, the user should have made a copy first of the content of the
eeprom, or to find, at the net, a valid content for his board. This is
easier said than done.

Knowing nothing about how the DIMMs are manufactured, I can think on an
hypothetical scenario where a manufacturer would test the DIMM timings
and other DIMM quality parameters on their production line, and fill an
I2C EEPROM at the DIMMS after those tests, in order to determine the safe
zone for a DIMM.

So, if such scenario is possible (someone with more experience with
DIMM production could help here?), then, in thesis, a badly timed read
(or an I2C read that would be interrupted by a SMI call that would also
touch at the same I2C bus) could damage the EEPROM content, bricking
the DIMM.

Well, what I'm trying to say is that, before implementing any solution
that reads data directly from the DIMM I2C bus (doesn't matter if in
userspace or Kernelspace), we should know for sure that this won't cause 
DIMM loses, either by overheating them or by causing a corruption on the
information that stores the DIMM size and timings on each DIMM slot.

So, I suggest to not commit any patches here, without a careful
review from an Intel engineer that would then be sure that:
- the BIOS will respect POLL_EN;
- there will be no way to accidentally write data at DIMM control eeproms;
- that current and newer microcode/firmware updates will keep such driver
  reliable in the long term.

That's said, as there are critical timings at the driver (so udelay is
needed), and a precise time can't be warranted in userspace - as the
userspace process may be interrupted during an userspace usleep() call - I
would very much prefer to have this implemented at Kernelspace level.

Regards,
Mauro
