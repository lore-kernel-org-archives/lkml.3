Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562AbaCQKsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 06:48:18 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37257 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932238AbaCQKsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 06:48:16 -0400
Date: Mon, 17 Mar 2014 10:48:04 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: boris brezillon <b.brezillon@overkiz.com>
Cc: Bo Shen <voice.shen@atmel.com>, Mark Brown <broonie@kernel.org>,
        "nicolas.ferre@atmel.com" <nicolas.ferre@atmel.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Mark Brown <broonie@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] ASoC: atmel: document clock properties of the
 wm8904 driver
Message-ID: <20140317104804.GE8070@e106331-lin.cambridge.arm.com>
References: <1395049541-28128-1-git-send-email-voice.shen@atmel.com>
 <1395049541-28128-8-git-send-email-voice.shen@atmel.com>
 <20140317100219.GB8070@e106331-lin.cambridge.arm.com>
 <5326CBE0.1000309@overkiz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5326CBE0.1000309@overkiz.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 10:18:08AM +0000, boris brezillon wrote:
> Hello Mark,
> 
> Le 17/03/2014 11:02, Mark Rutland a écrit :
> > On Mon, Mar 17, 2014 at 09:45:40AM +0000, Bo Shen wrote:
> >> From: Boris BREZILLON <b.brezillon@overkiz.com>
> >>
> >> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> >> Signed-off-by: Bo Shen <voice.shen@atmel.com>
> >> ---
> >>
> >>   Documentation/devicetree/bindings/sound/atmel-wm8904.txt | 2 ++
> >>   1 file changed, 2 insertions(+)
> >>
> >> diff --git a/Documentation/devicetree/bindings/sound/atmel-wm8904.txt b/Documentation/devicetree/bindings/sound/atmel-wm8904.txt
> >> index 8bbe50c..aca341c 100644
> >> --- a/Documentation/devicetree/bindings/sound/atmel-wm8904.txt
> >> +++ b/Documentation/devicetree/bindings/sound/atmel-wm8904.txt
> >> @@ -3,6 +3,8 @@ Atmel ASoC driver with wm8904 audio codec complex
> >>   Required properties:
> >>     - compatible: "atmel,asoc-wm8904"
> >>     - atmel,model: The user-visible name of this sound complex.
> >> +  - clocks: A list of clocks needed by the wm8904 chip.
> >> +  - clock-output-names: Driver related clock names. Shall contain "pck0".
> > The word "driver"  doesn't need to appear in biding documents, and this
> > fails to describe what it sets out to. How about the following:
> >
> > - clocks: a list of phandle + clock-specifier pairs, one for each entry
> >    in clock-names.
> Agreed.
> > - clock-names: Should contain "pck0"
> After thinking a bit more about it, this can be any programmable clk (pckX).

Huh?

The clock-names property describes the names of the inputs to the
device, from the view of the device, not the names of the clocks fed
into those inputs.

What are the names of the clock input lines on the wm8904?

Cheers,
Mark.
