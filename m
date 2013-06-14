Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759528Ab3FNASX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 20:18:23 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:55982 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609Ab3FNASV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 20:18:21 -0400
X-AuditID: cbfee691-b7fef6d000002d62-6f-51ba614bd92c
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>
Cc: "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Simon Glass'" <sjg@chromium.org>,
        "'Luigi Semenzato'" <semenzato@chromium.org>,
        "'Ilho Lee'" <ilho215.lee@samsung.com>,
        =?UTF-8?B?J+q5gOydgOq4sCc=?= <eunki_kim@samsung.com>,
        linux-kernel@vger.kernel.org,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>
References: <1371058399-31933-1-git-send-email-dianders@chromium.org>
 <150901ce682e$1c3fca50$54bf5ef0$%kim@samsung.com>
 <CAD=FV=U9V-rgjcCusCvgw-SeUH-kDbozr_T-i1DcaXNXv48vxw@mail.gmail.com>
 <4661065.SXhmWQNl5M@flatron>
 <CAD=FV=Ukdpt4vMCZNySvKpHz6yGCP5X-LLAc1XdOAEAM8rr1fw@mail.gmail.com>
 <15e401ce688b$8fadadb0$af090910$%kim@samsung.com>
 <CAD=FV=WZQwA3UgYRGBQVHFs05JJzfmVfLyLXo7iQJYm=WmVQdw@mail.gmail.com>
In-reply-to: <CAD=FV=WZQwA3UgYRGBQVHFs05JJzfmVfLyLXo7iQJYm=WmVQdw@mail.gmail.com>
Subject: RE: [PATCH 3/3] pinctrl: exynos: ack level-triggered interrupts before
 unmasking
Date: Fri, 14 Jun 2013 09:18:18 +0900
Message-id: <15ee01ce6894$abecbb70$03c63250$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5okiB+33MaDfehTRGTaZWNvkpEkgAAbgkA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsVy+t8zA13vxF2BBl+WKVucXXaQzeLZnSvM
	Fkf/LWS0mPJnOZPF5V1z2CxmnN/HZHHq+mc2i89Xv7BYfNuyjdFi1a4/jA5cHrMbLrJ47Jx1
	l93jzrU9bB5XTjSxevRtWcXo8XmTXABbFJdNSmpOZllqkb5dAlfGm96XzAU/+CvW3TBpYFzJ
	08XIySEhYCLxcd1iVghbTOLCvfVsXYxcHEICyxglupt7mGGKnq54yQKRWMQo8fXdGUaQhJDA
	X0aJm9tlQGw2AQ2Jw++fsYPYIgLaEi8frGQGaWAWaGWW6Jp5ihmieyGzxNWl+9hAqjgFgiXO
	7j4LZgsLREvsmP6VCcRmEVCVuPdvP9hNvAK2Eqff32SCsAUlfky+xwJiMwuoS0yat4gZwtaW
	ePLuAlA9B9Cp6hKP/upCHGEkcefpLqgSEYl9L94xgtwgIdDLIfGmvRdql4DEt8mHWCB6ZSU2
	HYD6WFLi4IobLBMYJWYh2TwLyeZZSDbPQrJiASPLKkbR1ILkguKk9CJTveLE3OLSvHS95Pzc
	TYyQOJ+4g/H+AetDjMlA6ycyS4km5wPTRF5JvKGxmZGFqYmpsZG5pRlpwkrivOot1oFCAumJ
	JanZqakFqUXxRaU5qcWHGJk4OKUaGAO2KBneKlG4VWWWILZlybqa2yzigs/TIt+J9z3ePL3G
	e825NDZ2s7+vDKvrZkVNqRCacaFWlVVzv5rEiR97Ii8s+bj26erCO3ounNJVbvbOK11/p7S9
	6M5b/ptdIrXYuHLztOUzLhczOVTvn3ZwFl9W3I1ZV4xXvPEPnfnAdP3TwPmRcttPvlJiKc5I
	NNRiLipOBAA2G4jGCQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMKsWRmVeSWpSXmKPExsVy+t9jAV3vxF2BBqteylqcXXaQzeLZnSvM
	Fkf/LWS0mPJnOZPF5V1z2CxmnN/HZHHq+mc2i89Xv7BYfNuyjdFi1a4/jA5cHrMbLrJ47Jx1
	l93jzrU9bB5XTjSxevRtWcXo8XmTXABbVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGh
	rqGlhbmSQl5ibqqtkotPgK5bZg7QbUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqM
	DNBAwjrGjDe9L5kLfvBXrLth0sC4kqeLkZNDQsBE4umKlywQtpjEhXvr2boYuTiEBBYxSnx9
	d4YRJCEk8JdR4uZ2GRCbTUBD4vD7Z+wgtoiAtsTLByuZQRqYBVqZJbpmnmKG6F7ILHF16T42
	kCpOgWCJs7vPgtnCAtESO6Z/ZQKxWQRUJe79288KYvMK2Eqcfn+TCcIWlPgx+R7YScwC6hKT
	5i1ihrC1JZ68uwBUzwF0qrrEo7+6EEcYSdx5uguqRERi34t3jBMYhWYhmTQLyaRZSCbNQtKy
	gJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwEnkmvYNxVYPFIUYBDkYlHt6ECzsDhVgT
	y4orcw8xSnAwK4nwhv8FCvGmJFZWpRblxxeV5qQWH2JMBnp0IrOUaHI+MMHllcQbGpuYGVka
	mVkYmZibkyasJM57sNU6UEggPbEkNTs1tSC1CGYLEwenVAOjyV1h5llf/ZjOmd4SSNX167k9
	ce7HG78M9ylJbWhuFWQ+v+TG1Lg3HKEvL1TLn1BdyX9xM5dVpGDjoeINPXdn5meJb9tXbhjT
	J/9ux2n7qEoRwQ83YliYOvizmRbFKDzcfWbHJt/plyuc38nq3BBz2Zz18ovqa2Gtw4eNlE+V
	zWI/tUBpr+JCJZbijERDLeai4kQA/m8GfGYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug Anderson wrote:
> 
> Kukjin
> 
> <take 2, not in HTML mode>
> 
Oops, sorry.

> On Thu, Jun 13, 2013 at 4:13 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> > Doug Anderson wrote:
> >>
> >> Tomasz,
> >>
> >> On Thu, Jun 13, 2013 at 9:42 AM, Tomasz Figa <tomasz.figa@gmail.com>
> wrote:
> >> >> > BTW, probably we need a similar fixing in the mach-exynos/common.c
> >> >> > file
> >> >> > before pinct기 for distro...
> >> >>
> >> >> Is anyone using the functions in mach-exynos/common.c file anymore?
> I
> >> >> thought that non-dt exynos support was going away and then we could
> >> >> just delete a whole lot of code from that file.
> >> >
> >> > I think Kukjin meant stable kernels that support Exynos boards using
> >> board
> >> > files and without pinctrl. Would make sense to have them fixed as
> well,
> >> I
> >> > guess.
> >>
> > Yes, correct. Thanks, Tomasz.
> >
> >> Ah, makes sense.  Kukjin: do you know of someone who needs this
> >> (someone who is picking up linux-stable updates for exynos)?  I don't
> >> think it's important for ChromeOS for this particular patch.  If
> >> there's someone who needs this to officially land on linux-stable I'd
> >> be happy to review their backport of this patch.
> >>
> > As you know, developing something like Android, Tizen use the stable
> kernel (long-term? I'm not sure) and there was a problem about this issue.
> So I mean, would be fixed for the stable kernel.
> 
> Sure, but do they actually pull in from linux-stable periodically?
> I'd imagine that they have a private tree and that it would be their
> job to backport any fixes onto their kernel.

Right, the projects usually pull the linux-stable kernel when it starts. But as far as I know, they pick up some fixes from linux-stable during developing. Or for next project, would be better. I'm not sure what version will be used next time but it's obvious it will not be latest mainline :-)

Thanks,
- Kukjin

