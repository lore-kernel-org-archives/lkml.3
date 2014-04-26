Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303AbaDZBPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 21:15:31 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:48439 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaDZBP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 21:15:29 -0400
Message-ID: <1398474927.29914.100.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH net-next 1/1]  hyperv: Properly handle checksum offload
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, stable@kernel.org
Date: Fri, 25 Apr 2014 18:15:27 -0700
In-Reply-To: <20140425174322.589ed9f1@samsung-9>
References: <1398451514-25593-1-git-send-email-kys@microsoft.com>
	 <20140425174322.589ed9f1@samsung-9>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-25 at 17:43 -0700, Stephen Hemminger wrote:
> On Fri, 25 Apr 2014 11:45:14 -0700
> "K. Y. Srinivasan" <kys@microsoft.com> wrote:
> 
> > @@ -474,6 +477,9 @@ static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
> >  	csum_info = (struct ndis_tcp_ip_checksum_info *)((void *)ppi +
> >  			ppi->ppi_offset);
> >  
> > +	ip_hdr(skb)->check = 0;
> > +	csum_info->transmit.ip_header_checksum = 1;
> > +
> >  	if (net_trans_info & (INFO_IPV4 << 16))
> >  		csum_info->transmit.is_ipv4 = 1;
> >  	else
> 
> Linux doesn't need or want IP checksum offload.
> It will not have any performance gain.


BTW, was this patch even tested with IPv6 packets ???


