Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbaIAM1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 08:27:35 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:44035 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751832AbaIAM1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 08:27:33 -0400
Message-ID: <1409574460.4343.7.camel@hornet>
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
Date: Mon, 01 Sep 2014 13:27:40 +0100
In-Reply-To: <5400C9C1.4060904@tilera.com>
References: <1406298233-27876-1-git-send-email-pawel.moll@arm.com>
	 <1406298233-27876-2-git-send-email-pawel.moll@arm.com>
	 <53DAA605.2030500@tilera.com> <1406913678.22529.46.camel@hornet>
	 <53E139C8.9000502@tilera.com> <1407515691.31897.26.camel@hornet>
	 <5400C9C1.4060904@tilera.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-29 at 19:43 +0100, Chris Metcalf wrote:
> >> Thank you for volunteering to write a bit of code; if that's the best
> >> way to clarify this for us, fantastic, or else pointing us at existing
> >> good practices or documentation would be great too.
> > [...]
> > @@ -350,7 +351,7 @@ static int srom_setup_minor(struct srom_dev *srom, int index)
> >  		       SROM_PAGE_SIZE_OFF, sizeof(srom->page_size)) < 0)
> >  		return -EIO;
> >
> > -	dev = device_create(srom_class, &platform_bus,
> > +	dev = device_create(srom_class, srom_parent,
> >  			    MKDEV(srom_major, index), srom, "%d", index);
> >  	return PTR_ERR_OR_ZERO(dev);
> >  }
> 
> The second argument should be &srom_parent.dev though, I think.  Right?

Yes, sure - as I said, I haven't really tested this code, sorry!


> If the
> consensus is that this is the way to go, I can certainly take this change
> into the Tile tree.

That would be cool, and left us only with the scsi/DMA as the last user
of platform_bus. But this is a completely different story ;-)

Paweł

