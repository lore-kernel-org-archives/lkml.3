Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbaCGPGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:06:20 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55266 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaCGPGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:06:18 -0500
Message-ID: <1394204770.16309.16.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH] of: Fix of_graph_parse_endpoint stub for !CONFIG_OF
 builds
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, kernel@pengutronix.de
Date: Fri, 07 Mar 2014 16:06:10 +0100
In-Reply-To: <1394204235-28706-1-git-send-email-p.zabel@pengutronix.de>
References: <1394204235-28706-1-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 07.03.2014, 15:57 +0100 schrieb Philipp Zabel:
> This patch fixes the following build error:
> 
>    In file included from drivers/media/i2c/adv7343.c:29:0:
> >> include/linux/of_graph.h:41:1: error: expected identifier or '(' before '{' token
>     {
>     ^
>    include/linux/of_graph.h:39:19: warning: 'of_graph_parse_endpoint' declared 'static' but never defined [-Wunused-function]
>     static inline int of_graph_parse_endpoint(const struct device_node *node,
>                       ^
> 
> vim +41 include/linux/of_graph.h
> 
>     35                                          const struct device_node *node);
>     36  struct device_node *of_graph_get_remote_port(const struct device_node *node);
>     37  #else
>     38
>     39  static inline int of_graph_parse_endpoint(const struct device_node *node,
>     40                                          struct of_endpoint *endpoint);
>   > 41  {
>     42          return -ENOSYS;
>     43  }
>     44
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  include/linux/of_graph.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/of_graph.h b/include/linux/of_graph.h
> index 17f28eb..46795b3 100644
> --- a/include/linux/of_graph.h
> +++ b/include/linux/of_graph.h
> @@ -45,7 +45,7 @@ struct device_node *of_graph_get_remote_port(const struct device_node *node);
>  #else
>  
>  static inline int of_graph_parse_endpoint(const struct device_node *node,
> -					struct of_endpoint *endpoint);
> +					struct of_endpoint *endpoint)
>  {
>  	return -ENOSYS;
>  }

I have also updated the git branch. The following changes since commit
d484700a36952c6675aa47dec4d7a536929aa922:

  of: Warn if of_graph_parse_endpoint is called with the root node
(2014-03-06 17:41:54 +0100)

are available in the git repository at:

  git://git.pengutronix.de/git/pza/linux.git topic/of-graph

for you to fetch changes up to 00fd9619120db1d6a19be2f9e3df6f76234b311b:

  of: Fix of_graph_parse_endpoint stub for !CONFIG_OF builds (2014-03-07
16:02:46 +0100)

----------------------------------------------------------------
Philipp Zabel (1):
      of: Fix of_graph_parse_endpoint stub for !CONFIG_OF builds

 include/linux/of_graph.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

regards
Philipp

