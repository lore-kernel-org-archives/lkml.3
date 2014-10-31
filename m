Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422895AbaJaCzO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 22:55:14 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:61460 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422713AbaJaCzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 22:55:12 -0400
Date: Thu, 30 Oct 2014 19:54:58 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Robert Richter <rric@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        Sunil Goutham <sgoutham@cavium.com>,
        Robert Richter <rrichter@cavium.com>,
        Stefan Assmann <sassmann@redhat.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Subject: Re: [PATCH] VNIC: Adding support for Cavium ThunderX network
 controller
Message-ID: <20141030195458.2958d88a@urahara>
In-Reply-To: <20141030165434.GW20170@rric.localhost>
References: <20141030165434.GW20170@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2014 17:54:34 +0100
Robert Richter <rric@kernel.org> wrote:

> +#ifdef	VNIC_RSS_SUPPORT
> +static int rss_config = RSS_IP_HASH_ENA | RSS_TCP_HASH_ENA | RSS_UDP_HASH_ENA;
> +module_param(rss_config, int, S_IRUGO);
> +MODULE_PARM_DESC(rss_config,
> +		 "RSS hash config [bits 8:0] (Bit0:L2 extended, 1:IP, 2:TCP, 3:TCP SYN, 4:UDP, 5:L4 extended, 6:ROCE 7:L3 bi-directional, 8:L4 bi-directional)");
> +#endif

This should managed  be via ethtool ETHTOOL_GRXFH rather than a module parameter.
