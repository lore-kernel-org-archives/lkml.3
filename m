Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756AbaHZLgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 07:36:35 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:59192 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757719AbaHZLgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 07:36:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Andrew Bresticker <abrestic@chromium.org>, linux-tegra@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kishon Vijay Abraham I <kishon@ti.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, Jonas Bonn <jonas@southpole.se>,
        David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Subject: Re: [PATCH v2 2/9] mailbox: Add NVIDIA Tegra XUSB mailbox driver
Date: Tue, 26 Aug 2014 13:35:34 +0200
Message-ID: <14224406.FU8QFA3vsD@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140826102011.GA31124@ulmo>
References: <1408381705-3623-1-git-send-email-abrestic@chromium.org> <5184912.mY2hCPH20k@wuerfel> <20140826102011.GA31124@ulmo>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:r1P8FL91kD5K0xI/S0bVgAANNUgI4gBsOYJxyi4InTM
 2r1gcQq+GswNd0q5bH2xWh/NOSZhudrRamAK9DFJhspe8qCtll
 QF7Z3s7IRQjpzGggVizRmtiwZwAKPhpwOPMlJDOPSLgjDSWAQl
 udMDgHT+vY6nrkqcDwf4URWt4msxLhcsrneGvhlwLaabnWRjT1
 udSsEgjyx+qznioMKk9RG3Sqgq3acr1Wd2XANasV8+SuIvUmVE
 T35kNMTflkbcxiyJUhTa1avHkFoSVKess4K/l61JKXZlug+pmH
 LmNVkDjDilewy4X5BN/zqEX6HtVeQlWbMg43IjB9iwYle7TgRI
 E/bNaSUd5n+azAjwIT7U=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 August 2014 12:20:13 Thierry Reding wrote:
> On Tue, Aug 26, 2014 at 11:54:43AM +0200, Arnd Bergmann wrote: > 
> > I'm not sure if it's really worth it. One thing we might do is just
> > remove all definitions of ioremap_nocache and add a wrapper to
> > include/linux/io.h, to make it more obvious what is going on.
> 
> Yes, I suppose that would work too. I still think there's an advantage
> in being explicit and avoid aliases like this. Perhaps a __deprecated
> annotation would help with that?

I fear adding __deprecated would be too controversial, because that
would add hundreds of new warnings to code that is not actually wrong.

	Arnd
