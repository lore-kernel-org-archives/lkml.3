Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934829Ab3BTIFO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 03:05:14 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:61861 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934800Ab3BTIFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 03:05:12 -0500
X-AuditID: cbfee691-b7f556d000001a24-a6-512483b63da0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>
Cc: "'Samuel Ortiz'" <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <002601ce0f30$d6b81c40$842854c0$%han@samsung.com>
 <002c01ce0f31$48d55e00$da801a00$%han@samsung.com>
 <20130220073044.GB2648@core.coreip.homeip.net>
In-reply-to: <20130220073044.GB2648@core.coreip.homeip.net>
Subject: RE: [PATCH 07/11] mfd: menelaus: use devm_request_irq() and
 devm_kzalloc()
Date: Wed, 20 Feb 2013 17:05:10 +0900
Message-id: <000801ce0f41$00e79170$02b6b450$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4PPDRJvC5D59LuTUGx9e1qSg5RlAABCMUQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zY91tzSqBBq/3S1hc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MA7PvsRc8ZK94tuUxSwNjK1sXIweHhICJxNJraV2MnECmmMSF
	e+uBwlwcQgLLGCUm/H/BCpEwkVjT2w2VWMQoca31GhtIQkhgNpNEU4MEiM0moCbx5cthdpCh
	IgKGEjPWVIGEmQXyJL4takLofT3rHlgvp4C1xIPeKewgtrBAqMTVS3dYQHpZBFQlrvz1Awnz
	CthKtD8+zAhhC0r8mHyPBWKmlsT6nceZIGx5ic1r3jJD/KIu8eivLkhYRMBIYsaTRqgSEYl9
	L94xgpwgITCPXeLMuyvMIAkWAQGJb5MPsUD0ykpsOsAM8a6kxMEVN1gmMErMQrJ5FpLNs5Bs
	noVkxQJGllWMoqkFyQXFSelFpnrFibnFpXnpesn5uZsYIVE1cQfj/QPWhxiTgdZPZJYSTc4H
	RmVeSbyhsbGJmYmpibmlqbkpacJK4rzyl2QChQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTAa
	L5i83zxBOzZd9vPJtW37sha2R04V9vG2vq1cuOeipU56BzNTisOuPoccpRsbC2tYGRZHSyf0
	TJrq0RfqL/qrbbHBG9ZqK7uydI0JT3/f/cr1pTAk6IxQwVvn4ztfGU5WOJLzofIUt+G+K39j
	DbXEyvZq13H/fS8zVaXM8fA+96yPnotfMiixFGckGmoxFxUnAgACsoamwAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgO62ZpVAgwdbRSwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxoHZ99gLHrJXPNvymKWB
	sZWti5GTQ0LARGJNbzeULSZx4d56IJuLQ0hgEaPEtdZrYAkhgdlMEk0NEiA2m4CaxJcvh9m7
	GDk4RAQMJWasqQIJMwvkSXxb1ITQ+3rWPbBeTgFriQe9U9hBbGGBUImrl+6wgPSyCKhKXPnr
	BxLmFbCVaH98mBHCFpT4MfkeC8RMLYn1O48zQdjyEpvXvGUGaZUQUJd49FcXJCwiYCQx40kj
	VImIxL4X7xgnMArNQjJpFpJJs5BMmoWkZQEjyypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M
	4Kh9JrWDcWWDxSFGAQ5GJR5ejfnKgUKsiWXFlbmHGCU4mJVEeJudVAKFeFMSK6tSi/Lji0pz
	UosPMSYD/TmRWUo0OR+YUPJK4g2NTcyMLI3MLIxMzM1JE1YS52U89SRASCA9sSQ1OzW1ILUI
	ZgsTB6dUA6OM/55O1bOnTn+vyF631HyzZIXKrvaUA5P6ZAPql0/peHJ6F8MjwUzxWfNfcqXN
	EQm6YvLRUTimR9LlWk+S0nOTz1P3Ze9NttyplLqoeqP5qe1i1+58Kw/pjz15a1//E2mnd9mt
	b7Y6O8TvUXq5bEl3Z6dX8j7v+Zw9XZuMH79v2aqrv43ZY5ISS3FGoqEWc1FxIgCLE2nAHgMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 20, 2013 4:31 PM, Dmitry Torokhov wrote:
> 
> Hi Jongoo,
> 
> On Wed, Feb 20, 2013 at 03:12:38PM +0900, Jingoo Han wrote:
> > Use devm_request_irq() and devm_kzalloc() to make cleanup paths
> > more simple.
> >
> 
> ...
> 
> > @@ -1269,9 +1266,7 @@ static int __exit menelaus_remove(struct i2c_client *client)
> >  {
> >  	struct menelaus_chip	*menelaus = i2c_get_clientdata(client);
> >
> > -	free_irq(client->irq, menelaus);
> >  	flush_work(&menelaus->work);
> > -	kfree(menelaus);
> >  	the_menelaus = NULL;
> >  	return 0;
> 
> This conversion is certainly wrong - you really want to disable IRQ and
> then wait for the scheduled work to finish before freeing memory. Here
> you flush work but nothing stops IRQ from firing and scheduling that
> work again.

Yes, you're right. 
I will use devm_free_irq() before flush_work().

> 
> Please, be *extra* careful with devm_request_irq() conversions.
> 
> Thanks.
> 
> --
> Dmitry

