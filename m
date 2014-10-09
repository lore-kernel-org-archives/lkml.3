Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121AbaJIK15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 06:27:57 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60178 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750942AbaJIK1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 06:27:49 -0400
Date: Thu, 9 Oct 2014 11:27:17 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Mark Brown <broonie@kernel.org>, Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/5] regulator: of: Add regulator-initial-mode parse
 support
Message-ID: <20141009102717.GG3869@leverpostej>
References: <1412775847-15213-1-git-send-email-javier.martinez@collabora.co.uk>
 <1412775847-15213-2-git-send-email-javier.martinez@collabora.co.uk>
 <20141008142511.GA4609@sirena.org.uk>
 <54354C7D.7090104@collabora.co.uk>
 <20141008151220.GE4609@sirena.org.uk>
 <54356666.4090003@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54356666.4090003@collabora.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 05:29:26PM +0100, Javier Martinez Canillas wrote:
> On 10/08/2014 05:12 PM, Mark Brown wrote:
> > On Wed, Oct 08, 2014 at 04:38:53PM +0200, Javier Martinez Canillas wrote:
> >> On 10/08/2014 04:25 PM, Mark Brown wrote:
> > 
> >> > That doesn't mean that the definition of those modes is something we can
> >> > sensibly provide in generic code, especially in a completely
> >> > undocumented fashion (perhaps you've done that later in the patch series
> >> > but bisection also applies to reviewability).
> > 
> >> As a general question, now that the convention is for DT binding docs to go
> >> in a separate patch, should the DT documentation be added before or after
> >> that code using these bindings is added?
> > 
> > It fairly obviously needs to go before so that reviewers can tell if the
> > code is actually implementing the binding.
> > 
> 
> Well, is not fairly obvious to me. One can also say the opposite, why the
> kernel is documenting a DT binding that is not (currently) implemented?

Checkpatch will complain regarding undocumented bindings, so from a
pragmatic point of view the binding must come first.

Personally, when I read a patch series I do an initial pass in-order,
and having the binding first makes things clearer. I might have some
questions regarding the binding that the driver answers later, and it makes it
easier to spot undocumented properties or conventions used by the
driver. Doing so the other way around usually leaves me with more
questions at the end.

> That's why what makes the most sense for me is what the old convention did,
> add the DT binding docs in the same patch that implements the binding.

Having a separate patch for the binding is very helpful for those of us
doing review. For one thing it helps us to find the binding document,
which can be important when a driver is thousands of lines long. For
another it means that we can be clear that our Acked-by, Reviewed-by,
etc apply to the binding and not necessarily the rest of the code.

For small patches, this is obviously less of a concern.

Thanks,
Mark.
