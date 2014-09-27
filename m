Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069AbaI0N6h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 09:58:37 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:38820 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbaI0N6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 09:58:30 -0400
MIME-Version: 1.0
In-Reply-To: <1411713865-26192-1-git-send-email-m.szyprowski@samsung.com>
References: <1410434561-9294-2-git-send-email-m.szyprowski@samsung.com>
	<1411713865-26192-1-git-send-email-m.szyprowski@samsung.com>
Date: Sat, 27 Sep 2014 10:58:28 -0300
Message-ID: <CAOMZO5Be=E=TNiaKDSfJC3H=yQBTTnGSa7JBJnjVf7PV=vLLWQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] drivers: of: add return value to
 of_reserved_mem_device_init (fixup)
From: Fabio Estevam <festevam@gmail.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Laura Abbott <lauraa@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        Josh Cartwright <joshc@codeaurora.org>,
        Michal Nazarewicz <mina86@mina86.com>, linaro-mm-sig@lists.linaro.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek,

On Fri, Sep 26, 2014 at 3:44 AM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> This patch adds missing return value to error paths.
>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

I have also sent a similar fix:
http://www.spinics.net/lists/devicetree/msg51127.html

> ---
>  drivers/of/of_reserved_mem.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
> index 7e7de03..e975156 100644
> --- a/drivers/of/of_reserved_mem.c
> +++ b/drivers/of/of_reserved_mem.c
> @@ -250,13 +250,13 @@ int of_reserved_mem_device_init(struct device *dev)
>
>         np = of_parse_phandle(dev->of_node, "memory-region", 0);
>         if (!np)
> -               return;
> +               return -ENODEV;
>
>         rmem = __find_rmem(np);
>         of_node_put(np);
>
>         if (!rmem || !rmem->ops || !rmem->ops->device_init)
> -               return;
> +               return -ENIVAL;

ENIVAL does not exist. I guess you meant EINVAL ;-)
