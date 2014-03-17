Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933053AbaCQNag (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 09:30:36 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:38534 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756489AbaCQNae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 09:30:34 -0400
MIME-Version: 1.0
In-Reply-To: <5326F72E.7010401@monstr.eu>
References: <1395057936-8643-1-git-send-email-harinik@xilinx.com>
	<CAL_JsqKacetGytGUJir7ky3qOgCy-3ny1pT_Bx4eCYV2wMgcTg@mail.gmail.com>
	<5326F72E.7010401@monstr.eu>
Date: Mon, 17 Mar 2014 14:30:33 +0100
X-Google-Sender-Auth: agTw580ZSBAzZUztItnOhvcTbBI
Message-ID: <CAMuHMdVzE=oWTb-D5j_xRu4Q25YGWbFHi8wnaYZSTSXor2kbxA@mail.gmail.com>
Subject: Re: [PATCH] SPI: Add driver for Cadence SPI controller
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michal Simek <monstr@monstr.eu>
Cc: Rob Herring <robherring2@gmail.com>, Harini Katakam <harinik@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 2:22 PM, Michal Simek <monstr@monstr.eu> wrote:
>>> +       return 0;
>>> +}
>>> +
>>> +static SIMPLE_DEV_PM_OPS(cdns_spi_dev_pm_ops, cdns_spi_suspend,
>>> +                        cdns_spi_resume);
>>> +
>>> +/* Work with hotplug and coldplug */
>>> +MODULE_ALIAS("platform:" CDNS_SPI_NAME);
>>
>> Not sure, but I don't think this should be needed.
>
> I don't know too.

A plain platform device driver needs the MODULE_ALIAS, unless there's
a "MODULE_DEVICE_TABLE(platform, ...)", which doesn't exist in this driver.

However, as the driver fails in the absence of DT:

      ret = of_property_read_u16(pdev->dev.of_node, "num-chip-select",
                                  &master->num_chipselect);
      if (ret < 0) {
              dev_err(&pdev->dev, "couldn't determine num-chip-select\n");
              goto clk_dis_all;
      }

it won't work (yet) as a plain platform device driver.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
