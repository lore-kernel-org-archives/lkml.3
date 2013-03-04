Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab3CDHX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 02:23:59 -0500
Received: from plane.gmane.org ([80.91.229.3]:38780 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453Ab3CDHX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 02:23:57 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [RFC PATCH 1/5] net: implement support for low latency socket
 polling
Date: Mon, 4 Mar 2013 07:23:35 +0000 (UTC)
Message-ID: <kh1i5m$jqp$1@ger.gmane.org>
References: <20130227175549.10611.82188.stgit@gitlad.jf.intel.com>
 <20130227175555.10611.42794.stgit@gitlad.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 180.129.196.184
User-Agent: slrn/0.9.9p1 (Linux)
Cc: netdev@vger.kernel.org, e1000-devel@lists.sourceforge.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2013 at 17:55 GMT, Eliezer Tamir <eliezer.tamir@linux.jf.intel.com> wrote:
> +static inline void skb_mark_ll(struct napi_struct *napi, struct sk_buff *skb)
> +{
> +	skb->dev_ref = napi;
> +}
> +
> +static inline void sk_mark_ll(struct sock *sk, struct sk_buff *skb)
> +{
> +	if (skb->dev_ref)
> +		sk->dev_ref = skb->dev_ref;
> +
> +}


It is actually easier to read the code without making them be
functions...


