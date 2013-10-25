Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab3JYNXU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 09:23:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815Ab3JYNXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 09:23:19 -0400
Message-ID: <1382707377.1768.89.camel@deneb.redhat.com>
Subject: Re: linux-next: manual merge of the c6x tree
From: Mark Salter <msalter@redhat.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 25 Oct 2013 09:22:57 -0400
In-Reply-To: <1382706224-8859-1-git-send-email-treding@nvidia.com>
References: <1382632289-18523-1-git-send-email-treding@nvidia.com>
	 <1382706224-8859-1-git-send-email-treding@nvidia.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-25 at 15:03 +0200, Thierry Reding wrote:
> Today's linux-next merge of the c6x tree got a conflict in
> 
> 	arch/arm/Kconfig
> 
> caused by commits 148104c (ARM: 7854/1: lockref: add support for lockless
> lockrefs using cmpxchg64) and commit d701884 (arm: select
> ARCH_MIGHT_HAVE_PC_PARPORT).
> 
> I fixed it up (see below). Please verify that the resolution looks good.

> Thanks,
> Thierry
> ---
> diff --cc arch/arm/Kconfig
> index c06647d,7db8abe0..b6a708e
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@@ -5,7 -5,7 +5,8 @@@ config AR
>   	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
>   	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
>   	select ARCH_HAVE_CUSTOM_GPIO_H
>  +	select ARCH_USE_CMPXCHG_LOCKREF
> + 	select ARCH_MIGHT_HAVE_PC_PARPORT
>   	select ARCH_WANT_IPC_PARSE_VERSION
>   	select BUILDTIME_EXTABLE_SORT if MMU
>   	select CLONE_BACKWARDS

ARCH_USE_CMPXCHG_LOCKREF needs to come after ARCH_MIGHT_HAVE_PC_PARPORT
to keep things sorted alphabetically. Other than that, its fine.

--Mark

