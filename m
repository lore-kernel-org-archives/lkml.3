Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbaIVTzP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 15:55:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563AbaIVTzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 15:55:14 -0400
From: Paul Moore <pmoore@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
        linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        eparis@redhat.com, sgrubb@redhat.com
Subject: Re: [PATCH] selinux: hooks: cleanup orphan keywords in audit log text
Date: Mon, 22 Sep 2014 15:55:08 -0400
Message-ID: <1456449.0ADpScPp6d@sifl>
Organization: Red Hat
User-Agent: KMail/4.14 (Linux/3.16.1-gentoo; KDE/4.14.0; x86_64; ; )
In-Reply-To: <8bedc57ef45bf628ac344bc3d8513b9a93e274ca.1411087339.git.rgb@redhat.com>
References: <8bedc57ef45bf628ac344bc3d8513b9a93e274ca.1411087339.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 18, 2014 08:50:17 PM Richard Guy Briggs wrote:
> Convert audit_log() call to WARN_ONCE().
>
> Rename "type=" to nlmsg_type=" to avoid confusion with the audit record
> type.
> 
> Added "protocol=" to help track down which protocol (NETLINK_AUDIT?) was
> used within the netlink protocol family.
> 
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  security/selinux/hooks.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)

I rewrote the patch subject line as it doesn't really make much sense given 
the changes made by the patch, but other than that it looks fine to me.

Applied.
 
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 83d06db..28ec61c 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -4681,10 +4681,9 @@ static int selinux_nlmsg_perm(struct sock *sk, struct
> sk_buff *skb) err = selinux_nlmsg_lookup(sksec->sclass, nlh->nlmsg_type,
> &perm); if (err) {
>  		if (err == -EINVAL) {
> -			audit_log(current->audit_context, GFP_KERNEL, 
AUDIT_SELINUX_ERR,
> -				  "SELinux:  unrecognized netlink message"
> -				  " type=%hu for sclass=%hu\n",
> -				  nlh->nlmsg_type, sksec->sclass);
> +			WARN_ONCE(1, "selinux_nlmsg_perm: unrecognized netlink 
message:"
> +				  " protocol=%hu nlmsg_type=%hu sclass=%hu\n",
> +				  sk->sk_protocol, nlh->nlmsg_type, sksec->sclass);
>  			if (!selinux_enforcing || security_get_allow_unknown())
>  				err = 0;
>  		}

-- 
paul moore
security and virtualization @ redhat

