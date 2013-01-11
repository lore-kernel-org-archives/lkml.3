Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab3AKOml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 09:42:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313Ab3AKOmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 09:42:40 -0500
Date: Fri, 11 Jan 2013 15:42:36 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: davem@davemloft.net, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tuntap: forbid calling TUNSETIFF when detached
Message-ID: <20130111144236.GC2310@stefanha-thinkpad.muc.redhat.com>
References: <1357894242-25020-1-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357894242-25020-1-git-send-email-jasowang@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 04:50:41PM +0800, Jason Wang wrote:
> @@ -1546,6 +1544,9 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
>  	struct net_device *dev;
>  	int err;
>  
> +	if (rcu_dereference_protected(tfile->detached, lockdep_rtnl_is_held()))
> +		return -EINVAL;
> +

How come none of the other tfile->detached users call rcu_*()?

Stefan
