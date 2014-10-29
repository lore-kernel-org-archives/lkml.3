Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbaJ2I1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 04:27:49 -0400
Received: from ozlabs.org ([103.22.144.67]:59678 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755469AbaJ2I1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 04:27:45 -0400
Message-ID: <1414571262.5922.0.camel@concordia>
Subject: Re: [PATCH] drivers: depend on instead of select
 BACKLIGHT_CLASS_DEVICE and ACPI_VIDEO
From: Michael Ellerman <mpe@ellerman.id.au>
To: Jani Nikula <jani.nikula@intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-fbdev@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>,
        Daniel Drake <dsd@laptop.org>, Jens Frederich <jfrederich@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jon Nettleton <jon.nettleton@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        platform-driver-x86@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Darren Hart <dvhart@infradead.org>,
        Daniel Vetter <daniel.vetter@intel.com>, Bryan Wu <cooloney@gmail.com>,
        linuxppc-dev@lists.ozlabs.org
Date: Wed, 29 Oct 2014 19:27:42 +1100
In-Reply-To: <87tx2njooz.fsf@intel.com>
References: <1413580403-16225-1-git-send-email-jani.nikula@intel.com>
	 <54476492.6090105@ti.com> <87a94hu3j0.fsf@intel.com>
	 <544E44E9.4040208@ti.com> <544FFC91.9040104@infradead.org>
	 <1414551853.7417.1.camel@concordia> <87tx2njooz.fsf@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-29 at 09:54 +0200, Jani Nikula wrote:
> On Wed, 29 Oct 2014, Michael Ellerman <mpe@ellerman.id.au> wrote:
> > On Tue, 2014-10-28 at 13:29 -0700, Randy Dunlap wrote:
> >> On 10/27/14 06:13, Tomi Valkeinen wrote:
> >> > I also think the 'depends on BACKLIGHT_CLASS_DEVICE ||
> >> > BACKLIGHT_CLASS_DEVICE=n' pattern is quite... interesting (i.e. sounds
> >> > like a hack to me =).
> >> 
> >> It does exactly what is needed and it is used in many places in kernel
> >> Kconfig files.
> >
> > Is there any reason you can't do:
> >
> >   depends on BACKLIGHT_CLASS_DEVICE != m
> 
> That's not the same thing. The FOO || FOO=n allows for all options, but
> forbids it being a module when the option depending on it is
> built-in.

OK right. Because "BAR depends on FOO" is short for "depends on FOO=y || FOO=m",
but also adds the implicit condition that if FOO=m then BAR must also be m.

Thanks for clueing me in.

cheers


