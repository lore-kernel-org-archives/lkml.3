Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936960Ab3DIJcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:32:17 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64015 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932892Ab3DIJcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:32:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the arm-soc tree with the omap_dss2 tree
Date: Tue, 9 Apr 2013 11:32:01 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Archit Taneja <archit@ti.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Paul Bolle <pebolle@tiscali.nl>
References: <20130409174047.c506479e08e9688c0a4ced9a@canb.auug.org.au>
In-Reply-To: <20130409174047.c506479e08e9688c0a4ced9a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304091132.01771.arnd@arndb.de>
X-Provags-ID: V02:K0:Ad7oVeOjTWWg0tZK/nOKEktiWyhSSzzs7wGIaC7SKS8
 QbesXBnZKk3RndgsO01P1gTmJhZF9j4iVBVjqkM6lr/fYRVomx
 b1P1Xu1iDNxHcpnJPtdQw/B3dsKV9knhgdgUh2wEHs4QfgDAKz
 at5jDVa0OXkMG1/jjo2lBXC2H0DNUnCPpUbtx4D8Q408pGFRvS
 KYLmPqPXa9Y/ixT+I3w8FTiSOaQTsQAqrBEAihp0T3+GbcNMVg
 RciMAkNJzdA6V2JFXF3KRSFUbIzW3YwMlVwCu5R025QKttrM9J
 bQMJHFmmzF5zjediXcN/jg7KnqFpTrJHkYD+jDdGJoxgX0KYH9
 mtqoO1NoFXV4dQMTe0Io=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 April 2013, Stephen Rothwell wrote:
> 
> - #if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91x_MODULE)
>  -static void __init sdp2430_display_init(void)
>  -{
>  -      int r;
>  -
>  -      static struct gpio gpios[] __initdata = {
>  -              { SDP2430_LCD_PANEL_ENABLE_GPIO, GPIOF_OUT_INIT_LOW,
>  -                      "LCD reset" },
>  -              { SDP2430_LCD_PANEL_BACKLIGHT_GPIO, GPIOF_OUT_INIT_LOW,
>  -                      "LCD Backlight" },
>  -      };
>  -
>  -      r = gpio_request_array(gpios, ARRAY_SIZE(gpios));
>  -      if (r) {
>  -              pr_err("Cannot request LCD GPIOs, error %d\n", r);
>  -              return;
>  -      }
>  -
>  -      omap_display_init(&sdp2430_dss_data);
>  -}
>  -
> + #if IS_ENABLED(CONFIG_SMC91X)

Looks good, thanks!

	Arnd
