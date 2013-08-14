Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759864Ab3HNLVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 07:21:06 -0400
Received: from mail-vb0-f53.google.com ([209.85.212.53]:33563 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759784Ab3HNLVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 07:21:05 -0400
MIME-Version: 1.0
In-Reply-To: <1376478213-24091-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1376478213-24091-1-git-send-email-Julia.Lawall@lip6.fr>
Date: Wed, 14 Aug 2013 16:51:02 +0530
X-Google-Sender-Auth: u0ImXnZs-96psZBIFBvIJmb2jJ4
Message-ID: <CAOh2x=muvdm+tSR+ucUWLhb1vOvXB=_+vm_v9fHfa6mHUnhRRw@mail.gmail.com>
Subject: Re: [PATCH 28/29] drivers/input/{keyboard,serio}: simplify use of devm_ioremap_resource
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        kernel-janitors@vger.kernel.org, linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 4:33 PM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> Remove unneeded error handling on the result of a call to
> platform_get_resource when the value is passed to devm_ioremap_resource.
>
> Move the call to platform_get_resource adjacent to the call to
> devm_ioremap_resource to make the connection between them more clear.
>
> A simplified version of the semantic patch that makes this change is as
> follows: (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @@
> expression pdev,res,n,e,e1;
> expression ret != 0;
> identifier l;
> @@
>
> - res = platform_get_resource(pdev, IORESOURCE_MEM, n);
>   ... when != res
> - if (res == NULL) { ... \(goto l;\|return ret;\) }
>   ... when != res
> + res = platform_get_resource(pdev, IORESOURCE_MEM, n);
>   e = devm_ioremap_resource(e1, res);
> // </smpl>
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>
> ---

>  drivers/input/keyboard/spear-keyboard.c |    7 +------

For SPEAr:

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
