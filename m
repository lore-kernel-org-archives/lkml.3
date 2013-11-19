Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab3KSJ3K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 04:29:10 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:41682 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab3KSJ3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 04:29:04 -0500
MIME-Version: 1.0
In-Reply-To: <1384560086-11994-2-git-send-email-taras.kondratiuk@linaro.org>
References: <1384560086-11994-1-git-send-email-taras.kondratiuk@linaro.org>
	<1384560086-11994-2-git-send-email-taras.kondratiuk@linaro.org>
Date: Tue, 19 Nov 2013 10:29:02 +0100
Message-ID: <CACRpkdYD-Yw+RFnX0GshyQn2oHYNnXXRF4RXTzCox=2Z0_gKqg@mail.gmail.com>
Subject: Re: [RFC 01/23] gpio/omap: raw read and write endian fix
From: Linus Walleij <linus.walleij@linaro.org>
To: Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        ext Tony Lindgren <tony@atomide.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Linux-OMAP <linux-omap@vger.kernel.org>, linaro-networking@linaro.org,
        Victor Kamensky <victor.kamensky@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 16, 2013 at 1:01 AM, Taras Kondratiuk
<taras.kondratiuk@linaro.org> wrote:

> From: Victor Kamensky <victor.kamensky@linaro.org>
>
> All OMAP IP blocks expect LE data, but CPU may operate in BE mode.
> Need to use endian neutral functions to read/write h/w registers.
> I.e instead of __raw_read[lw] and __raw_write[lw] functions code
> need to use read[lw]_relaxed and write[lw]_relaxed functions.
> If the first simply reads/writes register, the second will byteswap
> it if host operates in BE mode.
>
> Changes are trivial sed like replacement of __raw_xxx functions
> with xxx_relaxed variant.
>
> Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
> Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>

Since I generally just dislike __raw accessors I went and applied
this. If it collides with any of Tony's fixup work I might need to
take the patch out again, no big deal.

Some ACKs would be nice, but unless there are major objections
this stays merged.

Yours,
Linus Walleij
