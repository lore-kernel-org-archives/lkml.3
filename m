Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbaHSRUZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 13:20:25 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:43752 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbaHSRUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 13:20:24 -0400
Message-ID: <53F38754.2050808@redhat.com>
Date: Tue, 19 Aug 2014 19:20:20 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Amit Shah <amit.shah@redhat.com>, jgarzik@bitpay.com
CC: linux-kernel@vger.kernel.org,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        hpa@linux.intel.com
Subject: Re: [PATCH 2/2] Install udev rules in system-default directory
References: <cover.1407416628.git.amit.shah@redhat.com> <3df55388b1b3acd142f391494f102c3ddb2270ed.1407416628.git.amit.shah__45224.3810439997$1407417016$gmane$org@redhat.com>
In-Reply-To: <3df55388b1b3acd142f391494f102c3ddb2270ed.1407416628.git.amit.shah__45224.3810439997$1407417016$gmane$org@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 07/08/2014 15:09, Amit Shah ha scritto:
> +udevrules_DATA	 = 90-virtio-rng.rules

If rng-tools is packaged with "make dist" you need this to be

dist_udevrules_DATA	 = 90-virtio-rng.rules

or alternatively

EXTRA_DIST = 90-virtio-rng.rules
udevrules_DATA	 = 90-virtio-rng.rules

> +AC_ARG_WITH([udevrulesdir],
> +	AS_HELP_STRING([--with-udevrulesdir=DIR], [Directory for udev rules]),
> +	[],
> +	[with_udevrulesdir=$($PKG_CONFIG --variable=udevdir udev)"/rules.d"])
> +AC_SUBST([udevrulesdir], [$with_udevrulesdir])

You can use AM_CONDITIONAL to skip the installation if
$with_udevrulesdir is "no" (aka --without-udevrulesdir).  Then you'd have

EXTRA_DIST = 90-virtio-rng.rules
if INSTALL_UDEV_RULES
udevrules_DATA	 = 90-virtio-rng.rules
endif

I don't know offhand if this works:

if INSTALL_UDEV_RULES
dist_udevrules_DATA	 = 90-virtio-rng.rules
endif

but I think so; you can check with "./configure --without-udevrulesdir
&& make && make dist".

Thanks,

Paolo
