Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab3BEOq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 09:46:59 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:62181 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045Ab3BEOqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 09:46:54 -0500
MIME-Version: 1.0
In-Reply-To: <1359720305-31933-4-git-send-email-blogic@openwrt.org>
References: <1359720305-31933-1-git-send-email-blogic@openwrt.org>
	<1359720305-31933-4-git-send-email-blogic@openwrt.org>
Date: Tue, 5 Feb 2013 15:46:54 +0100
Message-ID: <CACRpkdZf0dqJO=6wn1Q1HDPAcu0LueAYrABWLMEwO0kPHU3VbA@mail.gmail.com>
Subject: Re: [PATCH 04/11] PINCTRL: lantiq: add output pinconf parameter
From: Linus Walleij <linus.walleij@linaro.org>
To: John Crispin <blogic@openwrt.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 1, 2013 at 1:04 PM, John Crispin <blogic@openwrt.org> wrote:

> While converting the boards inside OpenWrt to OF I noticed that the we are
> missing a pinconf parameter to set a pin to output.
>
> Signed-off-by: John Crispin <blogic@openwrt.org>

OK, I have applied this, BUT:

> @@ -34,6 +34,7 @@ enum ltq_pinconf_param {
>         LTQ_PINCONF_PARAM_OPEN_DRAIN,
>         LTQ_PINCONF_PARAM_DRIVE_CURRENT,
>         LTQ_PINCONF_PARAM_SLEW_RATE,
> +       LTQ_PINCONF_PARAM_OUTPUT,
>  };

All of this exist in the generic pinconf library nowadays.

How about cooking a patch that converts the lantiq driver
to just use that? It'll be pretty straight forward I think.

I mean you convert it to use the generic pinconf internally,
the DT representation we'll have to live with.

See for example the new drivers that are boiling in
-next. All use generic pinconf I think. The parameter to
set a pin as output was added for the abx500 driver
this cycle.

Yours,
Linus Walleij
