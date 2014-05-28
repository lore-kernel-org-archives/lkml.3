Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbaE1Gws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 02:52:48 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:52251 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbaE1Gwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 02:52:46 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-2a-538587bc0b13
From: Heesub Shin <heesub.shin@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Colin Cross <ccross@android.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Mitchel Humpherys <mitchelh@codeaurora.org>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        Sunghwan Yun <sunghwan.yun@samsung.com>,
        Dongjun Shin <d.j.shin@samsung.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Heesub Shin <heesub.shin@samsung.com>
Subject: [PATCH v2 0/9] staging: ion: system heap and page pool fixes
Date: Wed, 28 May 2014 15:52:51 +0900
Message-id: <1401259980-26927-1-git-send-email-heesub.shin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com>
References: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHIsWRmVeSWpSXmKPExsVy+t8zXd097a3BBlfPSlq8/3ufzWL7xm+s
	Fi8PaVqcuFhrcfDDfRaLPWd+sVs0L17PZnFw9hImizO/dS0u75rDZrF2/jY2ixuTCy1Odyxi
	deD12LZ7G6vH5b5eJo97+w6zeOycdZfd4861PWwe++euYffo27KK0ePzJrkAjigum5TUnMyy
	1CJ9uwSujJuTZjEVzGaveHrnG1sD41PWLkYODgkBE4k1n8u7GDmBTDGJC/fWs3UxcnEICSxj
	lFg7Zw07RMJEYtf1acwQiUVAiRszWEESQgLtTBIrdzCBDGIT0JY4tC0YJCwiYCzRf3YWO0g9
	s8BhZomuWWvZQBLCAq4SOxqmMIPYLAKqEgePnAZbwCvgLjFh319GiGVyEiePTQabzyngITHx
	yRwWiF3uErc3PgS7TkLgHrvExZXvWSEGCUh8m3yIBeIbWYlNB5gh5khKHFxxg2UCo/ACRoZV
	jKKpBckFxUnpRaZ6xYm5xaV56XrJ+bmbGCFxM3EH4/0D1ocYk4HGTWSWEk3OB8ZdXkm8obGZ
	kYWpiamxkbmlGWnCSuK86Y+SgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUw1vplnbHwnHR1
	38xVrHO2cW1t3t44zfvKyl+LsiKXRPTuFOwssmz0kL/OosrZ8UX2/SvXTAv74HjnddM/1z77
	rLH5+Zccs+PdZ5O2XPjctet1yLT53RcX/lc+2ch5QWXFNn7uVfe+XpnKyfBbZHEGm9qXDJ8k
	dq3Fd7dyzmHbobecxaAzVynATomlOCPRUIu5qDgRADpGzRexAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jAd097a3BBodXiVq8/3ufzWL7xm+s
	Fi8PaVqcuFhrcfDDfRaLPWd+sVs0L17PZnFw9hImizO/dS0u75rDZrF2/jY2ixuTCy1Odyxi
	deD12LZ7G6vH5b5eJo97+w6zeOycdZfd4861PWwe++euYffo27KK0ePzJrkAjqgGRpuM1MSU
	1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoIOVFMoSc0qBQgGJ
	xcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBk3J81iKpjNXvH0zje2BsanrF2MnBwSAiYS
	u65PY4awxSQu3FvP1sXIxSEksIhRYu2NGWBFQgLtTBIrdzB1MXJwsAloSxzaFgwSFhEwlug/
	O4sdpJ5Z4DCzRNestWwgCWEBV4kdDVPAhrIIqEocPHKaHcTmFXCXmLDvLyPEMjmJk8cmg83n
	FPCQmPhkDgvELneJ2xsfsk1g5F3AyLCKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzgun0nv
	YFzVYHGIUYCDUYmH98DilmAh1sSy4srcQ4wSHMxKIrw3C1uDhXhTEiurUovy44tKc1KLDzEm
	A101kVlKNDkfmDLySuINjU3MjCyNzIxNzI2NSRNWEuc92GodKCSQnliSmp2aWpBaBLOFiYNT
	qoFRd+qMvbOqZHsqX2bW3puwfXmD9s1dCz92bj1fLmks0nKj7v2qPwqCfJKehptPH+IVNJ+Z
	M3vDh6QKheqIRnlDZwVBI9PshjSfM6nCEufv7o/8rxOhN3FBA0/ifJF38+Ijn89V/ZCiddYw
	8sDeg45vd94RbA8V2x53VvZE5bLIVRHs4f9fVPkqsRRnJBpqMRcVJwIAGiiWRA8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is my patchset with some modification, hoping reviews or comments
from you guys.

v2:
 o No changes in the code, just reworded changelog
 o Reorder patch 

Heesub Shin (9):
  staging: ion: tidy up a bit
  staging: ion: simplify ion_page_pool_total()
  staging: ion: remove struct ion_page_pool_item
  staging: ion: use compound pages on high order pages for system heap
  staging: ion: remove order from struct page_info
  staging: ion: remove struct page_info
  staging: ion: remove order argument from free_buffer_page()
  staging: ion: shrink highmem pages on kswapd
  staging: ion: optimize struct ion_system_heap

 drivers/staging/android/ion/ion_page_pool.c   |  49 ++++-------
 drivers/staging/android/ion/ion_priv.h        |   2 +-
 drivers/staging/android/ion/ion_system_heap.c | 121 ++++++++++----------------
 3 files changed, 67 insertions(+), 105 deletions(-)

-- 
1.9.1

