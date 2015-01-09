Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021AbbAIRxZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 12:53:25 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:63536 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757174AbbAIRxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 12:53:23 -0500
MIME-Version: 1.0
In-Reply-To: <1420813745-130341-1-git-send-email-george_davis@mentor.com>
References: <1420813745-130341-1-git-send-email-george_davis@mentor.com>
From: Rob Herring <robherring2@gmail.com>
Date: Fri, 9 Jan 2015 11:53:01 -0600
Message-ID: <CAL_JsqJaT-Y7DHQS5ZZ0TP6r0iPDbUZwU-Kec5MSE7DOPgZxCg@mail.gmail.com>
Subject: Re: [PATCH] drivers: of: Export of_reserved_mem_device_{init,release}
To: "George G. Davis" <ggdavisiv@gmail.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "George G. Davis" <george_davis@mentor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 9, 2015 at 8:29 AM, George G. Davis <ggdavisiv@gmail.com> wrote:
> Export of_reserved_mem_device_{init,release} so that modules
> can initialize and release their assigned per-device cma_area.

I believe the original intent was for the core bus code to call these
functions. While the commit adding them says "automated assignment"
that part did not go in. As it stands, there are no in tree users of
these functions.

Marek, comments?

Rob

>
> Signed-off-by: George G. Davis <george_davis@mentor.com>
> ---
>  drivers/of/of_reserved_mem.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
> index dc566b3..5eeb5b2 100644
> --- a/drivers/of/of_reserved_mem.c
> +++ b/drivers/of/of_reserved_mem.c
> @@ -265,6 +265,7 @@ int of_reserved_mem_device_init(struct device *dev)
>
>         return ret;
>  }
> +EXPORT_SYMBOL(of_reserved_mem_device_init);
>
>  /**
>   * of_reserved_mem_device_release() - release reserved memory device structures
> @@ -289,3 +290,4 @@ void of_reserved_mem_device_release(struct device *dev)
>
>         rmem->ops->device_release(rmem, dev);
>  }
> +EXPORT_SYMBOL(of_reserved_mem_device_release);
> --
> 1.9.3
>
