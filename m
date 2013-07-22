Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933383Ab3GVUgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 16:36:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933272Ab3GVUgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 16:36:14 -0400
From: Paul Moore <pmoore@redhat.com>
To: Cong Wang <amwang@redhat.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        James Morris <james.l.morris@oracle.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [Patch net-next 7/7] selinux: use generic union inet_addr
Date: Mon, 22 Jul 2013 16:36:07 -0400
Message-ID: <15803221.LSzpdzDYPS@sifl>
Organization: Red Hat
User-Agent: KMail/4.10.5 (Linux/3.9.5-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1374476713-8838-8-git-send-email-amwang@redhat.com>
References: <1374476713-8838-1-git-send-email-amwang@redhat.com> <1374476713-8838-8-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 22, 2013 03:05:13 PM Cong Wang wrote:
> diff --git a/include/linux/lsm_audit.h b/include/linux/lsm_audit.h
> index 1cc89e9..db7c0d6 100644
> --- a/include/linux/lsm_audit.h
> +++ b/include/linux/lsm_audit.h
> @@ -21,6 +21,7 @@
>  #include <linux/path.h>
>  #include <linux/key.h>
>  #include <linux/skbuff.h>
> +#include <net/inet_addr.h>
> 
>  struct lsm_network_audit {
>  	int netif;
> @@ -28,16 +29,8 @@ struct lsm_network_audit {
>  	u16 family;
>  	__be16 dport;
>  	__be16 sport;
> -	union {
> -		struct {
> -			__be32 daddr;
> -			__be32 saddr;
> -		} v4;
> -		struct {
> -			struct in6_addr daddr;
> -			struct in6_addr saddr;
> -		} v6;
> -	} fam;
> +	union inet_addr saddr;
> +	union inet_addr daddr;
>  };
> 
>  /* Auxiliary data to use in generating the audit record. */
> @@ -83,9 +76,6 @@ struct common_audit_data {
>  	}; /* per LSM data pointer union */
>  };
> 
> -#define v4info fam.v4
> -#define v6info fam.v6

These changes are going to affect Smack as well.  You either need to respin 
this patch to include all of the LSMs (Smack should be the only other affected 
LSM) or add a new patch to the patchset.

-- 
paul moore
security and virtualization @ redhat

