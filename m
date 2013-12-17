Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297Ab3LQHrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 02:47:42 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:34888 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab3LQHrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 02:47:40 -0500
Date: Mon, 16 Dec 2013 23:47:36 -0800
From: Stephen Hemminger <stephen@networkplumber.org>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net,
        mst@redhat.com, jasowang@redhat.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH] net, tun: remove the flow cache
Message-ID: <20131216234736.781457cd@samsung-9.home.lan>
In-Reply-To: <1387265182-27312-1-git-send-email-zwu.kernel@gmail.com>
References: <1387265182-27312-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Dec 2013 15:26:22 +0800
Zhi Yong Wu <zwu.kernel@gmail.com> wrote:

> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
> The flow cache is an extremely broken concept, and it usually brings up
> growth issues and DoS attacks, so this patch is trying to remove it from
> the tuntap driver, and insteadly use a simpler way for its flow control.
> 
> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> ---
>  drivers/net/tun.c |  208 +++--------------------------------------------------
>  1 files changed, 10 insertions(+), 198 deletions(-)
> 
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 7c8343a..7c27fdc 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -32,12 +32,15 @@
>   *
>   *  Daniel Podlejski <underley@underley.eu.org>
>   *    Modifications for 2.3.99-pre5 kernel.
> + *
> + *  Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> + *    Remove the flow cache.
>   */

I agree with your patch, but please don't add to the comment changelog.
These are all historical. The kernel development process has not used
them for 5+ years.

Can we get kernel janitors to just remove them, or would that step
on too many early developers toes by removing credit?
