Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbaCZUqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 16:46:07 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46961 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861AbaCZUqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 16:46:03 -0400
Date: Wed, 26 Mar 2014 16:46:00 -0400 (EDT)
Message-Id: <20140326.164600.1051337978560114220.davem@davemloft.net>
To: rgb@redhat.com
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        eparis@redhat.com, sgrubb@redhat.com, hadi@mojatatu.com
Subject: Re: [PATCH][v6] netlink: have netlink per-protocol bind function
 return an error code.
From: David Miller <davem@davemloft.net>
In-Reply-To: <32971f5def3bebff26650bc088c6f3f21f3c727b.1395751443.git.rgb@redhat.com>
References: <20140324183406.GE28666@madcap2.tricolour.ca>
	<32971f5def3bebff26650bc088c6f3f21f3c727b.1395751443.git.rgb@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Mar 2014 13:46:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Guy Briggs <rgb@redhat.com>
Date: Tue, 25 Mar 2014 08:50:56 -0400

> @@ -1441,6 +1445,24 @@ static int netlink_bind(struct socket *sock, struct sockaddr *addr,
>  	if (!nladdr->nl_groups && (nlk->groups == NULL || !(u32)nlk->groups[0]))
>  		return 0;
>  
> +	if (nlk->netlink_bind && nladdr->nl_groups) {
> +		int i;
> +
> +		for (i = 0; i < nlk->ngroups; i++)
 ...
> +				if (err) {
> +					int undo;
> +					if (!nlk->portid)
> +						netlink_remove(sk);

Please put an empty line between local variable declarations and code, just as it
is a few lines up.
