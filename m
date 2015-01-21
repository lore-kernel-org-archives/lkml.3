Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbbAVAuQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 19:50:16 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:43915 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbbAVAuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 19:50:11 -0500
X-Auth-Info: ZUQepINkS+00IfcXJquKKQ6GSIbuCkqL88UQtAGpSrg=
From: Marek Vasut <marex@denx.de>
To: Zhi Li <lznuaa@gmail.com>
Subject: Re: [PATCH V2] clk: mxs: Fix invalid 32-bit access to frac registers
Date: Thu, 22 Jan 2015 00:39:01 +0100
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: Stefan Wahren <stefan.wahren@i2se.com>, mturquette@linaro.org,
        kernel list <linux-kernel@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>, harald@ccbib.org,
        Shawn Guo <shawn.guo@linaro.org>, Fabio Estevam <festevam@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1419762402-4548-1-git-send-email-stefan.wahren@i2se.com> <CAHrpEqQ-eoqM3W1hYcS6EPTmur1FSfm8TeEjYrtZ+PquavL86w@mail.gmail.com>
In-Reply-To: <CAHrpEqQ-eoqM3W1hYcS6EPTmur1FSfm8TeEjYrtZ+PquavL86w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201501220039.02073.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 21, 2015 at 05:16:03 PM, Zhi Li wrote:
> On Sun, Dec 28, 2014 at 4:26 AM, Stefan Wahren <stefan.wahren@i2se.com> wrote:
> > According to i.MX23 and i.MX28 reference manual the fractional
> > clock control registers must be addressed by byte instructions.
> 
> I don't think mx23 and mx28 have such limitation. I will double check
> with IC team about this.
> RTL is generated from a xml file. All registers implement is unified.
> I don't think only clock control register have such limitation and
> other registers not.

Hi,

Section 10.8.24 in the MX28 datasheet (Fractional Clock Control Register 0) 
states otherwise, but maybe the documentation is simply not matching the
silicon.

Here's a quote:
"
This register controls the 9-phase fractional clock dividers. The fractional 
clock frequencies are a product of the values in these registers. NOTE: This 
register can only be addressed by byte instructions. Addressing word or half-
word are not allowed.
"

I also recall seeing weird behavior when these registers were accessed by word
access in U-Boot, so I believe the datasheet is correct.

Best regards,
Marek Vasut
