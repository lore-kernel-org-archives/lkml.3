Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbaLSHm2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 02:42:28 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:46549 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaLSHm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 02:42:26 -0500
X-AuditID: cbfee68f-f791c6d000004834-e0-5493d6e04447
Date: Fri, 19 Dec 2014 07:41:15 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH RESEND v2 02/10] power: charger-manager: Use
 power_supply_changed() not private uevent.
To: =?utf-8?Q?=EC=9D=B4=EC=A2=85=ED=99=94?= <jonghwa3.lee@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "sre@kernel.org" <sre@kernel.org>,
        "dbaryshkov@gmail.com" <dbaryshkov@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "anton@enomsg.org" <anton@enomsg.org>, "pavel@ucw.cz" <pavel@ucw.cz>,
        =?utf-8?Q?=EC=B5=9C=EC=B0=AC=EC=9A=B0?= <cw00.choi@samsung.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20141219074108408@myungjoo.ham
Msgkey: 20141219074108408@myungjoo.ham
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20141219074108408@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <1443120167.38671418974875751.JavaMail.weblogic@epmlwas08d>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsWyRsSkRPfBtckhBo3/zS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGpXVn2Aom8FTM+XyYsYHxCXcXIyeHkIC6xKIlJ9lAbAkBE4m1
	P+8xQthiEhfurQeKcwHVLGWUeLP/FhNM0eGJ05ggEnMYJc43NYJ1sAioSnw/vQXI5uBgE9CT
	mPk5GcQUFsiW2PQrGKRcRKCTUeLCmiZWEIdZ4CyTxO2WPywQVyhJrNn3CszmFRCUODnzCQvE
	MlWJWa27GCHiahIXn7RBHSEucWHuJXYIm1diRvtTqHo5iWlf1zBD2NIS52dtgPtm8ffHUHF+
	iWO3d0DNEZCYeuYg2M0SAloSX/bkQ4T5JNYsfMsCU77r1HJmmFX3t8yFapWQ2NryhBXEZhZQ
	lJjS/ZAdZAyzgKbE+l366D7hFXCXmLz/OjPI6xICUzkkVt59zTSBUWkWkrpZSEbNQhiFrGQB
	I8sqRtHUguSC4qT0ImO94sTc4tK8dL3k/NxNjMC0cPrfs/4djHcPWB9iFOBgVOLhfVA8OUSI
	NbGsuDL3EKMpMJImMkuJJucDk09eSbyhsZmRhamJqbGRuaWZkjjvQqmfwUIC6YklqdmpqQWp
	RfFFpTmpxYcYmTg4pRoYuTMOt+WfePH1PN/H61tf+78zcT15ZsLZBxOmrLAwaIi9+2fhzC8z
	Lnl0is6a7PxstvJfr0XHAs/5OrHPm/TzLv/eHVMf1z41m7ygipnjtORJ7sDiT/btd9yj+3nW
	lyr833rtqsthGfY/Nmc7P3281Jp983JiuGCa5+TJbEfWnNHkLLNT3lqfyazEUpyRaKjFXFSc
	CAARQDaGBgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsVy+t/tft2T1yaHGOxfJ25xedccNgdGj8+b
	5AIYo9JsMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CG
	KimUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslaINzY30jAz0TI30DI1jrQwNDIxMgWoS0jIu
	rTvDVjCBp2LO58OMDYxPuLsYOTmEBNQlFi05yQZiSwiYSByeOI0JwhaTuHBvPVCcC6hmDqPE
	+aZGRpAEi4CqxPfTW4BsDg42AT2JmZ+TQUxhgWyJTb+CQcpFBDoZJS6saWIFcZgFzjJJ3G75
	wwKxTElizb5XYDavgKDEyZlPWCCWqUrMat3FCBFXk7j4pA3qCHGJC3MvsUPYvBIz2p9C1ctJ
	TPu6hhnClpY4P2sDI8zRi78/horzSxy7vQNqjoDE1DMHwW6WENCS+LInHyLMJ7Fm4VsWmPJd
	p5Yzw6y6v2UuVKuExNaWJ6wgNrOAosSU7ofsIGOYBTQl1u/SR/cJr4C7xOT915knMMrOQpKa
	haR7FkI3spIFjCyrGEVTC5ILipPSK0z0ihNzi0vz0vWS83M3MYJT0LMlOxgbLlgfYhTgYFTi
	4X1QPDlEiDWxrLgy9xCjBAezkgiv43GgEG9KYmVValF+fFFpTmrxIUZTYJRNZJYSTc4Hpse8
	knhDY2MTMxNTSxMLA1NzJXHe/+dyQ4QE0hNLUrNTUwtSi2D6mDg4pRoYN7Eoq09Ka1Er/1Sz
	1cDj1+/5aTNzFe6/VJZ7VTVv3/b9UfMYv3DPNpnNNHnOJ0uVJjcVGeuSw++CW+LsH3O22a/+
	ceLZmxqlfXGC83wk1ZZ3Lrhntei4wpoDPerzfJu05H3vTeZafGvlEVnR4Bn7OzmiQza7tWff
	6dhzO2Pl64ULX6d4Hdx8T4mlOCPRUIu5qDgRANsHwW5XAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBJ7gaKi020660

>   
>  Whenever battery status is changed, charger manager tries to trigger uevent
> through private interface. This patch modifies it to use power_supply_changed()
> since it belongs to power supply subsystem.
> 
> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>

The original uevent_notify() has two additional mechanisms:
C1. Save events in suspend-again context and show them up at wakeup.
C2. If the new event is a duplicated event, ignore it.

Questions:
Q1. Have you checked if C1 is met with the modification? Besides, have
you made it sure that the modification won't change the behavior of
suspend-again context? (whether "theoretical" or "experimental")
Q2. Do you still support C2?
  For example, if we have notifited the user that we are charging
  30 seconds ago, we should never bother the user with another message
  that declares that it is charging unless we have notified that
  we are not charging since then.

Cheers,
MyungJoo.

> ---
>  drivers/power/charger-manager.c |   91 +++++----------------------------------
>  1 file changed, 11 insertions(+), 80 deletions(-)
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
