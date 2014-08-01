Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbaHARVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 13:21:16 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:35955 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750851AbaHARVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 13:21:14 -0400
Message-ID: <1406913678.22529.46.camel@hornet>
Subject: Re: [PATCH 2/5] char: tile-srom: Remove reference to platform_bus
From: Pawel Moll <pawel.moll@arm.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "paul@pwsan.com" <paul@pwsan.com>, Arnd Bergmann <arnd@arndb.de>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 01 Aug 2014 18:21:18 +0100
In-Reply-To: <53DAA605.2030500@tilera.com>
References: <1406298233-27876-1-git-send-email-pawel.moll@arm.com>
	 <1406298233-27876-2-git-send-email-pawel.moll@arm.com>
	 <53DAA605.2030500@tilera.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-31 at 21:24 +0100, Chris Metcalf wrote:
> On 7/25/2014 10:23 AM, Pawel Moll wrote:
> > The code was creating "srom" class devices using
> > platform_bus as a parent. As they are not really
> > platform devices, make them virtual, using NULL instead.
> >
> > Cc: Chris Metcalf<cmetcalf@tilera.com>
> > Signed-off-by: Pawel Moll<pawel.moll@arm.com>
> > ---
> >   drivers/char/tile-srom.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Can you clarify the point of this change a bit? 

Theoretically speaking there shouldn't be any need to export the
platform bus root, as all devices should be registered via the platform
API (platform_device_register & co.)

>  The SROM devices
> in question are real devices (bits of silicon on the processor die), not
> some kind of virtual construct.  

... but the driver seems to be accessing then through hypervisor calls
only? One could say that you this make them virtual ;-)

> In addition, we also have user binaries
> in the wild that know to look for /sys/devices/platform/srom/ paths,
> so I'm pretty reluctant to change this path without good reason.

So what is the srom class for then if not for device discovery? And why
do they look for them in the first place? To get relevant character
device's data, if I understand it right?

Maybe you could just register a simple "proper" platform device for all
the sroms and then hang the class devices from it? I can type some code
doing this if it sound reasonably?

Pawel

