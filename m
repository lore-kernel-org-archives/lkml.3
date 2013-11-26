Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab3KZMyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 07:54:16 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:31368 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab3KZMyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 07:54:13 -0500
X-AuditID: cbfee61b-b7f166d000007a34-94-529499f4be93
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Bockholdt Arne <a.bockholdt@precitec-optronik.de>
Cc: Len Brown <lenb@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] intel_idle: Fixed C6 state on Avoton/Rangeley processors
Date: Tue, 26 Nov 2013 13:53:58 +0100
Message-id: <1574800.Vl6NB1rGSk@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1385450037.4588.10.camel@po-d-abo-ubu>
References: <1385450037.4588.10.camel@po-d-abo-ubu>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=utf-8
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t9jQd0vM6cEGZzdImRxeONHJoudD9+y
	WVzeNYfN4nPvEUYHFo9NqzrZPG79+sPq8XmTXABzFJdNSmpOZllqkb5dAlfG1g+HWAu6uCue
	vljH2MD4maOLkZNDQsBEYvudU+wQtpjEhXvr2boYuTiEBKYzSizrXMEE4bQwSVz9dp8VpIpN
	wEpiYvsqRhBbRMBUYtPEXWAdzAIzGSWezD/PBpIQFvCV+HbhAthYFgFViZ5nH4HiHBy8ApoS
	Ez9ngYRFBTwldmxfCVbOCXTF58OLWEBsIQFjiePvmsHm8woISvyYfA8sziwgL7Fv/1RWkDHM
	AuoSU6bkTmAUmIWkahaSqlkIVQsYmVcxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBAfsM+kd
	jKsaLA4xCnAwKvHwSnRODhJiTSwrrsw9xCjBwawkwhs7fUqQEG9KYmVValF+fFFpTmrxIUZp
	DhYlcd6DrdaBQgLpiSWp2ampBalFMFkmDk6pBkZd09XK1c0H1+wV6X+9cHrOd/9PLDHPDxcL
	lBwVslH4ZXFMbsKj2/6p7StbDvr3/vtpv/Z/8r5n/JPv6T3qPbiv1+SN75w037/zDrtOu3Bi
	Q6/PDuYtnG55QY96Na7/uf/D4QWv+3ePmQpXt+faMZttWsd6x0SP6UN7Q+bswJK/Ex6rBb+s
	4shXYinOSDTUYi4qTgQAD/zENlQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday, November 26, 2013 07:13:57 AM Bockholdt Arne wrote:
> Corrected the MWAIT flag for C-State C6 on Intel Avoton/Rangeley processors.
> 
> Signed-off-by: Arne Bockholdt <linux-kernel@bockholdt.com>
> ---
> 
> diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
> index cbd4e9a..92d1206 100644
> --- a/drivers/idle/intel_idle.c
> +++ b/drivers/idle/intel_idle.c
> @@ -329,7 +329,7 @@ static struct cpuidle_state atom_cstates[] __initdata = {
>  	{
>  		.enter = NULL }
>  };
> -static struct cpuidle_state avn_cstates[CPUIDLE_STATE_MAX] = {
> +static struct cpuidle_state avn_cstates[] __initdata = {

The above fixup has already been submitted in a separate patch:

	https://lkml.org/lkml/2013/11/21/177

and it has nothing to do with the purpose of your patch.

Thus please drop it from your patch.

>  	{
>  		.name = "C1-AVN",
>  		.desc = "MWAIT 0x00",
> @@ -340,7 +340,7 @@ static struct cpuidle_state avn_cstates[CPUIDLE_STATE_MAX] = {
>  	{
>  		.name = "C6-AVN",
>  		.desc = "MWAIT 0x51",
> -		.flags = MWAIT2flg(0x58) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> +		.flags = MWAIT2flg(0x51) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
>  		.exit_latency = 15,
>  		.target_residency = 45,
>  		.enter = &intel_idle },

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

