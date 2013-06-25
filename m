Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711Ab3FYO1j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 10:27:39 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:50769 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab3FYO1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 10:27:38 -0400
MIME-Version: 1.0
In-Reply-To: <51C4C2ED.5090505@wwwdotorg.org>
References: <CACRpkdY9F0cUaRfGJnHJW=2dYf_yKkr3M8Kh+_e6XQhh1WBoUA@mail.gmail.com>
	<1371128132-18266-2-git-send-email-christian.ruppert@abilis.com>
	<51BA3BC1.3090109@wwwdotorg.org>
	<20130614091241.GA23745@ab42.lan>
	<51C1F42E.5090107@wwwdotorg.org>
	<51C1F82C.4020502@wwwdotorg.org>
	<20130620115710.GB942@ab42.lan>
	<51C4C2ED.5090505@wwwdotorg.org>
Date: Tue, 25 Jun 2013 16:27:37 +0200
Message-ID: <CACRpkdbnXmJnPd6akeEVuU9dwAe+FOvm6boDt8=zjG_D3ZLTGg@mail.gmail.com>
Subject: Re: [PATCH 2/2] Make non-linear GPIO ranges accesible from gpiolib
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Christian Ruppert <christian.ruppert@abilis.com>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 11:17 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> When I pushed for the concept of groups, I intended it to mean precisely
> one single thing. The points below describe this.
>
> 1) A pin is a single pin/ball/pad on the package.
>
> 2) Some register fields affect just a single pin. For example, there may
> be a register field that affects pin A8's mux setting only.
>
> 3) Some register fields affect multiple pins at once. For example,
> perhaps one register field affects both pin A8's an pin A7's mux setting
> at once.
>
> 4) Depending on HW design, all register fields might be of type
> described at (2) above, or all of the type described at (3) above, or a
> mixture of both. Tegra is a mixture.
>
> 5) I expect the concept of a pin group to solely represent the various
> groups of pins affected by each register field; in (2) above one pin per
> group, in (3) above many pins per group.
>
> Thus, to my mind, a pin group is purely a HW concept, and dictated
> purely by HW design.

This we can discuss perpetually it seems.

For Nomadik, as I've pointed out in the past it is actually:

(6): it is one register/set if bits per pin, BUT the register settings
 pertain to physical lines having electrical settings which postulate
 that they be handled in batch or wreak havoc.

I.e. it is a HW limitation in the *silicon* of *all* implementations,
but that is *not* expressed in the register map.

For the practical consequences see __nmk_config_pins if (glitch)
runpath. Handling this as a group makes perfect sense from
a hardware point of view.

Yours,
Linus Walleij
