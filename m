Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbaI2EZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 00:25:41 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:14690 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaI2EZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 00:25:39 -0400
X-AuditID: cbfee68d-f79296d000004278-33-5428df41c988
Date: Mon, 29 Sep 2014 04:25:37 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: [RFC PATCH] extcon: Fix sleeping in atomic context after
 connecting USB cable
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        =?euc-kr?Q?=C3=D6=C2=F9=BF=EC?= <cw00.choi@samsung.com>,
        Felipe Balbi <balbi@ti.com>,
        =?euc-kr?Q?=BF=EC=BB=F3=C1=A4?= <sangjung.woo@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?euc-kr?Q?=C7=D1=C1=F8=B1=B8?= <jg1.han@samsung.com>
Cc: =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20140929042230136@myungjoo.ham
Msgkey: 20140929042230136@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20140929042230136@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <368375031.68241411964736944.JavaMail.weblogic@epmlwas08a>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsWyRsSkWNfxvkaIwcn1GhaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugStj9fT57AWTVCuuH3/I2sA4RaWLkZNDSEBdYtGSk2wgtoSAicSq
	lbtZIWwxiQv31gPFuYBqljJKrDnYzgRTtH1NGwtEYg6jxPXPz5hBEiwCqhKnT6wDsjk42ATM
	Je7PCAIJCwtESTzadYcdpF5EoIlZ4vCMJlYQh1lgDaPEsdfdrBBnKEms2feKBcTmFRCUODnz
	CQvENlWgk24zQsTVJH7ueAMVl5CYNf0C1Km8EjPan0LF5SSmfV3DDGFLS5yftYER5p3F3x9D
	xfkljt3eAfWNgMTUMweharQkHmx7A1XDJ7Fm4VsWmPpdp5Yzw+y6v2UuE8wNW1uegN3ALKAo
	MaX7ITuErSXx5cc+NnS/8Aq4SRxoe8oM8ryEwEQOif3T77BOYFSahaRuFpJZs5DMQlazgJFl
	FaNoakFyQXFSepGhXnFibnFpXrpecn7uJkZgejj971nvDsbbB6wPMQpwMCrx8G5YqhEixJpY
	VlyZe4jRFBhRE5mlRJPzgUkoryTe0NjMyMLUxNTYyNzSTEmcV1HqZ7CQQHpiSWp2ampBalF8
	UWlOavEhRiYOTqkGxi2bI5remWYfmBJym035/YWszE8nLHNCjD1Dg1Y03n1faiO4/veLT0KT
	nls/+GxWmK51+WJY8b+kDvdalzDjpmdLHs0MW11dcmd2gn5qUVnetBe5hqGv5WNM2Z08Ww90
	/pMRyOhgWzO/oPenpsfErxOtrt9IaVDbf2uLShpvW2320aU+mexmSizFGYmGWsxFxYkA6v8O
	vAoDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBKsWRmVeSWpSXmKPExsVy+t/tfl3H+xohBm3dihaXd81hc2D0+LxJ
	LoAxKs0mIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2io
	kkJZYk4pUCggsbhYSd/Opii/tCRVISO/uMRWKdrQ3EjPyEDP1EjP0DjWytDAwMgUqCYhLWP1
	9PnsBZNUK64ff8jawDhFpYuRk0NIQF1i0ZKTbCC2hICJxPY1bSwQtpjEhXvrgeJcQDVzGCWu
	f37GDJJgEVCVOH1iHZDNwcEmYC5xf0YQSFhYIEri0a477CD1IgJNzBKHZzSxgjjMAmsYJY69
	7maF2KYksWbfK7ANvAKCEidnPoHapiqxauVtRoi4msTPHW+g4hISs6ZfYIWweSVmtD+FistJ
	TPu6hhnClpY4P2sDI8zVi78/horzSxy7vYMJwhaQmHrmIFSNlsSDbW+gavgk1ix8ywJTv+vU
	cmaYXfe3zGWCuWFryxOwG5gFFCWmdD9kh7C1JL782MeG7hdeATeJA21PmScwys5CkpqFpH0W
	knZkNQsYWVYxiqYWJBcUJ6VXGOsVJ+YWl+al6yXn525iBKeiZ4t3MP4/b32IUYCDUYmHd8NS
	jRAh1sSy4srcQ4wSHMxKIrwKr9VDhHhTEiurUovy44tKc1KLDzGaAqNtIrOUaHI+ME3mlcQb
	GhubmJmYWppYGJiaK4nzxt9KChISSE8sSc1OTS1ILYLpY+LglGpgrGy015mo8E5q+q1F076E
	TS/wufM83zh96elpNr18hhvsPDQjjqx0/XNfrmf7vU/8V19fnmKiHrpTYPuVJiujzW3XqjkE
	Lr8NOmjIf0BrwpO20991li7i+8Se6LU1Y231YvaVySK5hz9WLeKMuWjquln/lP5RqRtMGcwT
	6vfwNWpIt9oKrHvXocRSnJFoqMVcVJwIAMR8pPlbAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8T4PlpL011000

>   
>  Kernel built with extcon and charger-manager.
> 
> After connecting the USB cable sleeping function was called from atomic
> context:
> [   63.328648] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:586
[]
> [   63.388743] Workqueue: events max14577_muic_irq_work
> [   63.393707] [<c00167a4>] (unwind_backtrace) from [<c0012c08>] (show_stack+0x10/0x14)
> [   63.401422] [<c0012c08>] (show_stack) from [<c06232ec>] (dump_stack+0x70/0xbc)
> [   63.408625] [<c06232ec>] (dump_stack) from [<c0629d0c>] (mutex_lock_nested+0x24/0x410)
> [   63.416525] [<c0629d0c>] (mutex_lock_nested) from [<c0354474>] (regmap_read+0x30/0x60)
> [   63.424424] [<c0354474>] (regmap_read) from [<c0406b84>] (max14577_charger_get_property+0x1e4/0x250)
> [   63.433535] [<c0406b84>] (max14577_charger_get_property) from [<c0403834>] (is_ext_pwr_online+0x30/0x6c)
> [   63.442994] [<c0403834>] (is_ext_pwr_online) from [<c0404a54>] (charger_extcon_notifier+0x40/0x70)
> [   63.451934] [<c0404a54>] (charger_extcon_notifier) from [<c044cbe4>] (_call_per_cable+0x40/0x4c)
> [   63.460704] [<c044cbe4>] (_call_per_cable) from [<c0051560>] (notifier_call_chain+0x64/0x128)
> [   63.469209] [<c0051560>] (notifier_call_chain) from [<c0051640>] (raw_notifier_call_chain+0x18/0x20)
> [   63.478321] [<c0051640>] (raw_notifier_call_chain) from [<c044d0fc>] (extcon_update_state+0xa8/0x204)
> [   63.487522] [<c044d0fc>] (extcon_update_state) from [<c044e5f8>] (max14577_muic_chg_handler+0xdc/0x180)
> [   63.496897] [<c044e5f8>] (max14577_muic_chg_handler) from [<c044e924>] (max14577_muic_irq_work+0x7c/0xd8)
> [   63.506445] [<c044e924>] (max14577_muic_irq_work) from [<c004480c>] (process_one_work+0x198/0x66c)
> [   63.515385] [<c004480c>] (process_one_work) from [<c0044d4c>] (worker_thread+0x38/0x564)
> [   63.523455] [<c0044d4c>] (worker_thread) from [<c004c4ec>] (kthread+0xcc/0xe8)
> [   63.530661] [<c004c4ec>] (kthread) from [<c000f1f8>] (ret_from_fork+0x14/0x3c)
> [   63.543926] charger_manager: Set current limit of CHARGER : 450000uA ~ 450000uA
> [   63.548870] extcon-port jack: jack event CHGDET=usb
> [   63.550592] extcon-port jack: jack event CHGDET=charger
> [   64.188607] charger-manager charger-manager@0: Failed to get battery temperature
> [   64.200684] charger-manager charger-manager@0: CHARGING
> 
> The first sleeping function is is_ext_pwr_online()
> (drivers/power/charger-manager.c). The atomic context initiating the
> flow is set up in extcon_update_state() (drivers/extcon/extcon-class.c).
> 
> The extcon_update_state() uses spin locks which are not necessary
> because the function is not called from interrupt service routines.
> Instead, the extcon_update_state() is called from:
> 1. Threaded interrupt handlers.
> 2. Work queues.
> 
> Replace the spin lock with mutex and update the documentation of this
> function.

No. You've done it in the opposite way.

update_state is often called in a interrupt handler that cannot sleep.

For the context you've mentioned, we'd need workqueue invoked by
_call_per_cable or notifier callback.


Cheers,
MyungJoo

> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/extcon/extcon-class.c | 15 ++++++++-------
>  include/linux/extcon.h        |  3 ++-
>  2 files changed, 10 insertions(+), 8 deletions(-)
> 
[]
> -	spin_lock_irqsave(&edev->lock, flags);
> +	mutex_lock(&edev->lock);
[]
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
