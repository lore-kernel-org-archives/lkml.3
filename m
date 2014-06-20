Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbaFTO3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 10:29:18 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:53424 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbaFTO3R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 10:29:17 -0400
MIME-Version: 1.0
In-Reply-To: <1403254954-14429-1-git-send-email-sachin.kamat@samsung.com>
References: <1403254954-14429-1-git-send-email-sachin.kamat@samsung.com>
From: Andreas Noever <andreas.noever@gmail.com>
Date: Fri, 20 Jun 2014 16:28:53 +0200
Message-ID: <CAMxnaaV0PEphsdy0D8aptF8a0OHBDy4i=iOBiCdfBatNpQfSqw@mail.gmail.com>
Subject: Re: [PATCH 1/6] thunderbolt: Fix build error in eeprom.c
To: Sachin Kamat <sachin.kamat@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, spk.linux@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The series looks good. Thanks a lot for fixing these.

On Fri, Jun 20, 2014 at 11:02 AM, Sachin Kamat <sachin.kamat@samsung.com> wrote:
> Fixes the below error:
> drivers/thunderbolt/eeprom.c:407:2: error: implicit declaration of function ‘kzalloc’ [-Werror=implicit-function-declaration]
> drivers/thunderbolt/eeprom.c:444:2: error: implicit declaration of function ‘kfree’ [-Werror=implicit-function-declaration]
>
> Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
> ---
>  drivers/thunderbolt/eeprom.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/thunderbolt/eeprom.c b/drivers/thunderbolt/eeprom.c
> index 0d5a80b2d07a..bc0449f581c2 100644
> --- a/drivers/thunderbolt/eeprom.c
> +++ b/drivers/thunderbolt/eeprom.c
> @@ -5,6 +5,7 @@
>   */
>
>  #include <linux/crc32.h>
> +#include <linux/slab.h>
>  #include "tb.h"
>
>  /**
> --
> 1.7.9.5
>
