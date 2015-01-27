Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759514AbbA0TeH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 14:34:07 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:59052 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbbA0TeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 14:34:06 -0500
Date: Tue, 27 Jan 2015 11:34:01 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Priit Laes <plaes@plaes.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-sunxi@googlegroups.com, Hans de Goede <hdegoede@redhat.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [linux-sunxi] Re: [PATCH] arm: sunxi: input: RFC: Add sysfs
 voltage for sun4i-lradc driver
Message-ID: <20150127193401.GB29637@dtor-glaptop>
References: <1422291516-24895-1-git-send-email-plaes@plaes.org>
 <20150127091829.GD7200@lukather>
 <1422352189.23189.12.camel@plaes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422352189.23189.12.camel@plaes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 11:49:49AM +0200, Priit Laes wrote:
> 
> On Tue, 2015-01-27 at 10:18 +0100, Maxime Ripard wrote:
> > Hi,
> > 
> > On Mon, Jan 26, 2015 at 06:58:32PM +0200, Priit Laes wrote:
> > > ---
> > 
> > Like Hans was pointing out, commit log and signed-off-by please
> > 
> > >  .../ABI/testing/sysfs-driver-input-sun4i-lradc     |  4 ++
> > >  drivers/input/keyboard/sun4i-lradc-keys.c          | 49 
> > > +++++++++++++++++-----
> > >  2 files changed, 43 insertions(+), 10 deletions(-)
> > >  create mode 100644 Documentation/ABI/testing/sysfs-driver-input-
> > > sun4i-lradc
> > > 
> > > diff --git a/Documentation/ABI/testing/sysfs-driver-input-sun4i-
> > > lradc b/Documentation/ABI/testing/sysfs-driver-input-sun4i-lradc
> > > new file mode 100644
> > > index 0000000..e4e6448
> > > --- /dev/null
> > > +++ b/Documentation/ABI/testing/sysfs-driver-input-sun4i-lradc
> > > @@ -0,0 +1,4 @@
> > > +What:          /sys/class/input/input(x)/device/voltage
> > > +Date:          February 2015
> > > +Contact:       Priit Laes <plaes@plaes.org>
> > > +Description:   ADC output voltage in microvolts or 0 if device is 
> > > not opened.
> > 
> > Why is it returning 0 when "device is not opened" ? What does that 
> > even mean? You can't read that file without opening it.
> 
> It means that something has to open the /dev/input/inputX device which 
> sets up the ADC before the voltage can be read from the sysfs file.

I'd consider this a bug. Why someone has to use an unrelated interface for
another interface to work correctly?

> 
> [...]
> 
> 
> > 
> > As I told you already, if you're going to expose this an ADC in the 
> > end, the proper solution is to use the IIO framework, not adding a 
> > custom sysfs file.
> 
> My intention was to expose just a simple debug output, so one can 
> press the buttons and read the voltages for devicetree keymap.
> 
> If anyone can suggest a simpler approach than current sysfs based one, 
> I would do it. But full blown iio driver is currently out of scope. 
> Also, Carlo's (ccaione) initially submitted (?) driver for lradc 
> utilized iio subsystem.

For stuff like this debugfs (AKA dumping ground) is better suited as it does
not establish ABI.  i

Thanks.

-- 
Dmitry
