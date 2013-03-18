Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab3CRO41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 10:56:27 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:41700 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab3CRO4Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 10:56:25 -0400
Date: Mon, 18 Mar 2013 11:56:18 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: bluetooth: Replaced kzalloc and memcpy with kmemdup
Message-ID: <20130318145618.GA16337@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	Alexandru Gheorghiu <gheorghiuandru@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1363442830-13754-1-git-send-email-gheorghiuandru@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1363442830-13754-1-git-send-email-gheorghiuandru@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandru,

* Alexandru Gheorghiu <gheorghiuandru@gmail.com> [2013-03-16 16:07:10 +0200]:

> Replaced calls to kzalloc followed by memcpy with a single call to kmemdup.
> Patch found using coccinelle.
> 
> Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
> ---
>  net/bluetooth/a2mp.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/net/bluetooth/a2mp.c b/net/bluetooth/a2mp.c
> index eb0f4b1..140e81c 100644
> --- a/net/bluetooth/a2mp.c
> +++ b/net/bluetooth/a2mp.c
> @@ -397,13 +397,12 @@ static int a2mp_getampassoc_rsp(struct amp_mgr *mgr, struct sk_buff *skb,
>  	if (ctrl) {
>  		u8 *assoc;
>  
> -		assoc = kzalloc(assoc_len, GFP_KERNEL);
> +		assoc = kmemdup(rsp->amp_assoc, assoc_len, GFP_KERNEL);
>  		if (!assoc) {
>  			amp_ctrl_put(ctrl);
>  			return -ENOMEM;
>  		}
>  
> -		memcpy(assoc, rsp->amp_assoc, assoc_len);
>  		ctrl->assoc = assoc;
>  		ctrl->assoc_len = assoc_len;
>  		ctrl->assoc_rem_len = assoc_len;
> @@ -472,13 +471,12 @@ static int a2mp_createphyslink_req(struct amp_mgr *mgr, struct sk_buff *skb,
>  		size_t assoc_len = le16_to_cpu(hdr->len) - sizeof(*req);
>  		u8 *assoc;
>  
> -		assoc = kzalloc(assoc_len, GFP_KERNEL);
> +		assoc = kmemdup(rep->amp_assoc, assoc_len, GFP_KERNEL);

Please get into the habit of build your patches before sending them upstream:

  CC [M]  net/bluetooth/a2mp.o
net/bluetooth/a2mp.c: In function ‘a2mp_createphyslink_req’:
net/bluetooth/a2mp.c:474:19: error: ‘rep’ undeclared (first use in this function)
net/bluetooth/a2mp.c:474:19: note: each undeclared identifier is reported only once for each function it appears in
make[2]: *** [net/bluetooth/a2mp.o] Error 1
make[1]: *** [net/bluetooth] Error 2


	Gustavo
