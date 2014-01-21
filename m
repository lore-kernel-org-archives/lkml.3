Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbaAUSur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 13:50:47 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:59861 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396AbaAUSuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 13:50:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCH RFC 4/6] net: rfkill: gpio: add device tree support
Date: Tue, 21 Jan 2014 19:50:06 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        netdev <netdev@vger.kernel.org>,
        "linux-wireless" <linux-wireless@vger.kernel.org>,
        "linux-sunxi" <linux-sunxi@googlegroups.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        "Chen-Yu Tsai" <wens@csie.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
References: <1389941251-32692-1-git-send-email-wens@csie.org> <201401211335.16885.arnd@arndb.de> <CAAVeFuKFfAvSPYLmvWV5jjT-peZFJ8sJ2bbh4F=JAYoWLhjZpA@mail.gmail.com>
In-Reply-To: <CAAVeFuKFfAvSPYLmvWV5jjT-peZFJ8sJ2bbh4F=JAYoWLhjZpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201401211950.07011.arnd@arndb.de>
X-Provags-ID: V02:K0:fMmEYTpMU9mz5BkwaZd6xblpOuxeBKt1xYZMATyMiOy
 r1G5aiBiXGhh3ejkjHLtDK0NfgAdS6hsq7fKmZLa1DqySnnPEF
 q5ZeweX23qgz4dQRPWu5HZndu17thkh215UfHTibKCOcdIkRhS
 znM3lpE0AEs+8udISUlnC7dEY740GgwRfIzMps+A24CIqr+60k
 Up62IywHiXWXkNqtUO2a6C7wUaNBZBy1HjBSfRP+2zg33Cr1xa
 kw9fVFSlxzWGjfrtFOt/dkECph64lz02KVua+XYm47E7YbYk4+
 3dKlAFSfcvtlYg+4qc8KWRdlwfozxjiEkbo3/1krQaIzUqgals
 I9mEqLx3L+usRWsOBvkA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 January 2014, Alexandre Courbot wrote:
> >> As discussed earlier in this thread I'm not sure the con_id is
> >> suitable for labelling GPIOs. It'd be better to have a proper name
> >> specified in DT/ACPI instead.
> >
> > +1
> 
> I wonder why you guys prefer to have the name defined in the GPIO
> mapping. Having the driver decide the label makes it easier to look up
> which GPIO does what in debugfs, whereas nothing prevents people to
> name GPIOs whatever inadequate name they want in the device DT node.
> What am I overlooking here?

I should have another look at the debugfs representation, but isn't
there a global namespace that gets used for all gpios?  Neither the
con_id nor the name that the driver picks would be globally unique
and stable across kernel versions, so they don't make a good user
interface.

I think what we want here is a system-wide unique identifier for
each gpio line that may get represented in debugfs, and use a new
DT mechanism to communicate that.

	Arnd
