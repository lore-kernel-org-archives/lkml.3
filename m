Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab3KYOyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:54:40 -0500
Received: from mout.gmx.net ([212.227.15.19]:49674 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756617Ab3KYOyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 09:54:38 -0500
Message-ID: <529364AC.8000305@gmx.de>
Date: Mon, 25 Nov 2013 15:54:36 +0100
From: Michael Lawnick <ml.lawnick@gmx.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20131118 Thunderbird/17.0.11
MIME-Version: 1.0
To: Mike Looijmans <mike.looijmans@topic.nl>
CC: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-mux-pca954x: Disable mux after 200ms timeout
References: <1385387037-3710-1-git-send-email-mike.looijmans@topic.nl>
In-Reply-To: <1385387037-3710-1-git-send-email-mike.looijmans@topic.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:lG3Blr1Mgzr4m02fu7WrB/pj56ZJtQDHcFHxHlt5hBfcOITzRBw
 ekSFusVHXtb3HMS1O54dXYapilOmB2Nsb3RKJF+PNTwYJTplhkhY8AiBmuz43FX7nF15/pG
 zEGSpeYFOe+b8IJV/VALKXMdc+Zx9PDsyhhymDhwbSW6PvFbA9GyRKPA+Fp+Y2MkcISIx2p
 5YDpia0nH17e4mojIJrQA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am 25.11.2013 14:43, schrieb Mike Looijmans:
> Leaving the mux enabled causes needless I2C traffic on the downstream
> bus. De-selecting after every request causes excess I2C traffic and
> switching.
>
> This patch implements a hybrid solution: After 200ms of inactivity,
> the mux is disabled.
...

Have you checked against behavior on cascaded muxes?
At least your desired timing will not look as expected.
200 ms: disable mux1
201 ms: enable mux1 - disable mux2
202 ms: enable mux2 - disable mux3
401 ms: disable mux1
402 ms: enable mux1 - disable mux2
602 ms: disable mux1
And on full second temperature sensor behind mux3 is read again ...

KR
Michael



