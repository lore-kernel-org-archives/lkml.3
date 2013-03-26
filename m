Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759199Ab3CZCHd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 22:07:33 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35192 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408Ab3CZCHc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 22:07:32 -0400
From: "Anna, Suman" <s-anna@ti.com>
To: Wei Yongjun <weiyj.lk@gmail.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "loic.pallardy@st.com" <loic.pallardy@st.com>,
        "omar.ramirez@copitl.com" <omar.ramirez@copitl.com>,
        "lugo.fernando@gmail.com" <lugo.fernando@gmail.com>
CC: "yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH -next v2] mailbox: fix invalid use of sizeof in
 mailbox_msg_send()
Thread-Topic: [PATCH -next v2] mailbox: fix invalid use of sizeof in
 mailbox_msg_send()
Thread-Index: AQHOJ5SkUGt9dLoyzkOPylEV/wyWEJi3Ncgg
Date: Tue, 26 Mar 2013 02:07:19 +0000
Message-ID: <37C860A02101E749A747FA2D3C1E3C5049F2BE@DLEE11.ent.ti.com>
References: <CAPgLHd_FMbnYSFFL4rKVDC59CgHcDmDyCngdFHnexom-q538gQ@mail.gmail.com>
In-Reply-To: <CAPgLHd_FMbnYSFFL4rKVDC59CgHcDmDyCngdFHnexom-q538gQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.90]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> sizeof() when applied to a pointer typed expression gives the size of the pointer,
> not that of the pointed data.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/mailbox/mailbox.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c index
> 5fea5c2..78e52c0 100644
> --- a/drivers/mailbox/mailbox.c
> +++ b/drivers/mailbox/mailbox.c
> @@ -83,7 +83,7 @@ int mailbox_msg_send(struct mailbox *mbox, struct
> mailbox_msg *msg)
> 
>  	mutex_lock(&mq->mlock);
> 
> -	if (kfifo_avail(&mq->fifo) < (sizeof(msg) + msg->size)) {
> +	if (kfifo_avail(&mq->fifo) < (sizeof(*msg) + msg->size)) {
>  		ret = -ENOMEM;
>  		goto out;
>  	}
> @@ -93,8 +93,8 @@ int mailbox_msg_send(struct mailbox *mbox, struct
> mailbox_msg *msg)
>  		goto out;
>  	}
> 
> -	len = kfifo_in(&mq->fifo, (unsigned char *)msg, sizeof(msg));
> -	WARN_ON(len != sizeof(msg));
> +	len = kfifo_in(&mq->fifo, (unsigned char *)msg, sizeof(*msg));
> +	WARN_ON(len != sizeof(*msg));
> 
>  	if (msg->size && msg->pdata) {
>  		len = kfifo_in(&mq->fifo, (unsigned char *)msg->pdata,
>

Looks good, thanks. I have added this patch to my branch on github.

Regards
Suman
 

