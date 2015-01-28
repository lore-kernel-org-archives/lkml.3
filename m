Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247AbbA1BPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:15:21 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:37936 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbbA1BPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:15:19 -0500
Date: Tue, 27 Jan 2015 17:15:13 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Hans de Goede <hdegoede@redhat.com>, Priit Laes <plaes@plaes.org>,
        linux-sunxi@googlegroups.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [linux-sunxi] Re: [PATCH] arm: sunxi: input: RFC: Add sysfs
 voltage for sun4i-lradc driver
Message-ID: <20150128011513.GA30169@dtor-ws>
References: <1422291516-24895-1-git-send-email-plaes@plaes.org>
 <20150127091829.GD7200@lukather>
 <1422352189.23189.12.camel@plaes.org>
 <54C76DF2.50707@redhat.com>
 <20150127194447.GO7200@lukather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150127194447.GO7200@lukather>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 08:44:47PM +0100, Maxime Ripard wrote:
> On Tue, Jan 27, 2015 at 11:52:34AM +0100, Hans de Goede wrote:
> > Hi,
> > 
> > On 27-01-15 10:49, Priit Laes wrote:
> > >
> > >On Tue, 2015-01-27 at 10:18 +0100, Maxime Ripard wrote:
> > >>Hi,
> > >>
> > >>On Mon, Jan 26, 2015 at 06:58:32PM +0200, Priit Laes wrote:
> > >>>---
> > >>
> > >>Like Hans was pointing out, commit log and signed-off-by please
> > >>
> > >>>  .../ABI/testing/sysfs-driver-input-sun4i-lradc     |  4 ++
> > >>>  drivers/input/keyboard/sun4i-lradc-keys.c          | 49
> > >>>+++++++++++++++++-----
> > >>>  2 files changed, 43 insertions(+), 10 deletions(-)
> > >>>  create mode 100644 Documentation/ABI/testing/sysfs-driver-input-
> > >>>sun4i-lradc
> > >>>
> > >>>diff --git a/Documentation/ABI/testing/sysfs-driver-input-sun4i-
> > >>>lradc b/Documentation/ABI/testing/sysfs-driver-input-sun4i-lradc
> > >>>new file mode 100644
> > >>>index 0000000..e4e6448
> > >>>--- /dev/null
> > >>>+++ b/Documentation/ABI/testing/sysfs-driver-input-sun4i-lradc
> > >>>@@ -0,0 +1,4 @@
> > >>>+What:          /sys/class/input/input(x)/device/voltage
> > >>>+Date:          February 2015
> > >>>+Contact:       Priit Laes <plaes@plaes.org>
> > >>>+Description:   ADC output voltage in microvolts or 0 if device is
> > >>>not opened.
> > >>
> > >>Why is it returning 0 when "device is not opened" ? What does that
> > >>even mean? You can't read that file without opening it.
> > >
> > >It means that something has to open the /dev/input/inputX device which
> > >sets up the ADC before the voltage can be read from the sysfs file.
> > >
> > >[...]
> > >
> > >
> > >>
> > >>As I told you already, if you're going to expose this an ADC in the
> > >>end, the proper solution is to use the IIO framework, not adding a
> > >>custom sysfs file.
> > >
> > >My intention was to expose just a simple debug output, so one can
> > >press the buttons and read the voltages for devicetree keymap.
> > >
> > >If anyone can suggest a simpler approach than current sysfs based one,
> > >I would do it.
> > 
> > The android driver always uses 0.2V / 200mV steps, so what I do is
> > simply create a mapping with 200mV mapped to KEY_VOLUMEUP, 400mV mapped
> > to KEY_VOLUMEDOWN, etc. following the hardcoded android driver mapping:
> > 
> > https://github.com/linux-sunxi/linux-sunxi/blob/sunxi-3.4/drivers/input/keyboard/sun4i-keyboard.c#L136
> > 
> > Usually this will be correct in one go, after testing one can shuffle
> > key codes as needed (usually not needed) and/or remove unused entries.
> > 
> > With that said I do think that a sysfs file to see the actual voltages,
> > or a kernel parameter to printk them on keypress interrupt would be useful.
> > 
> > I guess the printk option would be better as it would show the actual
> > keypress value read, not some semi-random sample.
> 
> That wouldn't require that much code actually. Either using dev_dbg,
> or debugfs like Dmitry was suggesting would be two nice solutions I
> guess.

Given the stated purpose I'd say dev_dbg() and call it a day.

Thanks.

-- 
Dmitry
