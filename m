Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab3KBTU7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 15:20:59 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:57360 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751096Ab3KBTU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 15:20:58 -0400
Message-ID: <1383420054.4378.3.camel@x220.thuisdomein>
Subject: Re: [kconfig] update: results of some syntactical checks
From: Paul Bolle <pebolle@tiscali.nl>
To: Martin Walch <walch.martin@web.de>
Cc: linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Date: Sat, 02 Nov 2013 20:20:54 +0100
In-Reply-To: <3513955.N5RNgL3hPx@tacticalops>
References: <3513955.N5RNgL3hPx@tacticalops>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Nov 2013 19:20:55.0233 (UTC) FILETIME=[A6EAD310:01CED800]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-10-20 at 00:03 +0200, Martin Walch wrote:
> drivers/media/common/siano/Kconfig:21-26
> > config SMS_SIANO_DEBUGFS
> >	bool "Enable debugfs for smsdvb"
> >	depends on SMS_SIANO_MDTV
> >	depends on DEBUG_FS
> >	depends on SMS_USB_DRV
> >	depends on CONFIG_SMS_USB_DRV = CONFIG_SMS_SDIO_DRV
> 
> The last line adds the dependency CONFIG_SMS_USB_DRV = CONFIG_SMS_SDIO_DRV.
> This expression does not look sound as those two symbols are not declared
> anywhere. So, the two strings CONFIG_SMS_USB_DRV and CONFIG_SMS_SDIO_DRV
> are compared, yielding always 'n'. As a result, SMS_SIANO_DEBUGFS will never
> be enabled.

Those are obvious typos. Still present in v3.12-rc7. Perhaps you'd like
to send the trivial patch to fix this?

> Probably, it was meant to say something like
> >	depends on SMS_USB_DRV = SMS_SDIO_DRV
> 
> Two other config sections that probably behave differently than expected:
> 
> drivers/staging/rtl8188eu/Kconfig: 13-15
> > config 88EU_AP_MODE
> >	bool "Realtek RTL8188EU AP mode"
> >	default Y
> 
> drivers/staging/rtl8188eu/Kconfig: 21-23
> > config 88EU_P2P
> >	bool "Realtek RTL8188EU Peer-to-peer mode"
> >	default Y
> 
> The capital Y is different from the lowercase y. While y is an actually
> hard coded constant symbol, Y is undeclared and evaluates to n.
> The default values are probably only for convenience, so 88EU_AP_MODE and
> 88EU_P2P are activated together with 8188EU. They still can be turned off.
> Anyway, it should probably say "default y" in both cases.

Ditto. 


Paul Bolle

