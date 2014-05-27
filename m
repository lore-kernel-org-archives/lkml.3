Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbaE0LTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 07:19:39 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:57332 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbaE0LTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 07:19:36 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] of: handle NULL node in of_get_next_available_child
To: Florian Fainelli <f.fainelli@gmail.com>, devicetree@vger.kernel.org
Cc: Florian Fainelli <f.fainelli@gmail.com>, Daniel Mack <zonque@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
In-Reply-To: <1400874192-29400-1-git-send-email-f.fainelli@gmail.com>
References: <1400874192-29400-1-git-send-email-f.fainelli@gmail.com>
Date: Tue, 27 May 2014 12:19:30 +0100
Message-Id: <20140527111930.696AAC4156C@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2014 12:43:11 -0700, Florian Fainelli <f.fainelli@gmail.com> wrote:
> Add an early check for the node argument in
> of_get_next_available_child() to avoid dereferencing a NULL node pointer
> a few lines after.
> 
> CC: Daniel Mack <zonque@gmail.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Is there a bug that exposed this path? I'd like some more justification
before merging this patch, particularly considering of_get_next_child()
doesn't check for it either, but you're not modifying that function.

g.

> ---
>  drivers/of/base.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index e67b308819c9..9a71bfac78ae 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -746,6 +746,9 @@ struct device_node *of_get_next_available_child(const struct device_node *node,
>  	struct device_node *next;
>  	unsigned long flags;
>  
> +	if (!node)
> +		return NULL;
> +
>  	raw_spin_lock_irqsave(&devtree_lock, flags);
>  	next = prev ? prev->sibling : node->child;
>  	for (; next; next = next->sibling) {
> -- 
> 1.9.1
> 

