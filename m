Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625AbaIWPqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 11:46:17 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:58839 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223AbaIWPqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 11:46:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Aaron Lu <aaron.lu@intel.com>
Subject: Re: [RFC PATCH v2 07/16] gpio: Add support for unified device properties interface
Date: Tue, 23 Sep 2014 17:45:57 +0200
Message-ID: <12538216.vu4CbU01qP@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CACRpkdaZJt_6cd1vtDw-Ys+YqUhNb0aXazUxGCX8mk4=6EmdHw@mail.gmail.com>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <1410868367-11056-8-git-send-email-mika.westerberg@linux.intel.com> <CACRpkdaZJt_6cd1vtDw-Ys+YqUhNb0aXazUxGCX8mk4=6EmdHw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:VCCmUSgGCWPH/Q4BtjgkWNZ8zHFopDA0nPiy6KMgNx5
 gUgSypme2GQRCAEPCjZUQjW//iUp4QfCKI+NkONVgPw68EUzao
 r8Uytx7x/fXU0QlRpkH70jgCxUTCXdKHMuFFjtElLs5S0Ege+Y
 AN4Szid4uOL+rjzksHXb+dgZbBhtD/vdaGTl+8eUZkrJSggXPN
 RQL9xbTEzZc2K8COSD7B6o+ZlcFcSeRksd6dLOI64LGGyoeOTx
 SHXnKBz3gEp3NbIFWwco23PkvKurh+EvRbZoQnMQ2rNCaE8mXm
 15a2bffzbj250tmyisOzlNC5j56HfY+mLb3I6YqQ62NMnMdw7r
 NSmELvjAfy99nmIuqxF4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 September 2014 17:25:50 Linus Walleij wrote:
> On Tue, Sep 16, 2014 at 1:52 PM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> 
> > Some drivers need to deal with only firmware representation of its
> > GPIOs. An example would be a GPIO button array driver where each button
> > is described as a separate firmware node in device tree. Typically these
> > child nodes do not have physical representation in the Linux device
> > model.
> >
> > In order to help device drivers to handle such firmware child nodes we
> > add dev[m]_node_get_named_gpiod() that takes a firmware node pointer as
> > parameter, finds the GPIO using whatever is the underlying firmware
> > method, and requests the GPIO properly.
> >
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> I have a hard time figuring out if this is what we want for common
> accessors between DT and ACPI.
> 
> Can I get some input from Grant, Arnd, Mark, Darren...?

I just took a brief look at this. My first impression is that the
fw_dev_node structure is weird when all callers just do (in patch 2)

+	struct fw_dev_node fdn = {
+		.of_node = dev->of_node,
+		.acpi_node = ACPI_COMPANION(dev),
+	};

I'd much rather see an interface that passes the 'struct device'
pointer down to dev_get_named_gpiod() and all other exported
functions, and then internally does the conversion at the point
where the access is done.

	Arnd
