Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbaCFVhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 16:37:25 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:33715 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbaCFVhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 16:37:24 -0500
Date: Thu, 06 Mar 2014 16:37:22 -0500 (EST)
Message-Id: <20140306.163722.179347273947121001.davem@davemloft.net>
To: anton@swortex.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IPv6 exthedrs offload registration fixed
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394001008-2444-1-git-send-email-anton@swortex.com>
References: <1394001008-2444-1-git-send-email-anton@swortex.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Mar 2014 13:37:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Nayshtut <anton@swortex.com>
Date: Wed,  5 Mar 2014 08:30:08 +0200

> Without this fix, ipv6_exthdrs_offload_init doesn't register IPPROTO_DSTOPTS
> offload, but returns 0 (as the IPPROTO_ROUTING registration actually succeeds).
> 
> This then causes the ipv6_gso_segment to drop IPv6 packets with IPPROTO_DSTOPTS
> header.
> 
> The issue detected and the fix verified by running MS HCK Offload LSO test on
> top of QEMU Windows guests, as this test sends IPv6 packets with
> IPPROTO_DSTOPTS.
> 
> Signed-off-by: Anton Nayshtut <anton@swortex.com>

Can't believe this was broken so obviously for so long :-)

Applied and queued up for -stable, thanks.
