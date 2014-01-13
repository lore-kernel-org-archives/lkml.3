Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603AbaAMJWE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 04:22:04 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:48714 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbaAMJVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 04:21:51 -0500
Message-ID: <52D3B02B.8070408@koalo.de>
Date: Mon, 13 Jan 2014 10:21:47 +0100
From: Florian Meier <florian.meier@koalo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Daniel Matuschek <daniel@matuschek.net>, alsa-devel@alsa-project.org
CC: Dimitris.Papastamos@wolfsonmicro.com, lgirdwood@gmail.com,
        broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        info@crazy-audio.com
Subject: Re: [PATCH] ASoC: wm8804: Allow control of master clock divider in
 PLL generation
References: <alpine.DEB.2.02.1401122206520.7929@parallels-Parallels-Virtual-Platform>
In-Reply-To: <alpine.DEB.2.02.1401122206520.7929@parallels-Parallels-Virtual-Platform>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2014 10:11 PM, Daniel Matuschek wrote:
> Signed-off-by: Daniel Matuschek <daniel@matuschek.net>
> 
> After some discussions of the patch last week, here is a new version.
> Simply reducing the post_table did not work, as for some frequencies
> both settings (MCLKDIV=0 and MCLKDIV=1) are needed (e.g. 96 and 192kHz)
> 
> 
>  WM8804 can run with PLL frequencies of 256xfs and 128xfs for
>  most sample rates. At 192kHz only 128xfs is supported. The
>  existing driver selects 128xfs automatically for some lower
>  samples rates. By using an additional mclk_div divider, is
>  is now possible to control the behaviour. This allows using
>  256xfs PLL frequency on all sample rates up to 96kHz. It
>  should allow lower jitter and better signal quality. The
>  behavior has to be controlled by the sound card driver,
>  because some sample frequency share the same setting. e.g.
>  192kHz and 96kHz use 24.576MHz master clock. The only
>  difference is the MCLK divider.
> 
> ---
>  sound/soc/codecs/wm8804.c |   17 ++++++++++++++---
>  sound/soc/codecs/wm8804.h |    4 ++++
>  2 files changed, 18 insertions(+), 3 deletions(-)

You have disarranged the parts, again. It should be

WM8804 can run with PLL frequencies of 256xfs and 128xfs for
most sample rates. At 192kHz only 128xfs is supported. The
existing driver selects 128xfs automatically for some lower
samples rates. By using an additional mclk_div divider, is
is now possible to control the behaviour. This allows using
256xfs PLL frequency on all sample rates up to 96kHz. It
should allow lower jitter and better signal quality. The
behavior has to be controlled by the sound card driver,
because some sample frequency share the same setting. e.g.
192kHz and 96kHz use 24.576MHz master clock. The only
difference is the MCLK divider.

Signed-off-by: Daniel Matuschek <daniel@matuschek.net>

---

After some discussions of the patch last week, here is a new version.
Simply reducing the post_table did not work, as for some frequencies
both settings (MCLKDIV=0 and MCLKDIV=1) are needed (e.g. 96 and 192kHz)

 sound/soc/codecs/wm8804.c |   17 ++++++++++++++---
 sound/soc/codecs/wm8804.h |    4 ++++
 2 files changed, 18 insertions(+), 3 deletions(-)
