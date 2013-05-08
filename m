Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab3EHOup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 10:50:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53825 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957Ab3EHOul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 10:50:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Subject: Re: [RFC 3/8] mfd:syscon: Introduce claim/read/write/release APIs
Date: Wed, 8 May 2013 16:50:22 +0200
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
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com> <1368022272-2241-1-git-send-email-srinivas.kandagatla@st.com>
In-Reply-To: <1368022272-2241-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201305081650.23264.arnd@arndb.de>
X-Provags-ID: V02:K0:oEplqTzYYvh2x+KpZlAsB0lVx/73Nxrew73+lFOdoBn
 4hVCUbsETb3E7lPjNaAiWMsFUFmU6cgDCvmg8nRR5Lk1aF5wuG
 R6Urzn6z5aQC5UI+TLaPd58SMpxivYg46yv130mCmIsee8lmk0
 oa/Rq5aQAzUIomf9z/gPykStP2dT1CtcM31NF70O+6S95diG1F
 poiK9MfJnB5wW/gx0Oes5+C6lnT1r9ZpdD0fRmFDlVJplwRCQl
 iTqQq6NSpSyq0kSy6yivwAKPiAi24s4aNPJGkyNGFKY8KZYA+4
 6Qy3mXPf43D2GbfeJL2gAu+EC7ghDVp37XAyMBO8pjAYUeRW99
 nm4LFTgUsuanosWGX1p4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 May 2013, Srinivas KANDAGATLA wrote:
> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> 
> This patch introduces syscon_claim, syscon_read, syscon_write,
> syscon_release APIs to help drivers to use syscon registers in much more
> flexible way.
> 
> With this patch, a driver can claim few/all bits in the syscon registers
> and do read/write and then release them when its totally finished with
> them, in the mean time if another driver requests same bits or registers
> the API will detect conflit and return error to the second request.
> 
> Reason to introduce this API.
> System configuration/control registers are very basic configuration
> registers arranged in groups across ST Settop Box parts. These registers
> are independent of IP itself. Many IPs, clock, pad and other functions
> are wired up to these registers.
> 
> In many cases a single syconf register contains bits related to multiple
> devices, and therefore it need to be shared across multiple drivers at
> bit level. The same IP block can have different syscon mappings on
> different SOCs.
> 
> Typically in a SOC there will be more than hundreds of these registers,
> which are again divided into groups.
> 
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> CC: Stuart Menefy <stuart.menefy@st.com>

My feeling is that syscon is the wrong place for this functionality,
since regmap already handles (some of?) these issues. If you need
additional synchronization, it's probably best to extend regmap
as needed so other code besides syscon can take advantage of that
as well.

	Arnd
