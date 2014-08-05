Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbaHEXG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 19:06:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54605 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaHEXG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 19:06:56 -0400
Date: Tue, 5 Aug 2014 16:06:54 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Pawel Moll <pawel.moll@arm.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "paul@pwsan.com" <paul@pwsan.com>, Arnd Bergmann <arnd@arndb.de>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] char: tile-srom: Remove reference to platform_bus
Message-ID: <20140805230654.GA24614@kroah.com>
References: <1406298233-27876-1-git-send-email-pawel.moll@arm.com>
 <1406298233-27876-2-git-send-email-pawel.moll@arm.com>
 <53DAA605.2030500@tilera.com>
 <1406913678.22529.46.camel@hornet>
 <53E139C8.9000502@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E139C8.9000502@tilera.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 04:08:40PM -0400, Chris Metcalf wrote:
> On 8/1/2014 1:21 PM, Pawel Moll wrote:
> >On Thu, 2014-07-31 at 21:24 +0100, Chris Metcalf wrote:
> >>On 7/25/2014 10:23 AM, Pawel Moll wrote:
> >>>The code was creating "srom" class devices using
> >>>platform_bus as a parent. As they are not really
> >>>platform devices, make them virtual, using NULL instead.
> >>>
> >>>Cc: Chris Metcalf<cmetcalf@tilera.com>
> >>>Signed-off-by: Pawel Moll<pawel.moll@arm.com>
> >>>---
> >>>   drivers/char/tile-srom.c | 2 +-
> >>>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>Can you clarify the point of this change a bit?
> >Theoretically speaking there shouldn't be any need to export the
> >platform bus root, as all devices should be registered via the platform
> >API (platform_device_register & co.)
> 
> So, perhaps the right fix is to just use platform_device_register()
> etc for this device, rather than making it virtual?

Sure, that's fine with me if you want to make it a platform device, but
note that a platform device doesn't have a minor associated with it, you
will have to still have your existing srom_class and the rest.  Right
now you aren't creating any real "devices" in the kernel, other than the
one you use for your minor number, which is not a "real" device.

struct srom_dev should be a platform device and then this will get
"easier" overall, sorry I missed that when the original code was
submitted.

thanks,

greg k-h
