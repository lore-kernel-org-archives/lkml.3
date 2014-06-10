Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaFJOsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 10:48:09 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:54579 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbaFJOsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 10:48:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Wolfram Sang <wsa@the-dreams.de>, Randy Dunlap <rdunlap@infradead.org>,
        Hans de Goede <hdegoede@redhat.com>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v5 2/2] i2c: sunxi: add P2WI (Push/Pull 2 Wire Interface) controller support
Date: Tue, 10 Jun 2014 16:47:55 +0200
Message-ID: <13219561.hrRmVFjmAv@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140610143604.GC7054@lukather>
References: <1402408036-5235-1-git-send-email-boris.brezillon@free-electrons.com> <6454089.IP8IFVsofj@wuerfel> <20140610143604.GC7054@lukather>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:5E6uIF668oBj4rymXoLHSx691uZe1XzywyJZjkFCBHW
 VH1fpz7/rDOyAZde5Gp5Z6ru5MsNGQVWyDcgEUdvzVExubUH7B
 bTaYy7w28HxcU8RGsc7j7v1vbu8SBmqfJ8do7rwpVAa6M1aCWZ
 P0ql4uL+DRbCksChsWUe9ZxoNpajYR7NHbKi1lF7acpg1Ocutl
 krG/lpQX2LxT49udAmXNUizqU0HSO/828i1g21b4EKeowYZxy4
 EOLlprVtIOAppFQqGk3aL6UPR53EdFqCZo33UcXitllFtfTfWo
 wuxRN0GAiM6A+OkDpPlT3361HlggwkqQs0DiMVuOXTs3Xz7vnm
 Ly8+qEx/Rsd9k8MRICvI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 June 2014 16:36:04 Maxime Ripard wrote:
> On Tue, Jun 10, 2014 at 03:54:56PM +0200, Arnd Bergmann wrote:
> > On Tuesday 10 June 2014 15:47:16 Boris BREZILLON wrote:
> > > 
> > > +config I2C_SUN6I_P2WI
> > > +       tristate "Allwinner sun6i internal P2WI controller"
> > > +       depends on ARCH_SUNXI
> > > +       help
> > > +         If you say yes to this option, support will be included for the
> > > +         P2WI (Push/Pull 2 Wire Interface) controller embedded in some sunxi
> > > +         SOCs.
> > > +         The P2WI looks like an SMBus controller (which supports only byte
> > > +         accesses), except that it only supports one slave device.
> > > +         This interface is used to connect to specific PMIC devices (like the
> > > +         AXP221).
> > > +
> > 
> > Sorry for the stupid question, but why is this an i2c driver if the
> > hardware protocol is completely different?
> 
> It's not completely different. It deviates, but still looks very
> similar to i2c, and to be precise, SMBus.
> 
> You'll have the full discussion that led to do this in i2c here:
> http://www.spinics.net/lists/linux-i2c/msg15066.html
> 
> Also, one significant thing to take into account is that the
> communication with a device starts as I2C, only to switch to this
> protocol after some initialization sequence.

Ok, sounds good.

> > I understand that a lot of devices can be driven using either spi or
> > i2c, and we have two sets of {directories,maintainers,bus_types,...}
> > for them. Your description sounds like this is a separate option
> > that isn't any closer to i2c than it is to spi.
> 
> That's not true. It's *much* closer from I2C than it is from SPI.

Ok.

> > Would it perhaps be better to expose it only as a regmap rather than
> > an i2c host?
> 
> That could be a solution, but is it a common practice to define a bus
> adapter driver in a regmap driver?

No, not yet.

Maybe Boris can just put an explanation into the changeset description
of the driver so other people are able to find it more easily.

	Arnd
