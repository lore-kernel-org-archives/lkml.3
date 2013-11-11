Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab3KKHM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 02:12:26 -0500
Received: from mail.windriver.com ([147.11.1.11]:63488 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab3KKHMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 02:12:18 -0500
Message-ID: <5280833F.6010800@windriver.com>
Date: Mon, 11 Nov 2013 15:11:59 +0800
From: Fan Du <fan.du@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: <baker.kernel@gmail.com>
CC: <davem@davemloft.net>, <herbert@gondor.hengli.com.au>,
        <steffen.klassert@secunet.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 net-next] xfrm: Add check to prevent un-complete key
 manager
References: <1384093556-8987-1-git-send-email-baker.kernel@gmail.com> <1384151951-13549-1-git-send-email-baker.kernel@gmail.com>
In-Reply-To: <1384151951-13549-1-git-send-email-baker.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [128.224.162.161]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2013年11月11日 14:39, baker.kernel@gmail.com wrote:
> From: Baker Zhang<Baker.kernel@gmail.com>
>
> "acquire" and "compile_policy" callbacks are necessary for a key manager.
>
> Signed-off-by: Baker Zhang<Baker.kernel@gmail.com>
> ---
> Thanks for all reply.
>
> V1:
> For current kernel source, there is no problem.
>
> In our vpn product, we need a xfrm_km in kernel module
> to monitor the xfrm state change.
> thus, the 'acquire' and 'compile_policy' may be NULL.
>
> So I think we should do the check before use it.
>
> V2:
> Align the continuation line according the networking coding style.
>
> V3:
> Add check to prevent un-complete key manager at register time.
>
>   net/xfrm/xfrm_state.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
> index b9c3f9e..178283e 100644
> --- a/net/xfrm/xfrm_state.c
> +++ b/net/xfrm/xfrm_state.c
> @@ -1806,6 +1806,9 @@ static DEFINE_SPINLOCK(xfrm_km_lock);
>
>   int xfrm_register_km(struct xfrm_mgr *km)
>   {
> +	if (km->acquire == NULL || km->compile_policy == NULL)

"acquire" is a MUST, "compile_policy" is not a necessity.

 From  the fist commit log, you probably add functionality providing SA state changes
in your private key manager, which current implementation does not. Maybe it's worthwhile
to elaborate the missing functionality than add those checking, because both key manage
(pfkeyv2/netlink) in use has "acquire" and "compile_policy" at the same time.



-- 
浮沉随浪只记今朝笑

--fan
