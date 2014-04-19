Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637AbaDSL7r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 07:59:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.131]:58652 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaDSL7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 07:59:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Mack <daniel@zonque.org>
Subject: Re: [PATCH v4 00/21] ARM: support for ICP DAS LP-8x4x (with dts)
Date: Sat, 19 Apr 2014 13:59:35 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Sergei Ianovich <ynvich@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        "laurent.pinchart" <laurent.pinchart@ideasonboard.com>,
        kernel@pengutronix.de
References: <1387309071-22382-1-git-send-email-ynvich@gmail.com> <1397736755.16539.15.camel@host5.omatika.ru> <534FCA5D.1020606@zonque.org>
In-Reply-To: <534FCA5D.1020606@zonque.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201404191359.36203.arnd@arndb.de>
X-Provags-ID: V02:K0:4KSBmpMvIZO4tz+Zag5PcCEccdv3UpJp59dvR8qT5lM
 MLosfDYbG0ZYxvzYqiqZmhzeZ4lskaQYH79F6nQtXbZIdcCr/c
 HxvCoLW+cAh4TNrnqgIWyinETJ08BPcawcyaO8mXA2/hNLOygL
 Vvw+gPXII1lSYvaRxHdXk1PpYP4bN/6alaWjOskOw3dnmQMKVA
 s3LxmY9LJMExc7bQzrnihbOIQfR1yZzdzuFf1mieQ+2z3y710k
 /odM+dTdHKM+0WnhRnNRHFecHZcNU8VY/0GNh6IS46zN0gMo8v
 24sv8D6GGuO2g51nVLrbYzxyH4S+8xfzeIxE8ozJ5+mfpuTJ/Z
 H8peECZTuI5y/gfPn0Kdk7n8x9tbGkozEjjkViPvi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 April 2014, Daniel Mack wrote:
> On 04/17/2014 02:12 PM, Sergei Ianovich wrote:
> > On Thu, 2014-04-17 at 12:38 +0200, Daniel Mack wrote
> > I have all the
> > reasons to believe, that LP-8x4x support would already have be merged,
> > if I didn't try to use DT.
> 
> That might be, but that's not the point. We want progress here, and that
> means we occasionally have to get rid of legacy.

In most cases, I would strongly support that statement. However, for PXA
in particular, my opinion is that progress is not the highest priority
as I see no realistic hope of converting all the existing machines over
to use DT and change the platform to "multiplatform" support. Anything
more modern than PXA I hope we can eventually get at least done for
multiplatform, same for a few of the older and simpler platforms.

Then again, I'm certainly not stopping you from trying to use add
modern platforms to PXA.

One of the ideas I had earlier was to extend mach-mmp enough to
run any fully DT-enabled PXA machines and leave mach-pxa for the
old ATAGS support and stuff like the legacy DMA support.
However, I don't think we should try that as long as mach-mmp is
lacking some essential DT support, e.g. for the clocks that were
only partially converted to use the common clock framework.

> > if so
> > B. We need to thinks whether it's acceptable to kill support for video
> > capture.
> 
> We can't. As I said, for this particular driver, we can keep the old API
> around. We can even make it depend on !CONFIG_DMA_ENGINE, so if anyone
> actually wants to use it with DT-enabled boards, we finally have a user
> and things can be fixed up. Similar for other drivers we can't test
> ourselves.

Sounds good to me.

> > In short:
> > 
> > if (A && B)
> >   we drop old DMA
> > else
> >   we take my patch #7
> 
> If A works, there's no need to for patch #7, right? If A doesn't work,
> we have to check why and fix it.
> 
> Arnd, any oppinion on this?

No strong opinion, I wouldn't object patch #7 if there is a strong reason
to not use the dmaengine driver for PXA like I would object doing it for
MMP. Then again, I see that you and recently also Laurent are driving a
lot of good work on PXA, and if neither the arm-soc maintainers nor the
three maintainers listed for mach-pxa have a strong opinion, I'd rather
leave it up to your judgement.

	Arnd
