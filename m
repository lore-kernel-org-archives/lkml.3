Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693Ab3IKSo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 14:44:27 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:62393 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775Ab3IKSo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 14:44:26 -0400
Message-ID: <5230BA0A.6020903@cogentembedded.com>
Date: Wed, 11 Sep 2013 22:44:26 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Marc Weber <marco-oweber@gmx.de>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: drivers/net/ethernet/nvidia/forcedeth.c saved_config_space[size]
 access patch
References: <1378682421-sup-4422@nixos>
In-Reply-To: <1378682421-sup-4422@nixos>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 09/09/2013 03:39 AM, Marc Weber wrote:

>    1) VER3 and _MAX are of same size:
>    #define NV_PCI_REGSZ_VER3       0x604
>    #define NV_PCI_REGSZ_MAX        0x604


>    2) It looks like there is a case where VER3 get's assigned to
>        register_size:

>    if (id->driver_data &
>    (DEV_HAS_VLAN|DEV_HAS_MSI_X|DEV_HAS_POWER_CNTRL|DEV_HAS_STATISTICS_V2|DEV_HAS_STATISTICS_V
>                    np->register_size = NV_PCI_REGSZ_VER3;

>    3) the definition of saved_config_space is MAX divided by 4 (size of u32)
>    struct fe_priv {
>      [...]
>      u32 saved_config_space[NV_PCI_REGSZ_MAX/4]

>    4) This doesn't stop loop at [size-1]:
>      Thus there is the risk that it overrides the field after
>      saved_config_space. If that's desired behaviour at least a comment
>      is missing IMHO:

>    for (i = 0; i <= np->register_size/sizeof(u32); i++)
>       np->saved_config_space[i] = readl(base + i*sizeof(u32));

>    Such for loop is used twice in forcedeth.c

> Patch againstn 4de9ad9bc08 (Fri Sep 6 11:14:33) attached fixing both
> using < instead of <=.

> If you think I've hit a small bug just fix and commit.
> I don't care much about my ownership of this patch.

> I didn't test this patch because I don't have the hardware and I think
> its a trivial case.

    Don't attach the patches, send them inline instead. And please mark the 
mails with patches with [PATCH] in the subject.

> Marc Weber

WBR, Sergei

