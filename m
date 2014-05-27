Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbaE0G5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 02:57:25 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:10339 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbaE0G5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 02:57:20 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-47-5384374c5a89
Message-id: <1401173838.8073.4.camel@AMDC1943>
Subject: Re: [PATCH 1/3] regulator: s2mps11: Refactor setting ramp delay
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Yadwinder Singh Brar <yadi.brar01@gmail.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Sangbeom Kim <sbkim73@samsung.com>, Lee Jones <lee.jones@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        devicetree <devicetree@vger.kernel.org>
Date: Tue, 27 May 2014 08:57:18 +0200
In-reply-to: <CAKew6eV63jkFtpeaHGj4c5fUq0jZYFNzvf_W-fOrtJ5opnadyg@mail.gmail.com>
References: <1401110423-5647-1-git-send-email-k.kozlowski@samsung.com>
 <1401110423-5647-2-git-send-email-k.kozlowski@samsung.com>
 <CAKew6eV63jkFtpeaHGj4c5fUq0jZYFNzvf_W-fOrtJ5opnadyg@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu1
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t/xK7o+5i3BBrcfKFpsnLGe1WLqwyds
	FvOPnGO1ONv0ht3i/tejjBbfrnQwWVzeNYfNYsb5fUwWa4/cZbc4+aeX0eLiii9MFutnvGax
	mPu7kdWB12PnrLvsHptWdbJ53Lm2h82jb8sqRo/Pm+QCWKO4bFJSczLLUov07RK4Mp6tn8Vc
	sEysYt+2xewNjBP5uxg5OSQETCTezbnABmGLSVy4tx7I5uIQEljKKLF50kJWCOczo8S7A4dZ
	Qap4BfQkHnQ+ZAexhQU8JJadeM8CYrMJGEtsXr4EbJKIgIHExCXzwJqZBZpZJL4uaGEESbAI
	qEr8v7WdCcTmFAiW+HdvDtggIYFTjBKLfumA2MwC6hKT5i1ihjhJWWLe/mNMEIsFJX5MvscC
	USMvsXnNW+YJjAKzkLTMQlI2C0nZAkbmVYyiqaXJBcVJ6bmGesWJucWleel6yfm5mxghUfJl
	B+PiY1aHGAU4GJV4eC0eNgcLsSaWFVfmHmKU4GBWEuGNZWoJFuJNSaysSi3Kjy8qzUktPsTI
	xMEp1cBolXfkUD1L++2yLT/ZM3TTLb/xCL+1ObTnShqHV2dXbrvpKs4lf+KaGLPOfDu4N3bn
	in9q8j7l3henv5p8NuR08af73P3zwprdorZcqq2o/XRcmOvu/F2p62QNs+axaqnd2Oy9/2HD
	ArvLer68tguUfW8pij4OPlb+KSecX1Q3Rjt6lyWH7UclluKMREMt5qLiRAC6m9+LcAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2014-05-27 at 11:56 +0530, Yadwinder Singh Brar wrote:
> Hi Krzysztof,
> 
> 
> On Mon, May 26, 2014 at 6:50 PM, Krzysztof Kozlowski
> <k.kozlowski@samsung.com> wrote:
> > Prepare for merging the s2mpa01 regulator driver into s2mps11 by:
> > 1. Adding common id for buck regulators.
> > 2. Splitting shared ramp delay settings to match S2MPA01.
> > 3. Adding a configuration of registers for setting ramp delay for each
> >    buck regulator.
> >
> > The functionality of the driver should not change as this patch only
> > prepares for supporting S2MPA01 device.
> >
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  drivers/regulator/s2mps11.c | 210 ++++++++++++++++++++++++++++++--------------
> >  1 file changed, 144 insertions(+), 66 deletions(-)
> >
> 
> [snip]
> 
> >
> > -               if (ramp_delay > s2mps11->ramp_delay34)
> > -                       s2mps11->ramp_delay34 = ramp_delay;
> > +               if (ramp_delay > s2mps11->ramp_delay3)
> > +                       s2mps11->ramp_delay3 = ramp_delay;
> >                 else
> > -                       ramp_delay = s2mps11->ramp_delay34;
> > -
> > -               ramp_shift = S2MPS11_BUCK34_RAMP_SHIFT;
> > -               ramp_reg = S2MPS11_REG_RAMP;
> > +                       ramp_delay = s2mps11->ramp_delay3;
> >                 break;
> >         case S2MPS11_BUCK4:
> > -               enable_shift = S2MPS11_BUCK4_RAMP_EN_SHIFT;
> >                 if (!ramp_delay) {
> >                         ramp_enable = 0;
> >                         break;
> >                 }
> >
> > -               if (ramp_delay > s2mps11->ramp_delay34)
> > -                       s2mps11->ramp_delay34 = ramp_delay;
> > +               if (ramp_delay > s2mps11->ramp_delay4)
> > +                       s2mps11->ramp_delay4 = ramp_delay;
> >                 else
> > -                       ramp_delay = s2mps11->ramp_delay34;
> > -
> > -               ramp_shift = S2MPS11_BUCK34_RAMP_SHIFT;
> > -               ramp_reg = S2MPS11_REG_RAMP;
> > +                       ramp_delay = s2mps11->ramp_delay4;
> 
> Main rationale behind shared value is completely omitted here, in
> other cases also,
> after just giving a NOTE in documentation asking user to make sure to
> pass same value.
> It doesn't seem safe, simply leaving a scope of stability issue (in
> case ramp_delay3 > ramp_delay4).

The documentation already states that these bucks (e.g. 3 and 4) share
the ramp delay setting and 'regulator-ramp-delay' should be the same.
However you're right that patch is not safe against changing shared ramp
delays to different values. Previously the code was safe so this is not
entirely "non-functional" change. I'll fix it to retain the same
behavior.

Best regards,
Krzysztof



