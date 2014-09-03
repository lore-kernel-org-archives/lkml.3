Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616AbaICPKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 11:10:21 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:49465 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbaICPKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 11:10:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        linaro-acpi@lists.linaro.org, Marc Zyngier <Marc.Zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Robert Moore <robert.moore@intel.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Olof Johansson <olof@lixom.net>, Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [Linaro-acpi] [RFC PATCH for Juno 1/2] net: smsc911x add support for probing from ACPI
Date: Wed, 03 Sep 2014 17:09:48 +0200
Message-ID: <4569324.eR9S3K10NB@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2913007.3xRNb2X4ts@vostro.rjw.lan>
References: <1409583961-7466-1-git-send-email-hanjun.guo@linaro.org> <20140902162606.GX29327@sirena.org.uk> <2913007.3xRNb2X4ts@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:bXKSLx0j2T/3rJqQIaGoCknyuYNAtcAH6oucwk/45Xh
 HelspHJXcJTTPSiNPB/9Cgd0hFNbp4PIAjrOSE8gXWQqjZAjuC
 m8QHambIVvGN1wGlHLU8npoNmm1N1YYUAxCbiDMK2+ZQkSOgF9
 k1JLkqL29ZzpLunY9ghUhRQ4x7Vs8Fwymd1K/nxsThj04NvEjq
 +YlbtXL1tN5Qroo8LWJdDwsfiWjB4P++iYMjgmV7jMNZXS9pLh
 7vCXId2uKGxzpFwvsHb0hb5RbGtzm6tdAIMGUZw31nDSYyqF3B
 ylS8ypML9gyZkaNTtnQoO48RsbA2ryp8bJSCUuUal3l3QagI20
 JGW9Ec4+bno/FLP/zIVo=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 September 2014 01:00:23 Rafael J. Wysocki wrote:
> On Tuesday, September 02, 2014 05:26:06 PM Mark Brown wrote:
> > 
> > --s3puAW9DMBtS2ARW
> > Content-Type: text/plain; charset=us-ascii
> > Content-Disposition: inline
> > 
> > On Tue, Sep 02, 2014 at 03:42:53PM +0200, Arnd Bergmann wrote:
> > 
> > > The way I recall the discussion, most people were on one extreme
> > > side of the discussion or the other:
> > 
> > > a) We should use _DSD for ARM64 servers to maximize code reuse with
> > > DT-enabled drivers, work around the slow UEFI standardization process,
> > > remain in control of the actual bindings, and avoid the need for
> > > endless per-ID platform-data definitions in drivers.
> > 
> > > b) We should never use _DSD at all, since doing that would have no
> > > advantage over using DT directly, and we should force every device
> > > manufacturer to specify their bindings in an official ACPI document
> > > to prevent random incompatible bindings from being established.
> > > Any device that shows up in servers should not need arbitrary detailed
> > > properties anyway, as the details are supposed to be hidden in AML.
> > 
> > > I can understand the reasons for both approaches, and I find it hard
> > > to say either one is invalid. However, the worst possible outcome in
> > > my opinion would be having to support a mix of the two.
> > 
> > Right, and the x86 embedded folks are going full steam ahead with _DSD
> > regardless so it seems there will be some systems out there using it
> > even if they're not ARM servers.
> 
> Our intention is specifically not to use "random incompatible bindings"
> in that.  We'd rather have a common venue and process for establishing
> new bindings for both DT and _DSD in a compatible way.

Right, I think everyone is on the same page for the embedded x86 case,
my point was that there is no consensus about that yet among the
parties involved in arm64 servers.

	Arnd
