Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751213AbaLPNam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 08:30:42 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50435 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaLPNal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 08:30:41 -0500
Message-ID: <1418736635.3374.64.camel@pengutronix.de>
Subject: Re: i.MX6 CSC and scaler
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Cc: Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Sureau 
	<frederic.sureau@vodalys.com>,
        Fabio Estevam <fabio.estevam@freescale.com>
Date: Tue, 16 Dec 2014 14:30:35 +0100
In-Reply-To: <CAL8zT=jNis3VN11xN82fci5dA5f0TwAAhkBVq2+5TaKpmm_S-Q@mail.gmail.com>
References: <CAL8zT=hAVi2-io3POmj9Lp1AF11ovg6bqCMPRp_w_QySAgFGtw@mail.gmail.com>
	 <548F272E.3040808@gmail.com> <548F2DD6.70805@collabora.com>
	 <CAL8zT=jNis3VN11xN82fci5dA5f0TwAAhkBVq2+5TaKpmm_S-Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 15.12.2014, 22:27 +0100 schrieb Jean-Michel Hautbois:
> 2014-12-15 19:52 GMT+01:00 Nicolas Dufresne <nicolas.dufresne@collabora.com>:
> > Le 12/15/2014 01:23 PM, Steve Longerbeam a écrit :
> >> You would need to write a gstreamer plugin to make use of the
> >> mem2mem device for h/w CSC and scaling.
> 
> Thank you Steve, this is of a great help !
> 
> > There is an element already (v4l2transform), though it currently only
> > handle color conversion. I'd like to see scaling in that too instead of
> > having a separate element that only do scaling like:
> >
> > https://bugzilla.gnome.org/show_bug.cgi?id=726104
> 
> Nice idea. You are probably right Nicolas, it would make sense to be
> able to scale and convert color in the same element.
>
> > I think Michael and Philipp idea was that scaling could be done directly
> > out of the decoder, something supported by CODA driver. There is some
> > work require to get that in GStreamer, see:
> >
> > https://bugzilla.gnome.org/show_bug.cgi?id=733827 (pixel format nego)
> > https://bugzilla.gnome.org/show_bug.cgi?id=733828 (display size nego)
> 
> There is a need for a separate element too. So it could be handled in
> front of the encoder if needed, on decoder output if needed, but
> should be a single element too, instanciable multiple times if
> multiple inputs/outputs are needed.

Scaling in the decoder element is desirable, but unrelated. I wanted
that for the CODA JPEG decoder, which can produce decimated output right
during the decoding process.

For the IPU IC mem2mem scaler/CSC, v4l2transform with scaling capability
would be the perfect fit.

regards
Philipp

