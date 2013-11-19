Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab3KSQwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 11:52:16 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:34462 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab3KSQwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 11:52:15 -0500
Message-ID: <528B9706.1070805@collabora.co.uk>
Date: Tue, 19 Nov 2013 17:51:18 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        ext Tony Lindgren <tony@atomide.com>,
        Linux-OMAP <linux-omap@vger.kernel.org>, linaro-networking@linaro.org,
        Victor Kamensky <victor.kamensky@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 01/23] gpio/omap: raw read and write endian fix
References: <1384560086-11994-1-git-send-email-taras.kondratiuk@linaro.org> <1384560086-11994-2-git-send-email-taras.kondratiuk@linaro.org> <CACRpkdYD-Yw+RFnX0GshyQn2oHYNnXXRF4RXTzCox=2Z0_gKqg@mail.gmail.com>
In-Reply-To: <CACRpkdYD-Yw+RFnX0GshyQn2oHYNnXXRF4RXTzCox=2Z0_gKqg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2013 10:29 AM, Linus Walleij wrote:
> On Sat, Nov 16, 2013 at 1:01 AM, Taras Kondratiuk
> <taras.kondratiuk@linaro.org> wrote:
> 
>> From: Victor Kamensky <victor.kamensky@linaro.org>
>>
>> All OMAP IP blocks expect LE data, but CPU may operate in BE mode.
>> Need to use endian neutral functions to read/write h/w registers.
>> I.e instead of __raw_read[lw] and __raw_write[lw] functions code
>> need to use read[lw]_relaxed and write[lw]_relaxed functions.
>> If the first simply reads/writes register, the second will byteswap
>> it if host operates in BE mode.
>>
>> Changes are trivial sed like replacement of __raw_xxx functions
>> with xxx_relaxed variant.
>>
>> Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
>> Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
> 
> Since I generally just dislike __raw accessors I went and applied
> this. If it collides with any of Tony's fixup work I might need to
> take the patch out again, no big deal.
> 
> Some ACKs would be nice, but unless there are major objections
> this stays merged.

Looks good to me and also I've tested this patch on a TI DM3730 (Cortex A-8)
board in LE mode and found no regressions on devices using a GPIO.

Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

> 
> Yours,
> Linus Walleij
> 

Thanks a lot and best regards,
Javier
