Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab3EHTsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 15:48:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62290 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab3EHTse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 15:48:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: srinivas.kandagatla@st.com
Subject: Re: [RFC 3/8] mfd:syscon: Introduce claim/read/write/release APIs
Date: Wed, 8 May 2013 21:48:10 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: dong.aisheng@linaro.org, sameo@linux.intel.com,
        Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Stuart Menefy <stuart.menefy@st.com>,
        Shawn Guo <shawn.guo@linaro.org>, Olof Johansson <olof@lixom.net>,
        Jason Cooper <jason@lakedaemon.net>,
        Stephen Warren <swarren@nvidia.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Dave Martin <dave.martin@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com> <201305081650.23264.arnd@arndb.de> <518A8C1D.3090600@st.com>
In-Reply-To: <518A8C1D.3090600@st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201305082148.10933.arnd@arndb.de>
X-Provags-ID: V02:K0:g8WINxm89xGqgFQiyf2Olm68b44TMxp7scISWosllyN
 q99vyr3n6Wc704bjtfWlkyjv9FLsUSJSWzpv8uX+uVoSdXY8xz
 DG/vV0tufdlucnrtxLBOCsrcO+XLh7qM7cDMkEbGjZ8DeOSuWT
 Oa+xLerOiAjX4PE2T0ud031+Rpy2zGg5PllqfULZp+vaNmZmmw
 gxwqH6bZRWnFJ5nRrQPpu8Izvigh/tPnuuS9b0GC/UDVaaLuJm
 xzOV9rPL/PMmcYFqwMJFfvZEhsdZ5RcriUWQHeM2rAOSa9bHvJ
 1y99TvkfdD4o3Ug7815adpfbqF+F14l+ehuEUTs5qu/30gnLaj
 HArHcKiIuTFs4OSzSdDI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 May 2013, Srinivas KANDAGATLA wrote:
> the pinctrl driver calls syconf_claim(np, "st,alt-control) to get a
> field and then do a read/write on the field.
> 
> Just in pinctrl driver we use around 50-100 sysconf registers scatters
> across different groups.
> 
> Without these new APIs, its very difficult to pass this information to
> the drivers.

But are those necessarily things you would configure using DT?

If there are so many registers that are shared between mutliple
subsystems, maybe using drivers/mfd/syscon for that is taking things
further than you should, since it is unlike what any of the other
SoC families need from syscon.

Can you describe how your syscon registers are laid out?
Which subsystems beside pinctrl need to directly interact
with it? Is there any logical structure in it or do you just
have tons of bits scattered around an MMIO area?

	Arnd
