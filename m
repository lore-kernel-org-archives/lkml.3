Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab3JDNUD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 09:20:03 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48389 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753983Ab3JDNUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 09:20:01 -0400
Date: Fri, 4 Oct 2013 14:19:56 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Daniel Mack <zonque@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] input: rotary-encoder: Add 'on-each-step' to
 binding documentation
Message-ID: <20131004131956.GE6999@e106331-lin.cambridge.arm.com>
References: <1380891203-17617-1-git-send-email-ezequiel@vanguardiasur.com.ar>
 <1380891203-17617-3-git-send-email-ezequiel@vanguardiasur.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380891203-17617-3-git-send-email-ezequiel@vanguardiasur.com.ar>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 01:53:23PM +0100, Ezequiel Garcia wrote:
> The driver now supports a new mode to handle the interruptions generated
> by the device: on this new mode an input event is generated on each step
> (i.e. on each IRQ). Therefore, add a new DT property, to select the
> mode: 'rotary-encoder,on-each-step'.
> 
> Cc: Daniel Mack <zonque@gmail.com>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
> ---
> I'm not at all happy with this DT binding as it's way to customized
> for the current driver. For instance, if we want to support mapping
> key events (or better arbitrary linux-input event types) it seems
> there's no easy way to fix the binding.
> 
> Maybe a better way of handling the different 'modes' is through
> compatible strings?

I'd prefer not to have more pseudo-devices in DT, and would prefer not
to have compatible strings that boil down to driver options. We end up
just embedding a tonne of Linux-specific driver configuration in the DT
rather than describing hardware.

That said, I'm not sure what the best solution is here.

> 
> I'm not really sure, so I hope the DT guys have some comment on this.
> 
>  Documentation/devicetree/bindings/input/rotary-encoder.txt | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/input/rotary-encoder.txt b/Documentation/devicetree/bindings/input/rotary-encoder.txt
> index 3315495..b89e38d 100644
> --- a/Documentation/devicetree/bindings/input/rotary-encoder.txt
> +++ b/Documentation/devicetree/bindings/input/rotary-encoder.txt
> @@ -15,6 +15,7 @@ Optional properties:
>  - rotary-encoder,rollover: Automatic rollove when the rotary value becomes
>    greater than the specified steps or smaller than 0. For absolute axis only.
>  - rotary-encoder,half-period: Makes the driver work on half-period mode.
> +- rotary-encoder,on-each-step: Makes the driver send an event on each step.

Could this not be something requested at runtime?

Could you explain what you want to achieve with this? -- what events do
you want to occur when, to be handled in what way?

Cheers,
Mark.
