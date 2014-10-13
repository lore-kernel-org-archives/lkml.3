Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbaJMGBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 02:01:24 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:40197 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbaJMGBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 02:01:22 -0400
X-AuditID: cbfee68f-f791c6d000004834-f0-543b6aaeb8aa
Date: Mon, 13 Oct 2014 06:01:18 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v2 2/2] power: charger-manager: Avoid recursive thermal
 get_temp call
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Anton Vorontsov <anton@enomsg.org>,
        =?euc-kr?Q?=C0=CC=C1=BE=C8=AD?= <jonghwa3.lee@samsung.com>,
        =?euc-kr?Q?=C3=D6=C2=F9=BF=EC?= <cw00.choi@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20141013060031643@myungjoo.ham
Msgkey: 20141013060031643@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20141013060031643@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <326901692.426181413180076268.JavaMail.weblogic@epmlwas05a>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsWyRsSkQHddlnWIwfRv1haXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugStjyx2LgmeSFUd6GpkbGHskuxg5OYQE1CUWLTnJ1sXIwSEhYCLR
	uSEEJCwhICZx4d56oDAXUMlSRomTP4+yQyRMJPbdmwuVmMMo8fzQNxaQBIuAqsTmqZ/ZQQax
	CehJzPycDBIWFoiUWHy3nRWkXkTgJrPEsXM7wJqZBdYwShx73c0KcYWSxJp9r8AG8QoISpyc
	+YQFYpuqRNOqH2wQcTWJ3rYWNoi4hMSs6RdYIWxeiRntT6Hq5SSmfV3DDGFLS5yftYER5p3F
	3x9Dxfkljt3ewQRhC0hMPXMQqkZLYtKpC1Dz+STWLHzLAlO/69RyZphd97fMZYK5YWvLE7Ab
	mAUUJaZ0P2SHsLUkvvzYx4buF14Bd4lvc2+zgzwvITCRQ2Ltw6msExiVZiGpm4Vk1iwks5DV
	LGBkWcUomlqQXFCclF5krFecmFtcmpeul5yfu4kRmBpO/3vWv4Px7gHrQ4wCHIxKPLwWf6xC
	hFgTy4orcw8xmgIjaiKzlGhyPjAB5ZXEGxqbGVmYmpgaG5lbmimJ8y6U+hksJJCeWJKanZpa
	kFoUX1Sak1p8iJGJg1OqgXGTTXGIwPzKiuTWO6omPg0pK3efqez7vkkvQKBzrfXiQ6ymdRkr
	Lj6WFlh+12Ymp/APezGeyM3XGbnXLn93j9eGtaV8ctdKjgKvDS9c3RfILOBzt7xqd2oSYxW7
	5vXyfa36B6ecuap7aZP9ZvHyZY7Cp7kSVLx2Vl3pXi80szuyjWG325HbJ5RYijMSDbWYi4oT
	AagSLMYIAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsVy+t/tXt11WdYhBntfmVhc3jWHzYHR4/Mm
	uQDGqDSbjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWhDcyM9IwM9UyM9Q+NYK0MDAyNToJqEtIwt
	dywKnklWHOlpZG5g7JHsYuTkEBJQl1i05CQbiC0hYCKx795cKFtM4sK99UA2F1DNHEaJ54e+
	sYAkWARUJTZP/czexcjBwSagJzHzczJIWFggUmLx3XZWkHoRgZvMEsfO7QBrZhZYwyhx7HU3
	K8Q2JYk1+16BDeIVEJQ4OfMJC8Q2VYmmVT/YIOJqEr1tLVBXSEjMmn6BFcLmlZjR/hSqXk5i
	2tc1zBC2tMT5WRsYYa5e/P0xVJxf4tjtHUwQtoDE1DMHoWq0JCadugA1n09izcK3LDD1u04t
	Z4bZdX/LXCaYG7a2PAG7gVlAUWJK90N2CFtL4suPfWzofuEVcJf4Nvc2+wRG2VlIUrOQtM9C
	0o6sZgEjyypG0dSC5ILipPQKI73ixNzi0rx0veT83E2M4ET0bNEOxn/nrQ8xCnAwKvHwWvyx
	ChFiTSwrrsw9xCjBwawkwvvWxjpEiDclsbIqtSg/vqg0J7X4EKMpMNomMkuJJucDk2ReSbyh
	sbGJmYmppYmFgam5kjiv/K2kICGB9MSS1OzU1ILUIpg+Jg5OqQbG41evThFYa7amx6uvxdvy
	lmWFaOKkL3x+q9OPSAUuPLTXO6jWvM/o8gKHN3aTOfj6utzmOhdEbM07e2Dpxzlf328Xzrs2
	cfbvwjkbN78oFP9SIfn+d0gv5+bnZpd8pzFJCs/Ll/7OsWgTN9NkvZqG8oT/S1ez6YbpF+fX
	2HZse6Mx9dyj4N8XlFiKMxINtZiLihMBxZL/xFoDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9D61UKv017026

>   
>  Add a 'no_thermal' property to the power supply class. If true then
> thermal zone won't be created for this power supply in
> power_supply_register().
> 
> Power supply drivers may want to set it if they support
> POWER_SUPPLY_PROP_TEMP and they are forwarding this get property call to
> other thermal zone.
> 
> If they won't set it lockdep may report false positive deadlock for
> thermal zone's mutex because of nested calls to thermal_zone_get_temp().
> First is the call to thermal_zone_get_temp() of the driver's thermal
> zone. Thermal core gets POWER_SUPPLY_PROP_TEMP property from this
> driver. The driver then calls other thermal zone thermal_zone_get_temp()
> and returns result.
> 
> Example of such driver is charger manager.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Do we really need to add another variable in the psy struct?
In the previous thread, I thought that wasn't needed, though.


Cheers,
MyungJoo

> 
> ---
> 
> Changes since v1:
> 1. New patch (new idea).
> ---
>  drivers/power/power_supply_core.c | 3 +++
>  include/linux/power_supply.h      | 6 ++++++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
> index 6cb7fe5c022d..694e8cddd5c1 100644
> --- a/drivers/power/power_supply_core.c
> +++ b/drivers/power/power_supply_core.c
> @@ -417,6 +417,9 @@ static int psy_register_thermal(struct power_supply *psy)
>  {
>  	int i;
>  
> +	if (psy->no_thermal)
> +		return 0;
> +
>  	/* Register battery zone device psy reports temperature */
>  	for (i = 0; i < psy->num_properties; i++) {
>  		if (psy->properties[i] == POWER_SUPPLY_PROP_TEMP) {
> diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
> index 3ed049673022..096dbced02ac 100644
> --- a/include/linux/power_supply.h
> +++ b/include/linux/power_supply.h
> @@ -200,6 +200,12 @@ struct power_supply {
>  	void (*external_power_changed)(struct power_supply *psy);
>  	void (*set_charged)(struct power_supply *psy);
>  
> +	/*
> +	 * Set if thermal zone should not be created for this power supply.
> +	 * For example for virtual supplies forwarding calls to actual
> +	 * sensors or other supplies.
> +	 */
> +	bool no_thermal;
>  	/* For APM emulation, think legacy userspace. */
>  	int use_for_apm;
>  
> -- 
> 1.9.1
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
