Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbbAFEFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 23:05:33 -0500
Received: from exprod5og107.obsmtp.com ([64.18.0.184]:55468 "HELO
	exprod5og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753887AbbAFEF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 23:05:28 -0500
MIME-Version: 1.0
In-Reply-To: <20150105.224235.1941007145649816230.davem@davemloft.net>
References: <1420508576-10480-1-git-send-email-fkan@apm.com>
	<20150105.224137.894770670718334587.davem@davemloft.net>
	<20150105.224235.1941007145649816230.davem@davemloft.net>
Date: Mon, 5 Jan 2015 20:05:28 -0800
Message-ID: <CAL85gmCGK54yK3sThVhGsatMVUS8+76LRwdDt4w9PUfppMJ3og@mail.gmail.com>
Subject: Re: [PATCH V2] net: eth: xgene: change APM X-Gene SoC platform
 ethernet to support ACPI
From: Feng Kan <fkan@apm.com>
To: David Miller <davem@davemloft.net>
Cc: patches <patches@apm.com>, netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2015 at 7:42 PM, David Miller <davem@davemloft.net> wrote:
> From: David Miller <davem@davemloft.net>
> Date: Mon, 05 Jan 2015 22:41:37 -0500 (EST)
>
>> From: Feng Kan <fkan@apm.com>
>> Date: Mon,  5 Jan 2015 17:42:56 -0800
>>
>>> This adds support for APM X-Gene ethernet driver to use ACPI table to derive
>>> ethernet driver parameter.
>>>
>>> Signed-off-by: Feng Kan <fkan@apm.com>
>>
>> Applied.
>
> Actually, reverted, this breaks the build:
>
> drivers/net/ethernet/apm/xgene/xgene_enet_main.c:1031:28: warning: 'xgene_enet_of_match' defined but not used [-Wunused-variable]
>  static struct of_device_id xgene_enet_of_match[] = {
>                             ^
> In file included from drivers/net/ethernet/apm/xgene/xgene_enet_main.h:32:0,
>                  from drivers/net/ethernet/apm/xgene/xgene_enet_main.c:22:
> include/linux/module.h:138:40: error: '__mod_of__xgene_enet_match_device_table' aliased to undefined symbol 'xgene_enet_match'
>    extern const struct type##_device_id __mod_##type##__##name##_device_table \
>                                         ^
> drivers/net/ethernet/apm/xgene/xgene_enet_main.c:1036:1: note: in expansion of macro 'MODULE_DEVICE_TABLE'
>  MODULE_DEVICE_TABLE(of, xgene_enet_match);
>  ^
I see, I initially tried on the net-next tree which did not build for
me, failed somewhere else but builds xgene enet ok.
Then I tested on net/master which builds fine for me.
Would you please point me to the branch you are using?
