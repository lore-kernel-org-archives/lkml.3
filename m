Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbaEWOoG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 10:44:06 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:62138 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbaEWOoD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 10:44:03 -0400
MIME-Version: 1.0
In-Reply-To: <537F486D.9060900@elopez.com.ar>
References: <1400831485-28576-1-git-send-email-wens@csie.org>
 <1400831485-28576-8-git-send-email-wens@csie.org> <537F486D.9060900@elopez.com.ar>
From: Chen-Yu Tsai <wens@csie.org>
Date: Fri, 23 May 2014 22:43:42 +0800
X-Google-Sender-Auth: i-9yEAvi2B6ZcjjC2cAX9lKoYzc
Message-ID: <CAGb2v64+UBUZeqsy02K2x+HCh=YAAVz_wLaPVRhdD=F5zT+Ccw@mail.gmail.com>
Subject: Re: [PATCH 07/22] clk: sunxi: Fix PLL6 calculation on sun6i
To: =?UTF-8?Q?Emilio_L=C3=B3pez?= <emilio@elopez.com.ar>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, May 23, 2014 at 9:09 PM, Emilio López <emilio@elopez.com.ar> wrote:
> Hi,
>
> El 23/05/14 04:51, Chen-Yu Tsai escribió:
>
>> The N factor for PLL6 counts from 1 to 32, as specified in the A23
>> manual, and shown in Allwinner's original code.
>
>
> Are you sure about this? The A23 manual I'm looking at has a 5-bit field (so
> 0-31) on 12:8, and the examples count from 0 (eg Factor=0 N=1 ... Factor=31
> N=32).

>From the A23 manual:

Factor = 0, N = 1
Factor = 1, N = 2
Factor = 2, N = 3
 and so on


>From the A20 manual:

Factor = 0, N = 0
Factor = 1, N = 1
Factor = 2, N = 2

The "N factor" I referred to in my commit message is the N used in the
calculation,
not what is stored in the bit field.

Hope this makes it clear. :)

Cheers
ChenYu
