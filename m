Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbaFMOz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 10:55:26 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:44699 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaFMOzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 10:55:25 -0400
MIME-Version: 1.0
In-Reply-To: <20140610165700.GA3453@www.outflux.net>
References: <20140610165700.GA3453@www.outflux.net>
From: Rob Herring <robherring2@gmail.com>
Date: Fri, 13 Jun 2014 09:55:04 -0500
Message-ID: <CAL_JsqKJq-u7GGDfNONAT7tjAK-2AKQi64X8Au0N8gzPpEoNug@mail.gmail.com>
Subject: Re: [PATCH] of: avoid format string parsing in kobject names
To: Kees Cook <keescook@chromium.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 11:57 AM, Kees Cook <keescook@chromium.org> wrote:
> This makes sure a format string cannot leak into the kobject name that
> is constructed. (And splits the >80 character line.)
>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Applied.

This seems like a non-obvious thing to do, but I guess most people
aren't dealing directly with kobjects.

Rob

> ---
>  drivers/of/base.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index 8368d96ae7b4..f27d922eaece 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -227,7 +227,8 @@ static int __of_node_add(struct device_node *np)
>         np->kobj.kset = of_kset;
>         if (!np->parent) {
>                 /* Nodes without parents are new top level trees */
> -               rc = kobject_add(&np->kobj, NULL, safe_name(&of_kset->kobj, "base"));
> +               rc = kobject_add(&np->kobj, NULL, "%s",
> +                                safe_name(&of_kset->kobj, "base"));
>         } else {
>                 name = safe_name(&np->parent->kobj, kbasename(np->full_name));
>                 if (!name || !name[0])
> --
> 1.7.9.5
>
>
> --
> Kees Cook
> Chrome OS Security
