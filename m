Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606Ab3EHRr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 13:47:26 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:44384 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757059Ab3EHRrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 13:47:25 -0400
Message-ID: <518A8E6C.6070907@st.com>
Date: Wed, 08 May 2013 18:42:04 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, dong.aisheng@linaro.org,
        sameo@linux.intel.com, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Stuart Menefy <stuart.menefy@st.com>,
        Shawn Guo <shawn.guo@linaro.org>, Olof Johansson <olof@lixom.net>,
        Jason Cooper <jason@lakedaemon.net>,
        Stephen Warren <swarren@nvidia.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Dave Martin <dave.martin@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org
Subject: Re: [RFC 3/8] mfd:syscon: Introduce claim/read/write/release APIs
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com> <1368022272-2241-1-git-send-email-srinivas.kandagatla@st.com> <201305081650.23264.arnd@arndb.de> <20130508150141.GA5057@opensource.wolfsonmicro.com>
In-Reply-To: <20130508150141.GA5057@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thankyou for the comments.
On 08/05/13 16:01, Mark Brown wrote:
> On Wed, May 08, 2013 at 04:50:22PM +0200, Arnd Bergmann wrote:
>
>>> In many cases a single syconf register contains bits related to multiple
>>> devices, and therefore it need to be shared across multiple drivers at
>>> bit level. The same IP block can have different syscon mappings on
>>> different SOCs.
>> My feeling is that syscon is the wrong place for this functionality,
>> since regmap already handles (some of?) these issues. If you need
>> additional synchronization, it's probably best to extend regmap
>> as needed so other code besides syscon can take advantage of that
>> as well.
> This sounds like regmap_update_bits() ought to be all that's needed.

Ultimately the syscon_write use the regmap_update_bits, however we really want is the flexibility in using/referring the syscon registers/bits in both device-trees and non-device tree cases.

The reason for these APIs, is the extent of syscon usage is very high in ST set-top-box parts.

Without these new APIs, its very difficult to pass this information to
the drivers.

Thanks,
srini
