Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbaCJP3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 11:29:09 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:62989 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbaCJP3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 11:29:06 -0400
Date: Mon, 10 Mar 2014 08:28:59 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        kernel@stlinux.com, Giuseppe Condorelli <giuseppe.condorelli@st.com>
Subject: Re: [PATCH 1/5] drivers: input: keyboard: st-keyscan: add keyscan
 driver
Message-ID: <20140310152859.GA29054@core.coreip.homeip.net>
References: <1393990772-9567-1-git-send-email-gabriel.fernandez@st.com>
 <1393990772-9567-2-git-send-email-gabriel.fernandez@st.com>
 <20140310114819.GO14976@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140310114819.GO14976@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Mon, Mar 10, 2014 at 11:48:19AM +0000, Lee Jones wrote:
> Hi Gabi,
> 
> Sorry for the delay. It was a hectic week last week.
> 
> As promised:
> 
> > This patch adds ST Keyscan driver to use the keypad hw a subset
> > of ST boards provide. Specific board setup will be put in the
> > given dt.
> > 
> > Signed-off-by: Giuseppe Condorelli <giuseppe.condorelli@st.com>
> > Signed-off-by: Gabriel Fernandez <gabriel.fernandez@st.com>
> 
> Are you sure these are in the correct order?
> 
> What is the history of this commit?
> 
> > ---
> >  .../devicetree/bindings/input/st-keypad.txt        |  50 ++++
> 
> This should be submitted as a seperate patch.

Why do we have such requirement? To me it would make more sense to add
binding documentation in the same commit as the code that uses these
bindings.

[...]

> > +
> > +	error = matrix_keypad_parse_of_params(dev, &pdata->num_out_pads,
> > +			&pdata->num_in_pads);
> > +	if (error) {
> > +		dev_err(dev, "failed to parse keypad params\n");
> > +		return error;
> 
> Nit: It's pretty unusual to use this for a standard error handling
> variable. Consider 'ret' or 'err' as a replacement.

I like "error", in fact there are a lot of these in input. I use "error" for
data that is only returned from error path and "retval" when the same
variable is returned in both success and error paths.

> > +
> > +	input_dev->id.bustype = BUS_HOST;
> > +	input_dev->id.vendor = 0x0001;
> > +	input_dev->id.product = 0x0001;
> > +	input_dev->id.version = 0x0100;
> 
> Any chance we can #define these?

Even better would be not use 0x0001 as vendor as there (unfortunately)
quite a few other drivers use it already. Either omit or chose something
else. Does ST have PCI or USB VID assigned?

Thanks.

-- 
Dmitry
