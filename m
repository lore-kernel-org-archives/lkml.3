Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393Ab3AOSV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:21:58 -0500
Received: from mailfw02.zoner.fi ([84.34.147.249]:39581 "EHLO
	mailfw02.zoner.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202Ab3AOSV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:21:57 -0500
X-Greylist: delayed 584 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jan 2013 13:21:56 EST
Date: Tue, 15 Jan 2013 20:11:17 +0200
From: Lasse Collin <lasse.collin@tukaani.org>
To: Florian Fainelli <florian@openwrt.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] decompressors: make the default XZ_BCJ_* config
 match the selected architecture
Message-ID: <20130115201117.5ce0a690@tukaani.org>
In-Reply-To: <1358266931-23401-2-git-send-email-florian@openwrt.org>
References: <1358266931-23401-1-git-send-email-florian@openwrt.org>
	<1358266931-23401-2-git-send-email-florian@openwrt.org>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.14; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-01-15 Florian Fainelli wrote:
> This patch changes the defautl XZ_BCJ_* config symbol to match the
> configured architecture. It is perfectly legitimate to support
> multiple XZ BCJ filters for different architectures (e.g.: to mount
> foreign squashfs/xz compressed filesystems), it is however more
> natural not to select them all by default, but only the one matching
> the configured architecture.

I don't have a strong opinion on what is the best default setting, so
it's fine to me that the default is changed if that's what people
prefer.

>  config XZ_DEC_X86
>  	bool "x86 BCJ filter decoder" if EXPERT
> -	default y
> +	default y if X86
>  	select XZ_DEC_BCJ
[...]

I think the "if EXPERT" strings should be dropped when all BCJ filters
aren't enabled by default. One should be able to enable all filters
without enabling EXPERT.

-- 
Lasse Collin  |  IRC: Larhzu @ IRCnet & Freenode
