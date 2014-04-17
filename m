Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbaDQMMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 08:12:42 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:55635 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbaDQMMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 08:12:41 -0400
Message-ID: <1397736755.16539.15.camel@host5.omatika.ru>
Subject: Re: [PATCH v4 00/21] ARM: support for ICP DAS LP-8x4x (with dts)
From: Sergei Ianovich <ynvich@gmail.com>
To: Daniel Mack <daniel@zonque.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        "laurent.pinchart" <laurent.pinchart@ideasonboard.com>,
        kernel@pengutronix.de
Date: Thu, 17 Apr 2014 16:12:35 +0400
In-Reply-To: <534FAF30.1000101@zonque.org>
References: <1387309071-22382-1-git-send-email-ynvich@gmail.com>
	 <1397668411-27162-1-git-send-email-ynvich@gmail.com>
	 <534EC04F.9010408@gmail.com>
	 <610ed273-1e54-4d44-b523-cbe0d042cf48@email.android.com>
	 <534FAF30.1000101@zonque.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-17 at 12:38 +0200, Daniel Mack wrote:
> I spent some hours on this topic again now, and rebased and tested my
> tree to 3.15-rc1. Pushed it here:
> 
>   https://github.com/zonque/linux/tree/pxa-dma-3.15

Great.

> There's some overlap to the patches you sent, which I'll comment on
> directly soon.
> 
> I'm booting my board with pxa[23]xx.dtsi taken from my tree.
> 
> Please, if you find some time, test this tree and see if you still see
> the performance regression.

Sure.

> Ok, so how about this:
> 
> 1. We keep the old API around, along with compat wrappers for existing
> drivers until someone finally finds time to at least test the patches
> that I can only compile-test myself.
> 
> 2. For platforms that don't need those exotic drivers for devices that
> nobody seems to be interested in, use DT and the pxa-mmp-dma driver, and
> make sure it performs as well as the old implementation.
> 
> 3. Do not add hacks for DT-compatability of existing drivers to make
> them work with the old DMA implementation (like your patch #7).
> 
> 4. For new drivers, don't add any compat code for the old DMA
> implementation but soley rely on the new DMA framework.
> 
> 
> 
> Does this sound suitable for you?

No. I see no value in #3. There are obvious reasons to use DT whenever
possible. #3 effectively blocks DT usage for new devices. I have all the
reasons to believe, that LP-8x4x support would already have be merged,
if I didn't try to use DT.

My plan:
A. We need to know whether the new DMA implementation performs on par
with the old one. (I'm starting to check).

if so
B. We need to thinks whether it's acceptable to kill support for video
capture.

In short:

if (A && B)
  we drop old DMA
else
  we take my patch #7

