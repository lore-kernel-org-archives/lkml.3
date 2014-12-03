Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbaLCUN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 15:13:56 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:52513 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbaLCUNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 15:13:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Andrew Jackson <Andrew.Jackson@arm.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>
Subject: Re: [PATCH 4/5] ASoC: dwc: Add devicetree support for Designware I2S
Date: Wed, 03 Dec 2014 21:13:18 +0100
Message-ID: <2041200.ZjakFFAZAU@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <547F3CAC.9050105@arm.com>
References: <547F3CAC.9050105@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:YMbdPcOwsJnZv6xxeyHvHd9bHllt42c0PNtH4vSfb3n
 tWtEApsfeHrwNQ5ZFZXfvqiFSbA92joZ5y3nwupKGs3of/2Egl
 GvduvYE3YIECVdPQVjirgm3lkN2RD0tJQbuK6hc0ujpcoZf01Q
 iAoVOWM8PWan+YqhKzzN4FEt4GO5pZs6K9jDQdSohW1BVaIv6K
 Ql7C5gUhmE2eB7vqnuIcN6DZfZSPEtlO9855SB+klWCzwLJiRG
 TSiQ2kpbJAwd9zGDFS5+4NPFb7MgxCddNUDkY87Hx6fUbW/1Xv
 JBxCDBAxVlAwueENxKCu7V/oGOGE1N1nJ2Su0NDew5M8f208Qt
 B+2U962jas55O7gvFOdw=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 December 2014 16:39:08 Andrew Jackson wrote:
> Convert to driver to use either platform_data or device-tree for configuration
> of the device.  When using device-tree, the I2S block's configuration is read
> from the relevant registers: this reduces the amount of information required in
> the device tree.
> 
> Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>

I don't think we even have to worry about the platform_data case here:
the only platform using this hardware in Linux is arm/mach-spear, and
it defines a device node with a binding that is similar to the one you
document here but that is not implemented in the driver.

So, I think for all practical purposes we can assume that nobody cares
if you make incompatible changes as long as you don't introduce build
regression.

Also, please adapt the 	arch/arm/boot/dts/spear13*.dts{,i} files
as good as you can. They are broken in other ways too that you don't
have to fix, just make them conform to the binding you add.

	Arnd
