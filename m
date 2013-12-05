Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495Ab3LEXdK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 18:33:10 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:61556 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679Ab3LEXcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 18:32:32 -0500
Date: Thu, 5 Dec 2013 15:32:29 -0800
From: Stephen Hemminger <stephen@networkplumber.org>
To: Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] ether_addr_equal: Optimize implementation,
 remove unused compare_ether_addr
Message-ID: <20131205153229.187f7604@nehalam.linuxnetplumber.net>
In-Reply-To: <34a0bad292ab2535a3a2e757a83eca13408e55b7.1386283991.git.joe@perches.com>
References: <34a0bad292ab2535a3a2e757a83eca13408e55b7.1386283991.git.joe@perches.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  5 Dec 2013 14:54:38 -0800
Joe Perches <joe@perches.com> wrote:

> +#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> +	u32 fold = ((*(const u32 *)addr1) ^ (*(const u32 *)addr2)) |
> +		   ((*(const u16 *)(addr1 + 4)) ^ (*(const u16 *)(addr2 + 4)));
> +
> +	return fold == 0;

Why the temporary variable. You can just do:
	return ((*(const u32 *)addr1) ^ (*(const u32 *)addr2)) |
	       ((*(const u16 *)(addr1 + 4)) ^ (*(const u16 *)(addr2 + 4))) != 0;

Or
	return !!((*(const u32 *)addr1) ^ (*(const u32 *)addr2)) |
	         ((*(const u16 *)(addr1 + 4)) ^ (*(const u16 *)(addr2 + 4))));
