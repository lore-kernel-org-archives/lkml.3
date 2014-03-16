Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbaCPTYl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 15:24:41 -0400
Received: from smtprelay0113.hostedemail.com ([216.40.44.113]:37534 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755759AbaCPTYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 15:24:40 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2553:2559:2562:2828:2902:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3870:3871:4250:4321:4559:4605:5007:6996:6997:7652:7903:10004:10400:10848:11026:11232:11233:11473:11658:11914:12043:12296:12517:12519:12740:13019:13618:14093:14097:21064,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bat60_7fbdb5a38f11d
X-Filterd-Recvd-Size: 3364
Message-ID: <1394997876.5689.60.camel@joe-AO722>
Subject: Re: [PATCH] Staging: gdm724x: gdm_lte.c: fixed coding style
From: Joe Perches <joe@perches.com>
To: Daniel Ngu <daniel.dy.ngu@gmail.com>
Cc: Jonathan Kim <jonathankim@gctsemi.com>, Dean ahn <deanahn@gctsemi.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Sun, 16 Mar 2014 12:24:36 -0700
In-Reply-To: <20140316192025.GE3478@quad>
References: <20140316192025.GE3478@quad>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-17 at 08:20 +1300, Daniel Ngu wrote:
> Line over 80 characters
> Unchecked sscanf return value
[]
> diff --git a/drivers/staging/gdm724x/gdm_lte.c b/drivers/staging/gdm724x/gdm_lte.c
[]
> @@ -536,7 +567,8 @@ static u8 find_dev_index(u32 nic_type)
>  	return index;
>  }
>  
> -static void gdm_lte_netif_rx(struct net_device *dev, char *buf, int len, int flagged_nic_type)
> +static void gdm_lte_netif_rx(struct net_device *dev, char *buf, int len,
> +			     int flagged_nic_type)
>  {
>  	u32 nic_type;
>  	struct nic *nic;
> @@ -551,28 +583,41 @@ static void gdm_lte_netif_rx(struct net_device *dev, char *buf, int len, int fla
[]
>  			struct dhcp_packet {

This one would be better fixed by moving the struct definition
out of this function altogether.

>  				u8 op;      /* BOOTREQUEST or BOOTREPLY */
> -				u8 htype;   /* hardware address type. 1 = 10mb ethernet */
> +				u8 htype;   /* hardware address type.
> +					       1 = 10mb ethernet */
>  				u8 hlen;    /* hardware address length */
>  				u8 hops;    /* used by relay agents only */
>  				u32 xid;    /* unique id */
> -				u16 secs;   /* elapsed since client began acquisition/renewal */
> +				u16 secs;   /* elapsed since client began
> +					       acquisition/renewal */
>  				u16 flags;  /* only one flag so far: */
> -				#define BROADCAST_FLAG 0x8000 /* "I need broadcast replies" */
> -				u32 ciaddr; /* client IP (if client is in BOUND, RENEW or REBINDING state) */
> +				#define BROADCAST_FLAG 0x8000 /* "I need
> +								 broadcast
> +								 replies" */
> +				u32 ciaddr; /* client IP (if client is in
> +					       BOUND, RENEW or REBINDING
> +					       state) */
>  				u32 yiaddr; /* 'your' (client) IP address */
> -				/* IP address of next server to use in bootstrap, returned in DHCPOFFER, DHCPACK by server */
> +				/* IP address of next server to use in
> +				 * bootstrap, returned in DHCPOFFER, DHCPACK by
> +				 * server */
>  				u32 siaddr_nip;
>  				u32 gateway_nip; /* relay agent IP address */
> -				u8 chaddr[16];   /* link-layer client hardware address (MAC) */
> +				u8 chaddr[16];   /* link-layer client hardware
> +						    address (MAC) */
>  				u8 sname[64];    /* server host name (ASCIZ) */
>  				u8 file[128];    /* boot file name (ASCIZ) */
> -				u32 cookie;      /* fixed first four option bytes (99,130,83,99 dec) */
> +				u32 cookie;      /* fixed first four option
> +						    bytes (99,130,83,99 dec) */
>  			} __packed;



