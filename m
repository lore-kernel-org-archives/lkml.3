Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372Ab3LJAZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 19:25:42 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:54318 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab3LJAZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 19:25:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sergei Ianovich <ynvich@gmail.com>
Subject: Re: [PATCH 5/9] ARM: dts: provide DMA config to pxamci
Date: Tue, 10 Dec 2013 01:25:18 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Daniel Mack <zonque@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Chris Ball <cjb@laptop.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        DOCUMENTATION <linux-doc@vger.kernel.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>
References: <1386348542-9584-1-git-send-email-ynvich@gmail.com> <52A59991.1060305@gmail.com> <1386590958.7152.135.camel@host5.omatika.ru>
In-Reply-To: <1386590958.7152.135.camel@host5.omatika.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201312100125.18754.arnd@arndb.de>
X-Provags-ID: V02:K0:ZQVgJIV77IHBxgac5aAjxBeUVlmsaOPuWpL8/BMMuA7
 mEqyd1DRLA/R5CpNhz7SgsCTfSv/OKcQ+EW16PWQ+70lO2YWDY
 Q6rZvlnFM5fTqH5TKZi14zSr8u+tYFFEwDwW3yNX24JgTR13Rn
 tCv/fPO9HJWvJ1r7R5iRqwFgMjtm9ohv0uyiTQomyvOBw3BxFb
 /Ik6uua1pt5uEjfByBcWsj/nkYhOT/ViVkqj2oPpOrDVg1HNks
 /wsPt19ciZZAWBO65QSxONqqz+1DvyhFjruvxSyPuSxCveQQnq
 csvYB0bwgnLmjE9BPUqPHhDtMvdNrYaD0K0P2Nytz5NpHZlGJI
 3se0fl0QqnOfh5mpYs6A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 December 2013, Sergei Ianovich wrote:
> On Mon, 2013-12-09 at 11:21 +0100, Daniel Mack wrote:
> > On 12/09/2013 10:34 AM, Sergei Ianovich wrote:
> > > Nice to have Daniel in this conversation. Your patch series is a big and
> > > important work. However, I am not sure I will ever land as is exactly
> > > for this reason.
> > 
> > Well, I wouldn't be so certain about that statement. As I wrote in the
> > cover letter, most of the work is actually done, and I successfully
> > tested the new DMA support with a some of the drivers I ported. Others
> > were ported blindly, and in case of no reaction, I'd dare to merge them
> > and wait for people to report back in case of trouble.
> 
> If breaking things is an option, I am definitely wrong. I assumed the
> opposite.

We never intentionally break things that people are using, but there are
cases where doing blind changes is the best way forward. We should
always try to find people to test patches on real hardware if possible,
which is only possible if there are people around that have the hardware
and that are going to run new kernels on them.

In case of PXA dmaengine support, I think the benefits of applying the
series far outweigh the breakage potential. A lot of the drivers are
shared with MMP, which is going to be DT-only eventually and will require
the new dmaengine code. Some PXA drivers may be shared with SA1100,
which has also converted to dmaengine although there are no plans to
ever support DT on sa1100.

> > > My proposal in to actually add new drivers for each platform device with
> > > DMA and mark new ones EXPERIMENTAL.
> > 
> > That would cause tree-wide cross-dependencies between drivers, because
> > the two DMA controllers can't be used at the same time, and the PXA
> > specific API will be unavailable when the mmp-dma driver is selected. My
> > patch series (and the DMA controller framework for that matter) aims for
> > the opposite - the unification of APIs and drivers.
> 
> Not sure I got this point. My proposal is to keep the existing DMA
> intact until we are ready to remove it. I understand this approach
> requires considerably more work inside DMA to allow both driver to
> coexist than wholesale replacement. I still think big change is risky.

We certainly need to be extra careful if we want to move things over
at once and cannot test all the drivers. I'd be happier if it could
be done gradually by having some drivers use the new interface and
other drivers use the old one, but I don't see how that can be done
here.

	Arnd
