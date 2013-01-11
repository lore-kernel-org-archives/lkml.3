Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab3AKOzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 09:55:52 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:33966 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598Ab3AKOzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 09:55:50 -0500
Subject: Re: [PATCH 1/2] tuntap: forbid calling TUNSETIFF when detached
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jason Wang <jasowang@redhat.com>
Cc: davem@davemloft.net, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>
In-Reply-To: <1357894242-25020-1-git-send-email-jasowang@redhat.com>
References: <1357894242-25020-1-git-send-email-jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Jan 2013 06:55:47 -0800
Message-ID: <1357916147.27446.3653.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-01-11 at 16:50 +0800, Jason Wang wrote:

>  
> +	if (rcu_dereference_protected(tfile->detached, lockdep_rtnl_is_held()))
> +		return -EINVAL;
> +

Thats an open coded rtnl_dereference()

(please cleanup the whole tun.c file)



