Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbaJOV5H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 17:57:07 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:49874 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaJOV5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 17:57:05 -0400
Date: Wed, 15 Oct 2014 14:57:01 -0700
From: Benjamin Poirier <benjamin.poirier@gmail.com>
To: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Carles =?iso-8859-1?Q?Pag=E8s?= <page@cubata.homelinux.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Regarding tx-nocache-copy in the Sheevaplug
Message-ID: <20141015215701.GA4109@f1.synalogic.ca>
References: <20141013105246.GD1972@vicerveza.homeunix.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141013105246.GD1972@vicerveza.homeunix.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/10/13 12:52, Lluís Batlle i Rossell wrote:
> Hello,
> 
> on the 7th of January 2014 ths patch was applied:
> https://lkml.org/lkml/2014/1/7/307
> 
> [PATCH v2] net: Do not enable tx-nocache-copy by default
>         
> In the Sheevaplug (ARM Feroceon 88FR131 from Marvell) this made packets to be
> sent corrupted. I think this machine has something special about the cache.
> 
> Enabling back this tx-nocache-copy (as it used to be before the patch) the
> transfers work fine again. I think that most people, encountering this problem,
> completely disable the tx offload instead of enabling back this setting.
> 
> Is this an ARM kernel problem regarding this platform?

This is odd, only x86 defines ARCH_HAS_NOCACHE_UACCESS. On arm,
skb_do_copy_data_nocache() should end up using __copy_from_user()
regardless of tx-nocache-copy.
