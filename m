Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751200AbaEWIUF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 04:20:05 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:62311 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaEWIUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 04:20:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>, devicetree@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>, linux-kernel@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>, linux-serial@vger.kernel.org
Subject: Re: [PATCH 01/22] serial: 8250_dw: Add optional reset control support
Date: Fri, 23 May 2014 10:19:47 +0200
Message-ID: <8689536.mXHvcWVbGA@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1400831485-28576-2-git-send-email-wens@csie.org>
References: <1400831485-28576-1-git-send-email-wens@csie.org> <1400831485-28576-2-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Dov30ilL6oWx1ikcy1/B/1RTRvjFUX3cLYmhomp1e1f
 JQRy5gP+PHlfBrtlm4c29skBFGdzl3voR9W3I7PRitAKMUNT2L
 kG8Q+KzdSGGLAstIJVpr0WgRQKu5nS46CrAVQ14PzIBaHFtakl
 P21O/C6rT0MvKNVSr2wQe6S0plarqytg5ERgv4im7k9PqjXHVy
 LgVyPnaKSy6nGnDox48xK5o0RYS3QTom+UTLqNnS2JN3NthxMc
 YAFHreSe/KdfqihofDGAMWg6mydaEdk48PKhLEmSuH4kEcpa7F
 pDVh2J5zhQP2gkuJ8056QeHFP1v2Wu3/gywlgeZ25FUK2ufm3+
 ZDCDLlg/1GZxdb5tnVDs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 May 2014 15:51:04 Chen-Yu Tsai wrote:
>                 p->regshift = val;
>  
> +       data->rst = devm_reset_control_get_optional(p->dev, NULL);
> +
>         /* clock got configured through clk api, all done */
>         if (p->uartclk)
>                 return 0;
> @@ -362,6 +366,9 @@ static int dw8250_probe(struct platform_device *pdev)
>                 return -ENODEV;
>         }
>  
> +       if (!IS_ERR_OR_NULL(data->rst))
> +               reset_control_deassert(data->rst);
> +

You should basically never use IS_ERR_OR_NULL(). devm_reset_control_get_optional()
doesn't return NULL, so IS_ERR() should be safe.

Alternatively, change the code above to set data->rst to NULL if there
is no reset line or error out if you get a different error (e.g. EPROBE_DEFER).

	Arnd
