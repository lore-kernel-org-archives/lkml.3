Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbaJMINC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 04:13:02 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:64743 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbaJMIM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 04:12:57 -0400
Date: Mon, 13 Oct 2014 09:12:53 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sebastian Reichel <sre@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] MFD for v3.18
Message-ID: <20141013081253.GA17534@lee--X1>
References: <20141010094046.GH26795@lee--X1>
 <CA+55aFyH-E4BTk0EVLnyVDqxtTNxAMM8fnzeo5=sfFaEp8RYhw@mail.gmail.com>
 <20141011164403.GA19541@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141011164403.GA19541@earth.universe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

On Sat, 11 Oct 2014, Sebastian Reichel wrote:
> On Sat, Oct 11, 2014 at 07:01:09AM -0400, Linus Torvalds wrote:
> > On Fri, Oct 10, 2014 at 5:40 AM, Lee Jones <lee.jones@linaro.org> wrote:
> > >  The following changes since commit 52addcf9d6669fa439387610bc65c92fa0980cef:
> > >
> > >   Linux 3.17-rc2 (2014-08-25 15:36:20 -0700)
> > >
> > > are available in the git repository at:
> > >
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git tags/mfd-for-linus-3.18
> > 
> > This causes Kconfig problems for me when doing "make allmodconfig":
> > 
> >   fs/sysfs/Kconfig:1: symbol SYSFS is selected by CHARGER_MAX14577
> >   drivers/power/Kconfig:327: symbol CHARGER_MAX14577 depends on POWER_SUPPLY
> >   drivers/power/Kconfig:1: symbol POWER_SUPPLY is selected by HID_SONY
> >   drivers/hid/Kconfig:649: symbol HID_SONY depends on NEW_LEDS
> >   drivers/leds/Kconfig:8: symbol NEW_LEDS is selected by SENSORS_APPLESMC
> >   drivers/hwmon/Kconfig:299: symbol SENSORS_APPLESMC depends on HWMON
> >   drivers/hwmon/Kconfig:5: symbol HWMON is selected by EEEPC_LAPTOP
> >   drivers/platform/x86/Kconfig:496: symbol EEEPC_LAPTOP depends on HOTPLUG_PCI
> >   drivers/pci/hotplug/Kconfig:5: symbol HOTPLUG_PCI depends on SYSFS
> > 
> > and the reason seems to be your changes to drivers/power/Kconfig for
> > the CHARGER_MAX14577 symbol.
> > 
> > So I pulled and then unpulled.  I realize you're not the only guilty
> > party in this chain, but your pull is the final drop, so.. I would
> > suggest making that MAX14577 charger interface _depend_ on SYSFS, not
> > try to select it.
> 
> This is fixed in battery-2.6.git. I will send a pull request in a
> couple of minutes.

Okay, I just tested Sebastian's new pull-request with mine (in both
orders).  Krzysztof's patch fixes the problem i.e. Git does the right
thing.  I believe it's now safe to pull in Sebastian's and my
branches.

Let me know if there's any other action I should take.

Kind regards,
Lee

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
