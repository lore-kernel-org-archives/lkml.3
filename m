Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633Ab3KRJa7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 04:30:59 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:22806 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab3KRJau convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 04:30:50 -0500
X-AuditID: cbfee68f-b7f836d000001b39-e4-5289de499e42
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <1384767000.26319.18.camel@kjgkr>
Subject: Re: [PATCH 2/2] f2fs: use sbi->wr_mutex for write bios
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Date: Mon, 18 Nov 2013 18:30:00 +0900
In-reply-to: <5289DC0C.30909@cn.fujitsu.com>
References: <1384765922-24028-1-git-send-email-jaegeuk.kim@samsung.com>
 <1384765922-24028-2-git-send-email-jaegeuk.kim@samsung.com>
 <5289DC0C.30909@cn.fujitsu.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t8zI13Pe51BBhf+WFs8bz/AbHFpkbvF
	nr0nWSwu75rD5sDi8f/gJGaP3Qs+M3l83iQXwBzFZZOSmpNZllqkb5fAlbGzczJrwUvmit4z
	J9kaGL8zdTFyckgImEj8+dLCCmGLSVy4t54NxBYSWMYocXSFG0zNqxfXmLsYuYDiixgl1n1c
	CNbMKyAo8WPyPRYQm1lAXWLSvEXMELawxP0Tc5kgbG2JZQtfQzW/YpR48notC0SzrsSi6bfB
	tgkL2Eu0/r4C1MDBwQbUsHm/AcQRihJv998FO05EQE3i2btLUDMzJea8ngwWZxFQlVh/9Ao7
	iM0poCNxasFGqF3LGSWuzj/HCJLgFxCVOLxwOzPEN0oSu9s72SHsY+wS7ScCIAYJSHybfIgF
	5AYJAVmJTQegyiUlDq64wTKBUXIWkpdnIXl5FpKXZyF5eQEjyypG0dSC5ILipPQiY73ixNzi
	0rx0veT83E2MkAjt38F494D1IcZkoPUTmaVEk/OBEZ5XEm9obGZkYWpiamxkbmlGmrCSOO/9
	h0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhhL9MM8ty8/Neli+JM3voJvv4hXxtu0iMTZ
	yHJY7OuMmryoYmFnpkrsxQlJyzP7RY8ZPDthU+d0NnNTw9P1GUtc7ubVLVRqMS6Y5GWv0yNQ
	b1nyJN36xQGrzRyv/hodObXXO3rW3Jmf6tNfKRww1OxPmO6+o6Z01qdfN5limu5t/Lu+WKSN
	l1WJpTgj0VCLuag4EQA2UFef5gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsVy+t9jAV3Pe51BBmenWFg8bz/AbHFpkbvF
	nr0nWSwu75rD5sDi8f/gJGaP3Qs+M3l83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5gx+80/loKHzBXz/vezNzC+Z+pi5OSQEDCRePXiGjOELSZx4d56ti5GLg4h
	gUWMEus+LgQr4hUQlPgx+R5LFyMHB7OAvMSRS9kgYWYBdYlJ8xYxQ9S/YpR48notC0S9rsSi
	6bfZQGxhAXuJ1t9XmEB62QS0JTbvNwAJCwkoSrzdf5cVxBYRUJN49u4SE8TMTIk5ryeDxVkE
	VCXWH73CDmJzCuhInFqwEWrXckaJq/PPMYIk+AVEJQ4v3A71gJLE7vZO9gmMQrOQnD0L4exZ
	SM5ewMi8ilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4np9J7WBc2WBxiFGAg1GJh1cjrDNI
	iDWxrLgy9xCjBAezkgjvihtAId6UxMqq1KL8+KLSnNTiQ4zJQJdPZJYSTc4Hppq8knhDYxMz
	I0sjMwsjE3Nz0oSVxHkPtFoHCgmkJ5akZqemFqQWwWxh4uCUamCUsk5PZ1xc51pg1p22pld7
	Z0m72hezr+9FAkKOP6qu0Vmi0Jl29vSDE9kmW1ZvNVaw586ZafOA69Gbx7vMZlTF/gqccsex
	tlKuVe7pu8tXjddli74y3nCp1m7PH8d4jcm+HlYmIeeNprXJTWS8YZw4rf4Rx96LDFufXNlr
	mLTBw+bUMVN2s2dKLMUZiYZazEXFiQDELl6RKwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gu,

2013-11-18 (월), 17:21 +0800, Gu Zheng:
> Hi Kim,
> On 11/18/2013 05:12 PM, Jaegeuk Kim wrote:
> 
> > This patch removes an unnecessary semaphore (i.e., sbi->bio_sem).
> > There is no reason to use the semaphore when f2fs submits read and write IOs.
> > Instead, let's use a write mutex and cover the sbi->bio[] by the lock.
> 
> My god, I just sent out an almost the same patch, do we have a telepathy?:)

Wow, it seems so. :)

-- 
Jaegeuk Kim
Samsung

