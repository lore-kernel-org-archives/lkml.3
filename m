Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965779Ab3FTTCm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 15:02:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:65517 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965763Ab3FTTCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 15:02:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Subject: Re: [PATCH v3 02/10] clocksource:arm_global_timer: Add ARM global timer support.
Date: Thu, 20 Jun 2013 21:02:30 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stuart Menefy <stuart.menefy@st.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        kernel@stlinux.com, linux-serial@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Rob Herring <robherring2@gmail.com>, Will Deacon <will.deacon@arm.com>
References: <1371736996-8770-1-git-send-email-srinivas.kandagatla@st.com> <1371737121-9295-1-git-send-email-srinivas.kandagatla@st.com>
In-Reply-To: <1371737121-9295-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201306202102.30478.arnd@arndb.de>
X-Provags-ID: V02:K0:XDy67PAFShOsfFv1ixySDfGWeYOh6cLUmb9bTOYGqQg
 rVK6+R40WzU/0X3ZCmSKvm0gd/15wzt5SytYsaZfYQhmMSe7RZ
 I5BxGZpiGR1Gd1pziQh0108Xf2kaxPGyLcasfn1OCLCqlatCGa
 OafzX6sHZAOT9SOTWINZcKMTiwyTc3Up0dQcUh5PHEFoztTm5N
 aDfKX2C0tKKJzQBfenKZFLJWItM+UvVbYQ6um26jLjLqoOxNOA
 m5JGo2JT1BAscvNCE76CjcRSaY6UzL+goecBEZtbVvGC5sT+AA
 tE/wN8ler5unGBvbxAfYcQWZYA8Ej8lSqvi9sIwqp7pj5isY53
 dkmiQ9PicW7ga0ZP4VZI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 June 2013, Srinivas KANDAGATLA wrote:
> +static u64 gt_counter_read(void)
> +{
> +       u64 counter;
> +       u32 lower;
> +       u32 upper, old_upper;
> +
> +       upper = __raw_readl(gt_base + GT_COUNTER1);
> +       do {
> +               old_upper = upper;
> +               lower = __raw_readl(gt_base + GT_COUNTER0);
> +               upper = __raw_readl(gt_base + GT_COUNTER1);
> +       } while (upper != old_upper);
> +
> +       counter = upper;
> +       counter <<= 32;
> +       counter |= lower;
> +       return counter;
> +}

Please replace __raw_readl etc with the non-__raw variants
throughout the code.

The __raw accessors are not endian safe and are not meant
for device drivers. If you are worried about latency from
extra barriers, use readl_relaxed().

	Arnd
