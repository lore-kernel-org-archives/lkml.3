Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbaAZVop (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 16:44:45 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:4282 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbaAZVoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 16:44:44 -0500
Date: Sun, 26 Jan 2014 22:44:25 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Mark Brown <broonie@kernel.org>
Cc: Guenter Roeck <linux@roeck-us.net>, LM Sensors <lm-sensors@lm-sensors.org>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Wei Ni <wni@nvidia.com>
Subject: Re: lm90 driver no longer working on PCs in 3.13
Message-ID: <20140126224425.724698cd@endymion.delvare>
In-Reply-To: <20140126212256.GK11727@sirena.org.uk>
References: <52E561D0.4040308@roeck-us.net>
	<20140126211357.6fa68909@endymion.delvare>
	<52E573B6.9040903@roeck-us.net>
	<20140126214936.7736f530@endymion.delvare>
	<20140126212256.GK11727@sirena.org.uk>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Sun, 26 Jan 2014 21:22:56 +0000, Mark Brown wrote:
> On Sun, Jan 26, 2014 at 09:49:36PM +0100, Jean Delvare wrote:
> > On Sun, 26 Jan 2014 12:44:38 -0800, Guenter Roeck wrote:
> 
> > > Maybe there is some configuration option, or maybe something needs to be
> > > configured from user space. I found neither.
> 
> > Neither would be acceptable to my eyes anyway. Things worked out of the
> > box before, they should keep working out of the box.
> 
> They only worked with a debug option turned on and generated warnings
> every time they were used...  that kernel config would've been actively
> broken for devices that wanted to do anything at all interesting with
> the regulators and would've been prone to issues with init ordering and
> races in any cases where there are actually regulators.

No, you don't get what I'm saying. For PC users, the lm90 did not
request a regulator and things worked because the kernel isn't supposed
to take care about things like that on PC machines. Now that the lm90
driver does request a regulator, it fails on PC machines because no
regulator is declared.

PC users never had to do anything fancy to get the lm90 driver to work.
Just enabling the driver and loading it, did the trick. And that's
exactly how things must be. Hence my claim.

To be clear: my "before" is not referring to "before the dummy
regulator was dropped". It is referring to "before commit 3e0f964f2ad -
hwmon: (lm90) Add power control". I don't know a thing about all this
regulator stuff.

> > (...)
> > Well, either the regulator subsystem gets fixed (or provides a suitable
> > API for drivers like lm90 and we update the lm90 driver to use it), or
> > I'll just revert the problematic commit for now. This is a severe
> > regression, we just can't leave things that way.
> 
> It's not an issue in the driver, it's an issue in the combination of the
> platform and the kernel config.  If the regulator API is going to be
> turned on for the platform then either the platform needs to configure
> the supplies or it needs to tell the regulator core that it's safe to
> start using dummy regulators.
> 
> What is this platform and why does it have the regulator API enabled in
> the first place?

Regular PC. It has regulator API enabled, because it is possible to
enable it, I suppose, and developers try to test various combinations
of kernel config options. Guenter can tell more, I do not have it
enabled (which is why it did not fail for me, BTW.)

Don't tell me that it is expected that things will fail if
CONFIG_REGULATOR is enabled on a system which doesn't need it. It
doesn't make any sense. If kernels would fail as soon as any enabled
option wasn't actually needed, no system would boot out there.

If regulator is enabled but not needed, that's something the regulator
subsystem should figure out at run-time so that it can stub everything
out and things keep working.

-- 
Jean Delvare
