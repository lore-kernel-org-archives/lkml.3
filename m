Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934657AbaFTPoD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:44:03 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:52387 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833AbaFTPoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:44:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Ulf Hansson <ulf.hansson@linaro.org>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Chris Ball <chris@printf.net>, Rob Herring <robh+dt@kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>, Olof Johansson <olof@lixom.net>,
        Chen-Yu Tsai <wens@csie.org>, Mark Brown <broonie@kernel.org>,
        Arend van Spriel <arend@broadcom.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [RFC 1/2] pwrseq: Add subsystem to handle complex power sequences
Date: Fri, 20 Jun 2014 17:42:19 +0200
Message-ID: <4224745.HqdT4QrZdr@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1403183091-27876-2-git-send-email-ulf.hansson@linaro.org>
References: <1403183091-27876-1-git-send-email-ulf.hansson@linaro.org> <1403183091-27876-2-git-send-email-ulf.hansson@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:gBnfVbgqCmDqlqIykdx3W6OUikH+QmS4N3sew0fW52r
 8YfUfeSC5blfr6vM4B9ERyHr3mMffD/q5xbkvmPRGbSN1KYReI
 ddefvjHuD8qIsXE/XkHetP3KGYwRljsPtAgHXxiCYd7OUW4oa/
 94mEbtjIKNWHLCkI6tFZccuqsbXWzx2ivozg3HAbyYUVTkjRDn
 mW6SuGzW25Q678E3JGY1SyUtU18Muf2Dy+QdAi/StrAyHR3iR7
 fLWaSCRFsipzBAfqBojIR6SadJfkdBpRweQJhD0feEI+JuyboH
 mSgTXWxf9BSvwcbj83YDxB/zS4qweB1H47rXmdkAvjtQeieIjQ
 zDzRhwAC6974eV5mgcMU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 June 2014 15:04:50 Ulf Hansson wrote:
> +Power sequence DT bindings
> +
> +Each power sequence method has a corresponding "power-method" property string.
> +This property shall be set in a subnode for a device. That subnode should also
> +describe resourses which are specific to that power method.
> +
> +Do note, power sequences as such isn't encoded through DT. Instead those are
> +implemented by each power method.
> +
> +Required subnode properties:
> +- power-method: should contain the string for the power method to bind.
> +
> +       Supported power methods: None.
> +
> +Example:
> +
> +Note, the "clock" power method in this example isn't actually supported, but
> +used to visualize how a childnode could be described.

I'm not too thrilled about adding another top-level concept for these.
This seems to duplicate some things that pm-domains do, but does them
in a somewhata different way. Would it be possible to instead integrate
it into the pm-domain code?

I also agree with Olof that having a standalone child device node is
not the best representation. If you want to represent an SDIO device
device that has some references to clocks, regulators, etc, then put
that device into the tree and give it those properties.
That would also let you worry about the sequencing in driver code rather
than trying to come up with a completely generic model for it.

	Arnd
