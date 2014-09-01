Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbaIAKh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 06:37:28 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:56915 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbaIAKh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 06:37:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: Pankaj Dubey <pankaj.dubey@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, linux@arm.linux.org.uk,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        thomas.ab@samsung.com, chow.kim@samsung.com,
        Tomasz Figa <t.figa@samsung.com>, broonie@kernel.org
Subject: Re: [PATCH] mfd: syscon: Decouple syscon interface from syscon devices
Date: Mon, 01 Sep 2014 12:37:10 +0200
Message-ID: <4121644.3haxjiIdIo@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140901074918.GB6226@lee--X1>
References: <1408694991-21615-1-git-send-email-pankaj.dubey@samsung.com> <20140901074918.GB6226@lee--X1>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:2mfLVKZmjamomCjiAvEWps5xR7Jmy4a765NrVQLD592
 K9lH3+bUFO+P+XvBTOcOwh3aKhc9mc09x7tNim9Q7tJ84ATJ2+
 Ds/VlLI1qXNOqkbCnooSLokgWBc+ucfZibpUhxmLaXm9lMTlMj
 H27PQp6mFP3XTbboJHV1+xx9eneuN05ygZbZ2FIvu+tstc6NwK
 ivpPrOkRSgjbI5+iHEmeHR12WSZLxcNtUsnIykILYc9XYm+rms
 PboxYdixl2ViS8iuKhvnJi4S2JSaoXiYmMmO5rVAyIfuILCTxF
 GibFml4BHVc0r17KyOpfRn7EJ+IuUqM1M342HuhDp79lhn3vJy
 VpMptVHCsvz4RFZYBL9c=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 September 2014 08:49:18 Lee Jones wrote:
> On Fri, 22 Aug 2014, Pankaj Dubey wrote:
> 
> > From: Tomasz Figa <t.figa@samsung.com>
> > 
> > Currently a syscon entity can be only registered directly through a
> > platform device that binds to a dedicated driver. However in certain use
> > cases it is desirable to make a device used with another driver a syscon
> > interface provider. For example, certain SoCs (e.g. Exynos) contain
> > system controller blocks which perform various functions such as power
> > domain control, CPU power management, low power mode control, but in
> > addition contain certain IP integration glue, such as various signal
> > masks, coprocessor power control, etc. In such case, there is a need to
> > have a dedicated driver for such system controller but also share
> > registers with other drivers. The latter is where the syscon interface
> > is helpful.
> > 
> > This patch decouples syscon object from syscon driver, so that it can be
> > registered from any driver in addition to the original "syscon" platform
> > driver.
> > 
> > Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> > Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> > ---
> > 
> > RFC patch [1] was posted by Tomasz Figa. This patch addresses some of
> > comments given by Arnd to RFC patch, and further decouples syscon from
> > device model. It also gives flexibility of registering with syscon at
> > early stage using device_node object.
> 
> It would be helpful if Arnd gave this revision his blessing (Ack).

I never saw a reason why we don't take this all the way as discussed
a few times: Completely remove the dependency of syscon on having
a platform driver for it, and make it possible to just call
syscon_regmap_lookup_by_phandle() without having to register
it first.

	Arnd
