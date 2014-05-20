Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbaETOvE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:51:04 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:46068 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbaETOvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:51:01 -0400
Message-ID: <537B6BD2.3060204@gmail.com>
Date: Tue, 20 May 2014 10:50:58 -0400
From: Vlad Yasevich <vyasevich@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vlad Yasevich <vyasevic@redhat.com>
Subject: Re: linux-next: build failure after merge of the net tree
References: <20140520105952.73f6adab@canb.auug.org.au>
In-Reply-To: <20140520105952.73f6adab@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2014 08:59 PM, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the net tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> 
> In file included from arch/powerpc/net/bpf_jit_comp.c:16:0:
> include/linux/if_vlan.h: In function 'vlan_get_encap_level':
> include/linux/if_vlan.h:491:2: error: implicit declaration of function 'vlan_dev_priv' [-Werror=implicit-function-declaration]
>   return vlan_dev_priv(dev)->nest_level;
>   ^
> include/linux/if_vlan.h:491:27: error: invalid type argument of '->' (have 'int')
>   return vlan_dev_priv(dev)->nest_level;
>                            ^
> 
> Caused by commit 44a4085538c8 ("bonding: Fix stacked device detection
> in arp monitoring").
> 
> vlan_dev_priv() is protected by:
> 
> #if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)
> 
> but the newly added call in vlan_get_encap_level() is not.
> 
> I have used the net tree from next-20140519 for today.
> 

Right.  Apologies.  I missed the above fact.  Fix forthcoming.

-vlad
