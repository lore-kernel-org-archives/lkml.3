Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab3D2HBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 03:01:55 -0400
Received: from plane.gmane.org ([80.91.229.3]:58107 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab3D2HBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 03:01:54 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH net v2 2/3] unix/dgram: fix peeking with an offset
 larger than data in queue
Date: Mon, 29 Apr 2013 07:01:39 +0000 (UTC)
Message-ID: <kll5si$544$1@ger.gmane.org>
References: <1366915736.8964.171.camel@edumazet-glaptop>
 <1367001312-6719-1-git-send-email-bpoirier@suse.de>
 <1367001312-6719-2-git-send-email-bpoirier@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 182.241.5.213
User-Agent: slrn/0.9.9p1 (Linux)
Cc: netdev@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Apr 2013 at 18:35 GMT, Benjamin Poirier <bpoirier@suse.de> wrote:
>  struct sk_buff *__skb_recv_datagram(struct sock *sk, unsigned int flags,
> -				    int *peeked, int *off, int *err)
> +				    int *peeked, int *_off, int *err)
>  {
> -	struct sk_buff *skb;
> +	struct sk_buff *skb, *last;
>  	long timeo;
>  	/*
>  	 * Caller is allowed not to check sk->sk_err before skb_recv_datagram()
> @@ -182,14 +183,17 @@ struct sk_buff *__skb_recv_datagram(struct sock *sk, unsigned int flags,
>  		 */
>  		unsigned long cpu_flags;
>  		struct sk_buff_head *queue = &sk->sk_receive_queue;
> +		int off = *_off;
>  

Name the local variable '_off', not the function argument.
Or pick another name, e.g. 'offset'.

