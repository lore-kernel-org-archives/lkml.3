Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038AbaCVWDd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 18:03:33 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:22154 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaCVWDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 18:03:31 -0400
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-15; format=flowed
X-AuditID: cbfec37a-b7fc06d00000555a-e0-532e08b2bfa0
Message-id: <532E08AF.5030008@samsung.com>
Date: Sat, 22 Mar 2014 16:03:27 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
To: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
        m.chehab@samsung.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: Re: [PATCH] media: em28xx-video - change em28xx_scaler_set() to use
 em28xx_reg_len()
References: <1395435890-15100-1-git-send-email-shuah.kh@samsung.com>
 <532D82C9.6010401@googlemail.com> <532DAAD0.6060209@samsung.com>
 <532DCB06.9040601@googlemail.com>
In-reply-to: <532DCB06.9040601@googlemail.com>
Content-transfer-encoding: 8bit
X-Originating-IP: [105.144.134.241]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsVy+t9hX91NHHrBBtPeSFlsnf2Z2eLyrjls
	Fj0btrJafP3p4MDisXPWXXaPpxMms3t83iQXwBzFZZOSmpNZllqkb5fAlfH76ibmgl72ig1v
	7jI3MF5j7WLk5JAQMJG4va6FEcIWk7hwbz1bFyMXh5DAMkaJzYsamEASvAKCEj8m32PpYuTg
	YBawkTg4Pw2ippdJ4u36yUwQzjZGiY9H50I1aElMenmABcRmEVCVaOqZBLaBTUBd4vPrHewg
	tpCAnETTktXMILaoQITEq7MTwepFBGIk2qa3gdUwC4RIrF5zDKxXWCBe4v7xZmaIZasZJb62
	rAAr4hTQkzj5sJkNokFe4uCV5ywQC5Ql/lw+xQTxmrLE8ekH2CcwisxC8tAshIdmIelewMi8
	ilGstDi5oDgpPbXCUK84Mbe4NC9dLzk/dxMjJCqqdjDe+WpziFGAg1GJh/fEJ91gIdbEsuLK
	3EOMEhzMSiK8LUx6wUK8KYmVValF+fFFpTmpxYcYmTg4pRoYK8zFfh8wttHrasoqcJqdHhHp
	3xoUU73Tmn+dd29C3uSX/qetJbl+ibk3Bpyr94o4sMRhw8n77PanOV+afcjzeyLouOT34e4J
	IbeebfnuJr11nZV7y+ps63XR1RmyguIdS0IOGUe/nbvtdc2XA4Vqstt+nsg9cHT2pFYRm07/
	Mj3FTWf5YpiUWIozEg21mIuKEwGF3rMhaAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2014 11:40 AM, Frank Schäfer wrote:
>
> I'm more concerned about the fact that readers of the code could think
> that this is a write with a variable length, while the length is
> actually always the same.

Fair enough.

>
> em28xx_reg_len() is a somewhat dirty hack for vidioc_[g,s]_register
> debugging ioctls only.

I didn't realize that. In that case, it doesn't make sense to propagate 
the change to non-debug code. This patch can be dropped. I thought 
em28xx_reg_len() is good example of finding register length for these 
registers.

> Btw, what happens when you try to compile the code with this patch
> applied and CONFIG_VIDEO_ADV_DEBUG disabled ? ;-)

CONFIG_VIDEO_ADV_DEBUG is disabled in my config.

-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
