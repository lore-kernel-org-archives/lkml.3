Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaKJR6a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 12:58:30 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:47190 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaKJR62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 12:58:28 -0500
X-Originating-IP: 50.43.41.112
Date: Mon, 10 Nov 2014 09:58:20 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Catalina Mocanu <catalina.mocanu@gmail.com>,
        Alexei Starovoitov <ast@plumgrid.com>
Subject: Re: linux-next: manual merge of the tiny tree with Linus' tree
Message-ID: <20141110175820.GC18766@thin>
References: <20141110142803.0dd121b3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110142803.0dd121b3@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 02:28:03PM +1100, Stephen Rothwell wrote:
> Hi Josh,
> 
> Today's linux-next merge of the tiny tree got a conflict in net/Kconfig
> between commit f89b7755f517 ("bpf: split eBPF out of NET") from Linus'
> tree and commit 4ecea0db79ef ("lib: rhashtable: Make rhashtable.c
> optional") from the tiny tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

This resolution looks correct to me.

- Josh Triplett

> diff --cc net/Kconfig
> index 99815b5454bf,02badd46823f..000000000000
> --- a/net/Kconfig
> +++ b/net/Kconfig
> @@@ -6,7 -6,8 +6,8 @@@ menuconfig NE
>   	bool "Networking support"
>   	select NLATTR
>   	select GENERIC_NET_UTILS
>  -	select ANON_INODES
>  +	select BPF
> + 	select RHASHTABLE
>   	---help---
>   	  Unless you really know what you are doing, you should say Y here.
>   	  The reason is that some programs need kernel networking support even


