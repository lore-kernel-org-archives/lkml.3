Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab3LERDO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:03:14 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:41254 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab3LERDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:03:12 -0500
X-AuditID: cbfec7f4-b7f966d0000003d9-c5-52a0b1ce1aa5
From: Tomasz Figa <t.figa@samsung.com>
To: Kevin Bracey <kevin@bracey.fi>
Cc: Mark Brown <broonie@kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
        Kyungmin Park <kmpark@infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Doug Anderson <dianders@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] pinctrl: samsung: Allow pin value to be initialized using
 pinfunc.
Date: Thu, 05 Dec 2013 18:03:02 +0100
Message-id: <1475204.PCyxT0KMui@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.3 (Linux/3.11.5-gentoo; KDE/4.11.3; x86_64; ; )
In-reply-to: <52A0AEB4.7090909@bracey.fi>
References: <1384881351-10782-1-git-send-email-t.figa@samsung.com>
 <1502243.eRBlCfUhTO@amdc1227> <52A0AEB4.7090909@bracey.fi>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42I5/e/4Vd1zGxcEGazsU7KY+vAJm8X8I+dY
	Lc4uO8hm8f/Ra1aL0yv2slr0LrjKZnHr8ioWiyl/ljNZbHp8jdXi8q45bBYzzu9jslh75C67
	xauDbSwWx2YsYXTg8/h/tY3RY3bDRRaPzSu0PDat6mTzuHNtD5vH5iX1Hn1bVjF6bL82j9nj
	8yY5j41zQwO4orhsUlJzMstSi/TtErgyXrc9Yyl4zVPRdHIKcwNjO1cXIyeHhICJxIZfx1gg
	bDGJC/fWs3UxcnEICSxllPg57QuU08UkMenYSXaQKjYBNYnPDY/YQGwRASWJLwvXsoMUMQu0
	s0ps298DlhAWiJR4taOVFcRmEVCVePR4IzOIzSugKfFp8Uwwm19AXeLdtqdMILaogJvEi31b
	wBZwAtVcX70UrEZIoF7i3K9pbBC9ghI/Jt8DO5VZQF5i3/6prBC2lsT6nceZJjAKzkJSNgtJ
	2SwkZQsYmVcxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn525ihMTclx2Mi49ZHWIU4GBU4uFNWLMg
	SIg1say4MvcQowQHs5II7/m1QCHelMTKqtSi/Pii0pzU4kOMTBycUg2MqTdylaq2r9C+GnZb
	Qeyfs3tDnfMF+zPxQZsfPqrfZX/tXq1R/vdkl21OUsWyFoctdvz3PHbitJPLioKgE0W9FzeF
	3fF+Nl/t9UT9wLmnOX0O8FdOrLRRap0kOMdlU9a9G+3XYm/LdIa4zKwWW8x5vfVt+LaegP9T
	km/NNJDinW+mYPLz03ZuJZbijERDLeai4kQALhR2/JcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 of December 2013 18:49:56 Kevin Bracey wrote:
> On 05/12/2013 17:11, Tomasz Figa wrote:
> > On Thursday 05 of December 2013 15:07:47 Mark Brown wrote:
> >> On Tue, Dec 03, 2013 at 10:29:42AM +0100, Linus Walleij wrote:
> >>
> >>> So a suggested patch to support weak hogs would be interesting
> >>> to look at. Can you provide details on how you think this would
> >>> work?
> >> Or should we be going and applying the default state to all devices on
> >> init without worrying about a driver appearing?
> > If a device isn't used, then it's often better to configure the pins for
> > a different function, such as GPIO, to minimize leakage current.
> >
> 
> And there can also be mutually-exclusive drivers choosing different 
> default states for the same pin. I think you do need a separate "safe" 
> indicator.

That's not quite true, as on a single board you should rather have
a single device node with "okay" status referencing given set of pins.
Still, I think that a separate safe state is the way to go.

> 
> My current thought is that  a late-init "make safe all unclaimed pins" 
> pass would make sense - you can't really mess with pins in an automated 
> fashion on init, as it can mess up bootloader->driver handover.   There 
> already exist late-init "turn off all unclaimed clocks" (at least on 
> shmobile)

That's a feature of Common Clock Framework.

> and "turn off all unclaimed regulators", and it would fit that 
> model.

Maybe that's the way to do it. I need to think a bit more on this,
especially considering our (Samsung's) use cases.

Best regards,
Tomasz

