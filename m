Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525AbaEZErx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 00:47:53 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:34768 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaEZErv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 00:47:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140525184808.GP10768@lukather>
References: <1400831485-28576-1-git-send-email-wens@csie.org>
 <1400831485-28576-4-git-send-email-wens@csie.org> <20140525184808.GP10768@lukather>
From: Chen-Yu Tsai <wens@csie.org>
Date: Mon, 26 May 2014 12:47:30 +0800
X-Google-Sender-Auth: eRA_Jfz4NMlgsRffZuuhsps4xDg
Message-ID: <CAGb2v643UmK6GfuDVfywVUeo_g7FpdZC_7SgeY-UMZ_k_-2N9Q@mail.gmail.com>
Subject: Re: [PATCH 03/22] clk: sunxi: add "pll6" to sun6i protected clock list
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 2:48 AM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> On Fri, May 23, 2014 at 03:51:06PM +0800, Chen-Yu Tsai wrote:
>> PLL6 is used by some important but undocumented module, most likely
>> memory related, such as mbus or the actual memory controller. As we
>> do not have a driver for that, add pll6 to the list of protected
>> clocks, so that it won't be disabled and leave us with a non-responsive
>> system.
>
> What issue have you seen?

Completely unresponsive after PLL6 is gated (on the A23).

> The system actually works pretty great on the A31.

Does it work when there aren't any other PLL6 consumers?
Maybe the boot0 on A31 and A23 setup some DRAM-related modules differently.

If the A31 works without protecting PLL6, I'll add a separate list
for the A23.


Thanks,
ChenYu
