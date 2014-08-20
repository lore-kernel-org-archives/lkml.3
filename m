Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbaHTEhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 00:37:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbaHTEhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 00:37:18 -0400
Date: Wed, 20 Aug 2014 10:06:17 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: jgarzik@bitpay.com, linux-kernel@vger.kernel.org,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        hpa@linux.intel.com
Subject: Re: [PATCH 2/2] Install udev rules in system-default directory
Message-ID: <20140820043617.GF18175@grmbl.mre>
References: <cover.1407416628.git.amit.shah@redhat.com>
 <3df55388b1b3acd142f391494f102c3ddb2270ed.1407416628.git.amit.shah__45224.3810439997$1407417016$gmane$org@redhat.com>
 <53F38754.2050808@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F38754.2050808@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Tue) 19 Aug 2014 [19:20:20], Paolo Bonzini wrote:
> Il 07/08/2014 15:09, Amit Shah ha scritto:
> > +udevrules_DATA	 = 90-virtio-rng.rules
> 
> If rng-tools is packaged with "make dist" you need this to be
> 
> dist_udevrules_DATA	 = 90-virtio-rng.rules
> 
> or alternatively
> 
> EXTRA_DIST = 90-virtio-rng.rules
> udevrules_DATA	 = 90-virtio-rng.rules
> 
> > +AC_ARG_WITH([udevrulesdir],
> > +	AS_HELP_STRING([--with-udevrulesdir=DIR], [Directory for udev rules]),
> > +	[],
> > +	[with_udevrulesdir=$($PKG_CONFIG --variable=udevdir udev)"/rules.d"])
> > +AC_SUBST([udevrulesdir], [$with_udevrulesdir])
> 
> You can use AM_CONDITIONAL to skip the installation if
> $with_udevrulesdir is "no" (aka --without-udevrulesdir).  Then you'd have
> 
> EXTRA_DIST = 90-virtio-rng.rules
> if INSTALL_UDEV_RULES
> udevrules_DATA	 = 90-virtio-rng.rules
> endif
> 
> I don't know offhand if this works:
> 
> if INSTALL_UDEV_RULES
> dist_udevrules_DATA	 = 90-virtio-rng.rules
> endif
> 
> but I think so; you can check with "./configure --without-udevrulesdir
> && make && make dist".

Thanks!  Will give this a shot for curiosity's sake.  The
khwrngd-based patch has already been merged upstream, so this is now
obsolete.


		Amit
