Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242Ab3AQIho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 03:37:44 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:45704 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759324Ab3AQIhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 03:37:42 -0500
Date: Thu, 17 Jan 2013 03:37:40 -0500 (EST)
Message-Id: <20130117.033740.1579145176326281217.davem@davemloft.net>
To: r.kuntz@ipflavors.com
Cc: netdev@vger.kernel.org, yoshfuji@linux-ipv6.org,
        steffen.klassert@secunet.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ipv6: fix header length calculation in
 ip6_append_data()
From: David Miller <davem@davemloft.net>
In-Reply-To: <F2E313A0-60C5-49DE-BBB7-BAEF532C0433@ipflavors.com>
References: <F2E313A0-60C5-49DE-BBB7-BAEF532C0433@ipflavors.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Romain KUNTZ <r.kuntz@ipflavors.com>
Date: Wed, 16 Jan 2013 23:47:40 +0100

> Commit 299b0767 (ipv6: Fix IPsec slowpath fragmentation problem)
> has introduced a error in the header length calculation that 
> provokes corrupted packets when non-fragmentable extensions 
> headers (Destination Option or Routing Header Type 2) are used.
> 
> rt->rt6i_nfheader_len is the length of the non-fragmentable 
> extension header, and it should be substracted to
> rt->dst.header_len, and not to exthdrlen, as it was done before
> commit 299b0767.
> 
> This patch reverts to the original and correct behavior. It has
> been successfully tested with and without IPsec on packets
> that include non-fragmentable extensions headers.
> 
> Signed-off-by: Romain Kuntz <r.kuntz@ipflavors.com>
> Acked-by: Steffen Klassert <steffen.klassert@secunet.com>

Applied, thanks.
