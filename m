Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab3LQQCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 11:02:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194Ab3LQQCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 11:02:35 -0500
Message-ID: <1387296142.23829.87.camel@flatline.rdu.redhat.com>
Subject: Re: [PATCH 2/2] audit: fix incorrect set of audit_sock
From: Eric Paris <eparis@redhat.com>
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org, rgb@redhat.com
Date: Tue, 17 Dec 2013 11:02:22 -0500
In-Reply-To: <1387249842-27793-2-git-send-email-gaofeng@cn.fujitsu.com>
References: <1387249842-27793-1-git-send-email-gaofeng@cn.fujitsu.com>
	 <1387249842-27793-2-git-send-email-gaofeng@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-17 at 11:10 +0800, Gao feng wrote:
> NETLINK_CB(skb).sk is the socket of user space process,
> netlink_unicast in kauditd_send_skb wants the kernel
> side socket. Since the sk_state of audit netlink socket
> is not NETLINK_CONNECTED, so the netlink_getsockbyportid
> doesn't return -ECONNREFUSED.
> 
> And the socket of userspace process can be released anytime,
> so the audit_sock may point to invalid socket.
> 
> this patch sets the audit_sock to the kernel side audit
> netlink socket.
> 
> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>

Acked-by: Eric Paris <eparis@redhat.com>

> ---
>  kernel/audit.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 041b951..ff1d1d7 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -822,7 +822,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
>  				audit_log_config_change("audit_pid", new_pid, audit_pid, 1);
>  			audit_pid = new_pid;
>  			audit_nlk_portid = NETLINK_CB(skb).portid;
> -			audit_sock = NETLINK_CB(skb).sk;
> +			audit_sock = skb->sk;
>  		}
>  		if (s.mask & AUDIT_STATUS_RATE_LIMIT) {
>  			err = audit_set_rate_limit(s.rate_limit);


