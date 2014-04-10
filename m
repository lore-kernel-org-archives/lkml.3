Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965705AbaDJJhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:37:05 -0400
Received: from moutng.kundenserver.de ([212.227.17.13]:52396 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965656AbaDJJg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:36:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>, Andrew Lunn <andrew@lunn.ch>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko.stuebner@bq.com>,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Silvio F <silvio.fricke@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Olof Johansson <olof@lixom.net>, Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH 3/4] arm: add basic support for Mediatek MT6589 boards
Date: Thu, 10 Apr 2014 11:36:53 +0200
Message-ID: <8724412.Xp2CkgARik@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53465A4B.4040906@free-electrons.com>
References: <1397072736-10793-1-git-send-email-matthias.bgg@gmail.com> <CABuKBeKnEw38sQYwrkheoWetZZcPTJhKRsBK4a62FS6-6dRFTA@mail.gmail.com> <53465A4B.4040906@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:7EjjxJ7RFUxFE0erCGR/MEzmSvjfi3UBdpJPyk1tVFF
 lV3w4yCGMBm0YBnt1HPqGCNqfLzxinK4KGpGvPWogiZ3TO/AyQ
 JtKbzcj6ruJYtCL6+5/3+evpZmANOqPkoB0uMNORSHHRwsEAyt
 4bhp8U8mP6JCtrunZtp9baIN/IFDPro2hJNHfXuqDrycIkq6Ne
 okdd+0vrRx0F8Nvu+n4mXEaBR5j+Oi/50BogxKqK9u6jo/4/zz
 4TmkpY6mWyDViw/i9QHBmotuRnOmjxc2XfzGbR5K/v17tHERpq
 8g0hWU8HnFLueWGhdPYjVqh7lzHSSN31JNC+HNE/AWW9ScnAEb
 1HOgXdrBEAbIRpxMpoiM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 April 2014 08:46:03 Gregory CLEMENT wrote:
> >>
> >> Is it really a fixed clock without any parent, or do you
> >> declare it as a fixed clock because you don't have any clock
> >> common framework support yet?
> > 
> > I don't have any common clock framework support yet.
> 
> So maybe you should provide one (even a very simple one).
> 
> Pretending a clock is a fixed clock and ignoring its parents
> will be problematic when you will add the common clock framework
> support because the device tree is supposed to be stable and you won't
> be able to change it then.

But is this actually a problem here? The current device tree file
will keep working even if the proper driver is there, you just need
to update both the driver and the dts file in order to actually
use the clocks at run-time.

I guess it comes down to the question of whether we want to handle
old kernels with new device trees again, which would be broken here.

	Arnd
