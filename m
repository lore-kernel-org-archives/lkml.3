Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934874Ab3DHQR5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 12:17:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64603 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934837Ab3DHQR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 12:17:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 1/5] ARM: ux500: Move DMA40 platform data includes file out to include/
Date: Mon, 8 Apr 2013 18:17:41 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com
References: <1365434591-21569-1-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1365434591-21569-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304081817.42031.arnd@arndb.de>
X-Provags-ID: V02:K0:kmnQZcFhZxC/9PFdUuxdPl1S0tCcySHthvL5SbXtAO9
 dOlBJ8PSiuhb/zrJgYj37SFpV28fhUlDbgO1hnpRJ+U4Wl33ER
 K1BYNIWtIQL/4jHEYnXc3QnC3ACgNg6tgFRJ8tJqI1coj5zvjw
 8KCgbuV6BEmwZ+nkbVtdfAhIiX5ZR5gLusIoR0sqeY/S6ExA8I
 /SRNxJyPC8YRtidOQnSlLFu0cK+3eQ1vPV8Ldu1gGZ2efMjyYD
 RCkfgqGnLciLJEIUOuieR+cDoBbNLBm4I2le+sqfoy42lRYcJJ
 Iu9wkRKvbfAFTi6GGoWmQRxKijt8epjS87YkYfEqIgQ/A7H11k
 M9kJKMhAe1BuWD9aSbxU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 April 2013, Lee Jones wrote:
> The pin names for DB8500 based platforms need to be moved out of
> ux500 platform data and into the new proper location in include/
> linux/platform_data/. This way we an reference them from other
> external locations, such as the main DMA50 driver(s).
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Hmm, not sure about this one. The slave numbers are not really platform_data
and I think they should not be exposed to drivers. It makes sense to
keep the numbers for the memcpy channels in the driver itself as they
are hardwired in the driver, but the slave channels should stay in the
platform I think.

	Arnd
