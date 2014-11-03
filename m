Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbaKCVE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 16:04:26 -0500
Received: from mailout3.w2.samsung.com ([211.189.100.13]:26780 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbaKCVEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 16:04:23 -0500
X-AuditID: cbfec372-b7f666d000001846-e8-5457edd605c7
Date: Mon, 03 Nov 2014 19:04:14 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Carlo Caione <carlo@caione.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>
Subject: Re: [PATCH 1/3] media: rc: add driver for Amlogic Meson IR remote
 receiver
Message-id: <20141103190414.3b035319.m.chehab@samsung.com>
In-reply-to: <20141103205453.GA18529@gmail.com>
References: <1413144115-23188-1-git-send-email-b.galvani@gmail.com>
 <1413144115-23188-2-git-send-email-b.galvani@gmail.com>
 <20141103111410.6b1147a0.m.chehab@samsung.com>
 <20141103205453.GA18529@gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsVy+t/hYN1rb8NDDF53Cloc3d3LavFgzXpm
	i/lHzrFa9L9ZyGpx7tVKRoujD16xW2x6fI3V4vKuOWwWPRu2slosvX6RyWLC9LUsFq17j7Bb
	rP72icmB1+PImtWMHmvmrWH06DrZx+Rxua+XyWPnrLvsHiuXf2Hz2LSqk81j85J6j8+b5AI4
	o7hsUlJzMstSi/TtErgyXrUtYSn4I1vxdeERxgbGXeJdjJwcEgImEkf7v7FC2GISF+6tZ+ti
	5OIQEljCKPH26xEmCKeRSeLgo5XsIFUsAqoS/VP/soHYbAJGEq8aW4C6OThEBLQlOp+ygtQz
	C6xlljh6qpUNJC4sECqxYF8aSDmvgJXEpvvnwVo5BfQlrq6bzghiCwlcZpT4+6MSpFxCwFli
	/udsiHJBiR+T77GA2MwCWhKbtzWxQtjyEpvXvGWewCgwC0nZLCRls5CULWBkXsUoWlqcXFCc
	lJ5rqFecmFtcmpeul5yfu4kREkVFOxifbbA6xCjAwajEw1u5LyxEiDWxrLgy9xCjBAezkgjv
	/NXhIUK8KYmVValF+fFFpTmpxYcYmTg4pRoYDxr9ClHP4SxZPdXj3DUXYcGnmxi+nJ083ckn
	dFrFmn1VG+xPmDydN2GK7mXrYP2LPs/jTkx1mnx2zYGt8Sc7k9gmi95/mvhZ+fiPaUyv/t55
	zBxWVs3tLRzMHpizQnT7lbxPOvN2T1pzr2ytzhVl/YvSYprskb1vjkb3vimxmp2r5F9w85dM
	hBJLcUaioRZzUXEiAJuf4vOAAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 03 Nov 2014 21:54:53 +0100
Beniamino Galvani <b.galvani@gmail.com> escreveu:

> On Mon, Nov 03, 2014 at 11:14:10AM -0200, Mauro Carvalho Chehab wrote:
> > Em Sun, 12 Oct 2014 22:01:53 +0200
> > Beniamino Galvani <b.galvani@gmail.com> escreveu:
> > 
> > > Amlogic Meson SoCs include a infrared remote control receiver that can
> > > operate in two modes: in "NEC" mode the hardware can decode frames
> > > using the NEC IR protocol, while in "general" mode the receiver simply
> > > reports the duration of pulses and spaces for software decoding.
> > > 
> > > This is a driver for the IR receiver that uses software decoding of
> > > received frames.
> > 
> > There are a few checkpatch warnings there:
> > 
> > WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
> > #71: 
> > new file mode 100644
> > 
> > WARNING: Missing a blank line after declarations
> > #151: FILE: drivers/media/rc/meson-ir.c:76:
> > +	u32 duration;
> > +	DEFINE_IR_RAW_EVENT(rawir);
> 
> Here the macro is actually a variable definition and so it makes sense
> to group it with the other definitions without blank lines. I checked
> other rc drivers and many of them have a similar pattern. Could we
> consider the warning as a false positive?

Yes, this is a false positive.

> 
> > 
> > WARNING: DT compatible string "amlogic,meson6-ir" appears un-documented -- check ./Documentation/devicetree/bindings/
> > #272: FILE: drivers/media/rc/meson-ir.c:197:
> > +	{ .compatible = "amlogic,meson6-ir" },
> > 
> > total: 0 errors, 3 warnings, 238 lines checked
> > 
> > patches/lmml_26418_1_3_media_rc_add_driver_for_amlogic_meson_ir_remote_receiver.patch has style problems, please review.
> > 
> > I'm seeing that the DT patches are there, after this one. The best
> > would be to add them before in the series.
> > 
> > Please add also an entry at the MAINTAINERS file.
> 
> I'll reorder the patches and add the maintainer entry.

Ok, thanks!

> 
> > 
> > 
> > > 
> > > Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
> > > ---
> > >  drivers/media/rc/Kconfig    |  11 +++
> > >  drivers/media/rc/Makefile   |   1 +
> > >  drivers/media/rc/meson-ir.c | 214 ++++++++++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 226 insertions(+)
> > >  create mode 100644 drivers/media/rc/meson-ir.c
> > > 
> > > diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
> > > index 8ce0810..2d742e2 100644
> > > --- a/drivers/media/rc/Kconfig
> > > +++ b/drivers/media/rc/Kconfig
> > > @@ -223,6 +223,17 @@ config IR_FINTEK
> > >  	   To compile this driver as a module, choose M here: the
> > >  	   module will be called fintek-cir.
> > >  
> > > +config IR_MESON
> > > +	tristate "Amlogic Meson IR remote receiver"
> > > +	depends on RC_CORE
> > > +	depends on ARCH_MESON
> > 
> > Please add COMPILE_TEST too, as we want to be able to compile it on
> > x86 and other archs, in order to check if the driver builds fine and
> > to enable the static analyzers to look into this code.
> 
> Ok.
> 
> [...]
> 
> > > +
> > > +	ir->rc->priv = ir;
> > > +	ir->rc->input_name = DRIVER_NAME;
> > > +	ir->rc->input_phys = DRIVER_NAME "/input0";
> > > +	ir->rc->input_id.bustype = BUS_HOST;
> > 
> > > +	ir->rc->input_id.vendor = 0x0001;
> > > +	ir->rc->input_id.product = 0x0001;
> > > +	ir->rc->input_id.version = 0x0100;
> > 
> > I don't like very much the idea of filling it like that. From where those
> > numbers came? Could you add a define for them somewhere?
> 
> I've seen that other drivers as gpio-ir-recv and sunxi-cir assign
> those numbers to the fields of input_id but I couldn't find a
> documentation of the meaning. If the assignments are not needed I will
> drop them in the next version.
> 
> Beniamino
