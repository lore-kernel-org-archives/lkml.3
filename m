Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693AbaDWU56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 16:57:58 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:63576 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932649AbaDWU5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 16:57:15 -0400
Date: Wed, 23 Apr 2014 13:57:12 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH] [media] V4L: s5c73m3: Fix build after v4l2_of_get_next_endpoint
 rename
In-Reply-To: <1397044446-2257-1-git-send-email-k.kozlowski@samsung.com>
Message-ID: <alpine.DEB.2.02.1404231354370.1281@chino.kir.corp.google.com>
References: <1397044446-2257-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381512-1538973485-1398286633=:1281"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381512-1538973485-1398286633=:1281
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 9 Apr 2014, Krzysztof Kozlowski wrote:

> Fix build error after v4l2_of_get_next_endpoint rename (fd9fdb78a9bf:
> "[media] of: move graph helpers from drivers/media/v4l2-core..."):
> 
> drivers/media/i2c/s5c73m3/s5c73m3-core.c: In function ‘s5c73m3_get_platform_data’:
> drivers/media/i2c/s5c73m3/s5c73m3-core.c:1619:2: error: implicit declaration of function ‘v4l2_of_get_next_endpoint’ [-Werror=implicit-function-declaration]
> drivers/media/i2c/s5c73m3/s5c73m3-core.c:1619:10: warning: assignment makes pointer from integer without a cast [enabled by default]
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/media/i2c/s5c73m3/s5c73m3-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
> index a4459301b5f8..ee0f57e01b56 100644
> --- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
> +++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
> @@ -1616,7 +1616,7 @@ static int s5c73m3_get_platform_data(struct s5c73m3 *state)
>  	if (ret < 0)
>  		return -EINVAL;
>  
> -	node_ep = v4l2_of_get_next_endpoint(node, NULL);
> +	node_ep = of_graph_get_next_endpoint(node, NULL);
>  	if (!node_ep) {
>  		dev_warn(dev, "no endpoint defined for node: %s\n",
>  						node->full_name);

Acked-by: David Rientjes <rientjes@google.com>

The build error that this patch fixes is still present in Linus's tree, 
and there's been no response to it in two weeks.  Any chance of this 
getting merged?
--531381512-1538973485-1398286633=:1281--
