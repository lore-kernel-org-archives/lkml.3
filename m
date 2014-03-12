Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbaCLNvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 09:51:24 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:34113 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbaCLNvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 09:51:22 -0400
MIME-Version: 1.0
In-Reply-To: <1394098276-11113-2-git-send-email-k.kozlowski@samsung.com>
References: <1394098276-11113-1-git-send-email-k.kozlowski@samsung.com>
	<1394098276-11113-2-git-send-email-k.kozlowski@samsung.com>
Date: Wed, 12 Mar 2014 14:51:21 +0100
Message-ID: <CACRpkdZEYWmhy6+027xp+6FdRO0RM+eVkf218Q+3HjjCWOSVOg@mail.gmail.com>
Subject: Re: [PATCH 2/2] gpio: max732x: Fix possible NULL pointer dereference
 on i2c_new_dummy error
From: Linus Walleij <linus.walleij@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 6, 2014 at 10:31 AM, Krzysztof Kozlowski
<k.kozlowski@samsung.com> wrote:

> In max732x_probe() driver allocates dummy I2C device (if number of ports
> is greater than 8) with i2c_new_dummy() but it does not check the return
> value of this call.
>
> In case of error (i2c_new_device(): memory allocation failure or I2C
> address cannot be used) this function returns NULL which is later
> dereferenced by i2c_smbus_read_byte() (called from max732x_readb()).
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Patch applied.

Yours,
Linus Walleij
