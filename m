Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbaJ1PFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 11:05:25 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:55356 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaJ1PFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 11:05:20 -0400
MIME-Version: 1.0
In-Reply-To: <1413479495-14206-9-git-send-email-soren.brinkmann@xilinx.com>
References: <1413479495-14206-1-git-send-email-soren.brinkmann@xilinx.com>
	<1413479495-14206-9-git-send-email-soren.brinkmann@xilinx.com>
Date: Tue, 28 Oct 2014 16:05:18 +0100
Message-ID: <CACRpkda9v=H9rQBq484c+UCwEKeca9qOE_78Wf+STB4rDwhuyA@mail.gmail.com>
Subject: Re: [PATCH RFC v2 8/8] ARM: zynq: DT: Add pinctrl information
From: Linus Walleij <linus.walleij@linaro.org>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 7:11 PM, Soren Brinkmann
<soren.brinkmann@xilinx.com> wrote:

> Add pinctrl descriptions to the zc702 and zc706 device trees.
>
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>

(...)
> +&pinctrl0 {
> +       pinctrl_can0_default: pinctrl-can0-default {
> +               common {
> +                       function = "can0";
> +                       groups = "can0_9_grp";
> +                       bias-pull-up = <0>;

No. If you want pull-up, just use
bias-pull-up;

If you want to disable pull-up, use
bias-disable;

> +                       slew-rate = <0>;

If this measure is any kind of time unit, this is against the laws of nature.

> +                       io-standard = <1>;
> +               };
> +
> +               rx {
> +                       pins = "MIO46";
> +                       bias-high-impedance = <1>;

Just
bias-high-impedance;

> +               };
> +
> +               tx {
> +                       pins = "MIO47";
> +                       bias-high-impedance = <0>;

Just
bias-disable;

Look all these over closely.

Yours,
Linus Walleij
