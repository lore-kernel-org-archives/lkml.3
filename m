Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452Ab3E0PSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 11:18:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52878 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab3E0PSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 11:18:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: Re: [PATCH 02/14] misc/ep93xx_pwm: use {read,write}* instead of __raw_* versions for io
Date: Mon, 27 May 2013 17:18:41 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org,
        Ryan Mallon <rmallon@gmail.com>, mcrapet@gmail.com,
        hsweeten@visionengravers.com
References: <201305241621.50447.hartleys@visionengravers.com>
In-Reply-To: <201305241621.50447.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201305271718.41851.arnd@arndb.de>
X-Provags-ID: V02:K0:5QZIoRUds7UbxuobkibdOfwQPHfR72Nuumj/KZhknRc
 d+cwjNKM1r6ILjaAD9YUjmodLQ/A7ZM4RrgN9yKhursycxTbw0
 fGB6Quf/pMqcJnm28XjJ6EhuFnInh5tBGLwjXmulfaV+KBDWP7
 kfY+0EBbu6wjkRYu5lLRFfvcZmr5Dyfpz/88yWer2G4U0LJB8Z
 wdXcTHwldmPUDvN+1afHeTOL6UQUcnsvl4njloJ6uZqtNqwxAb
 7WicQPNWn05wrdMwDIziPhahxLtMyzNYORGpa651nuB8cPZVEO
 X7MeUPSHrE1BUzYCgAaF90odr/Q+lWRGkYh6EfMSpd7RzFZ4E2
 XhN8xzIFzNLBW3mxGUSM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 25 May 2013, H Hartley Sweeten wrote:
> @@ -42,13 +42,13 @@ struct ep93xx_pwm {
>  static inline void ep93xx_pwm_writel(struct ep93xx_pwm *pwm,
>                 unsigned int val, unsigned int off)
>  {
> -       __raw_writel(val, pwm->mmio_base + off);
> +       writel(val, pwm->mmio_base + off);
>  }

Just an idea: since you are adding the writel in a lot of places in subsequent
patches, you could rename 'mmio_base' to the shorter 'base' first, which would
make the resulting code actually smaller.

	Arnd
