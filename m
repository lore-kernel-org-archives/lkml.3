Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab3H0LzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 07:55:09 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:14115 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141Ab3H0LzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 07:55:06 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-69-521c93979eb5
From: Tomasz Figa <t.figa@samsung.com>
To: devicetree-discuss@lists.ozlabs.org
Cc: Archit Taneja <archit@ti.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>, grant.likely@secretlab.ca
Subject: Re: [PATCH v5] gpio: pcf857x: Add OF support
Date: Tue, 27 Aug 2013 13:55 +0200
Message-id: <1830640.BeoA2uHWDI@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11 (Linux/3.10.9-gentoo; KDE/4.11.0; x86_64; ; )
In-reply-to: <521C63A0.10902@ti.com>
References: <1377590559-14279-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <2063335.Uqxok8bYMn@flatron> <521C63A0.10902@ti.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsVy+t/xa7rTJ8sEGZx5qW5xe99vRosDsx+y
	Wsw/co7V4tWZjWwWE5vusFhM+bOcyWLT42usFpvn/2G0uLxrDpvF7CX9LBbzPu9ksli1Cyi2
	8sQsZgdej52z7rJ7zO6Yyepx59oeNo/NS+o9zs9YyOjx86WOx8lTT1g8jt/YzuTxeZNcAGcU
	l01Kak5mWWqRvl0CV8bj6SdYClrFKvbPesjawLhfsIuRk0NCwETi1sTV7BC2mMSFe+vZuhi5
	OIQEljJK/J86hwXC6WKSuN82hRGkik1ATeJzwyM2EFtEQF3i2Y9zjCBFzAKHmCWWzt/LApIQ
	FjCVaP90CqyIRUBJ4vjayWAreAU0JVrenQCL8wM1v9v2lKmLkYNDVMBFou9vJojJKaAi8f27
	GsTeSYwS24+9YYVoFZT4Mfke2HhmAXmJffunskLYWhLrdx5nmsAoOAtJ2SwkZbOQlC1gZF7F
	KJpamlxQnJSea6RXnJhbXJqXrpecn7uJERJfX3cwLj1mdYhRgINRiYf3YYt0kBBrYllxZe4h
	RgkOZiUR3qnNMkFCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGOce/3R01wWDXd/2XfWy8/9rPmtS
	zr2py+fmlRZvlpkueFc0NN1bgynt6JqlhtGOx1lrGu2Uzl1efePEv8X72+dFnBRm2bH2dsBB
	jTO3yu8s3/ZqG/PeNIkyg+JPauyR5+U4Pxht8fC99yGlMHaKwQofhwcewsm1enFJ15c0in3/
	86KSs7OiQVaJpTgj0VCLuag4EQBNhsLojQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 of August 2013 14:00:24 Archit Taneja wrote:
> Hi,
> 
> On Tuesday 27 August 2013 01:44 PM, Tomasz Figa wrote:
> > Hi Laurent,
> > 
> > On Tuesday 27 of August 2013 10:02:39 Laurent Pinchart wrote:
> >> Add DT bindings for the pcf857x-compatible chips and parse the device
> >> tree node in the driver.
> >> 
> >> Signed-off-by: Laurent Pinchart
> >> <laurent.pinchart+renesas@ideasonboard.com> ---
> >> 
> >>   .../devicetree/bindings/gpio/gpio-pcf857x.txt      | 71
> >> 
> >> ++++++++++++++++++++++ drivers/gpio/gpio-pcf857x.c
> >> 
> >>    | 44 +++++++++++--- 2 files changed, 107 insertions(+), 8
> >> 
> >> deletions(-)
> >> 
> >>   create mode 100644
> >> 
> >> Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt
> >> 
> >> Changes since v4:
> >> 
> >> - Don't try to get ngpio from of_device_id data, we already get it
> >> from
> >> 
> >>    i2c_device_id
> > 
> > Hmm, I'm not sure how this is supposed to work.
> > 
> > How does the I2C core resolve OF compatible name to particular entry in
> > id_table? I believe it simply passes NULL as the second argument of
> > .probe() if the device is instantiated based on OF compatible string
> > and
> > not one in the legacy ID table.
> 
> It doesn't pass the second argument as NULL. If you look at
> i2c_device_probe() in drivers/i2c/i2c-core.c, the second argument to
> probe is passed as: i2c_match_id(driver->id_table, client)
> 
> This will extract the i2c_device_id pointer from the id_table.

Yes, there is a chance that it will not return NULL, but I think that 
relying on this is rather flawed.

If you look at the whole code path, you can see that it's only a 
coincidence that this works. See the execution flow:
 - I2C adapter driver calls of_i2c_register_devices(),
 - of_i2c_register_devices() calls of_modalias_node() for every device on 
this bus,
 - of_modalias_node() stores the second substring of compatible string 
separated by a comma, if there is one or the whole compatible otherwise to 
the output buffer (type field of i2c_board_info struct, as passed by 
of_i2c_register_devices()),
 - of_i2c_register_devices() then calls i2c_new_device() with the resulting 
info struct,
 - i2c_new_device() takes info->type and copies its contents to client-
>name,
 - then a bit later, I2C core calls i2c_match_id(), which does matching of 
client->name against id_table of the driver and the resulting i2c_device_id 
entry (or NULL) is then passed to driver's .probe() callback.

So if it happens that compatible is not equal to "<vendor>,<ID from legacy 
I2C table>", then the matching will fail and NULL will be passed.

[CCing Wolfram and Grant, as they should now more about this behavior and 
whether it's intentional or no]

Best regards,
Tomasz

