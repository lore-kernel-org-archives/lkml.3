Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868Ab3CZKZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 06:25:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:65473 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757561Ab3CZKZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 06:25:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [GIT PULL] at91: fixes for 3.9-rc #2
Date: Tue, 26 Mar 2013 10:22:39 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
References: <51517592.5010300@atmel.com>
In-Reply-To: <51517592.5010300@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303261022.39882.arnd@arndb.de>
X-Provags-ID: V02:K0:rtXfrnHxWzdiAmofQKhh9rHmxZD2/+bRyMusBWTwcHJ
 qnjAQBDlmob6NridQQek5iTeGsXiU6JyOdaYG8dFrOWrXP4lwg
 uWP9mNswINJm64PoIv6P1GQ8RoVQlYzAcHIlhHZf7biWjbh1EX
 Yu0uv7Tx30bDK4qmdfPW9SObfd62On6HfYTrbOGvhizZ4SOj+Z
 lh63RC+U5ihfgKGFO2qZZZmOUA3GuKfh+0EjevzMi0DyAYQzG9
 v97urjlm+PAyI1GpGNyIaojTS32alMxExK3X11tjhfSunByGEk
 +2/TT+xSEHenkSjrHsrfPXypKW8ElTODtp51ioP1HN+AT1UNk2
 gSnntCJ9RgHP47bx0cKg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 March 2013, Nicolas Ferre wrote:
> Another "fixes" pull-request for AT91 on top of material that you have already
> taken. Fixes are manly typos but the bad node declaration and some misspelling
> can cause confusion.

Hi Nicolas,

I'd prefer to take only fixes for serious bugs into 3.9 now, since I have
already sent the fixes for -rc5. As far as I can tell, the macb node patch
is the only one that falls into that category, but for that one, I'd
prefer if it could be redone in a simpler way, by replacing

+       ahb {
+               apb {
+                       macb0: ethernet@f802c000 {
+                               phy-mode = "rmii";
+                               status = "okay";
+                       };
+               };
+       };


with

	@macb0 {
		phy-mode = "rmii";
		status = "okay";
	}

as there is no need to provide the full path when you already have
a label for the device.

	Arnd
