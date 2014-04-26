Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbaDZAnb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 20:43:31 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:46621 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaDZAna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 20:43:30 -0400
Date: Fri, 25 Apr 2014 17:43:22 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, stable@kernel.org
Subject: Re: [PATCH net-next 1/1]  hyperv: Properly handle checksum offload
Message-ID: <20140425174322.589ed9f1@samsung-9>
In-Reply-To: <1398451514-25593-1-git-send-email-kys@microsoft.com>
References: <1398451514-25593-1-git-send-email-kys@microsoft.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Apr 2014 11:45:14 -0700
"K. Y. Srinivasan" <kys@microsoft.com> wrote:

> @@ -474,6 +477,9 @@ static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
>  	csum_info = (struct ndis_tcp_ip_checksum_info *)((void *)ppi +
>  			ppi->ppi_offset);
>  
> +	ip_hdr(skb)->check = 0;
> +	csum_info->transmit.ip_header_checksum = 1;
> +
>  	if (net_trans_info & (INFO_IPV4 << 16))
>  		csum_info->transmit.is_ipv4 = 1;
>  	else

Linux doesn't need or want IP checksum offload.
It will not have any performance gain.
