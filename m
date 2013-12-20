Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995Ab3LTBig (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 20:38:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756716Ab3LTBif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 20:38:35 -0500
Date: Thu, 19 Dec 2013 20:38:28 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] audit: fix incorrect set of audit_sock
Message-ID: <20131220013828.GC14944@madcap2.tricolour.ca>
References: <1387249842-27793-1-git-send-email-gaofeng@cn.fujitsu.com>
 <1387249842-27793-2-git-send-email-gaofeng@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387249842-27793-2-git-send-email-gaofeng@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/12/17, Gao feng wrote:
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

Thank you.

> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
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
> -- 
> 1.8.3.1

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
