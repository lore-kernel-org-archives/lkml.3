Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab3KSPoB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 10:44:01 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:52316 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751307Ab3KSPn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 10:43:59 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/E7WN56PuqUDR8f9DvynFF
Date: Tue, 19 Nov 2013 07:43:53 -0800
From: Tony Lindgren <tony@atomide.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Linux-OMAP <linux-omap@vger.kernel.org>, linaro-networking@linaro.org,
        Victor Kamensky <victor.kamensky@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 01/23] gpio/omap: raw read and write endian fix
Message-ID: <20131119154353.GC10317@atomide.com>
References: <1384560086-11994-1-git-send-email-taras.kondratiuk@linaro.org>
 <1384560086-11994-2-git-send-email-taras.kondratiuk@linaro.org>
 <CACRpkdYD-Yw+RFnX0GshyQn2oHYNnXXRF4RXTzCox=2Z0_gKqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYD-Yw+RFnX0GshyQn2oHYNnXXRF4RXTzCox=2Z0_gKqg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Walleij <linus.walleij@linaro.org> [131119 01:29]:
> On Sat, Nov 16, 2013 at 1:01 AM, Taras Kondratiuk
> <taras.kondratiuk@linaro.org> wrote:
> 
> > From: Victor Kamensky <victor.kamensky@linaro.org>
> >
> > All OMAP IP blocks expect LE data, but CPU may operate in BE mode.
> > Need to use endian neutral functions to read/write h/w registers.
> > I.e instead of __raw_read[lw] and __raw_write[lw] functions code
> > need to use read[lw]_relaxed and write[lw]_relaxed functions.
> > If the first simply reads/writes register, the second will byteswap
> > it if host operates in BE mode.
> >
> > Changes are trivial sed like replacement of __raw_xxx functions
> > with xxx_relaxed variant.
> >
> > Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
> > Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
> 
> Since I generally just dislike __raw accessors I went and applied
> this. If it collides with any of Tony's fixup work I might need to
> take the patch out again, no big deal.

Thanks, this should not conflict with what I have. I just had few
fixes for the twl4030-gpio for older omaps and I doubt that I have
further driver dependencies beyond that for my clean-up work.
 
> Some ACKs would be nice, but unless there are major objections
> this stays merged.

Acked-by: Tony Lindgren <tony@atomide.com>
