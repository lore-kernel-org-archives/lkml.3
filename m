Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbaEHKXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:23:24 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:18029 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbaEHKXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:23:21 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-4b-536b5b175d48
From: Namjae Jeon <namjae.jeon@samsung.com>
To: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ashish Sangwan <a.sangwan@samsung.com>
Subject: [PATCH v2 0/10] fs: Introduce FALLOC_FL_INSERT_RANGE for fallocate
Date: Thu, 08 May 2014 19:23:19 +0900
Message-id: <003601cf6aa7$883103b0$98930b10$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9qpxnbZQt24EFjSkK2EdLY2LQUZA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsWyRsSkRFc8OjvYYOtpLYulEy8xW2w5do/R
	Yua8O2wWe/aeZLG4vGsOm0Vrz092i0V9txgd2D1OLZLwaDpzlNlj9YWtjB59W1YxenzeJBfA
	GsVlk5Kak1mWWqRvl8CVcevME9aCz3wVy4+8ZGtg7OTpYuTkkBAwkej//JwNwhaTuHBvPZgt
	JLCUUWLP8xy4mk0P2bsYuYDi0xklVjxdwgLh/GWUONbYDZTh4GAT0Jb4s0UUpEFEwFVi3t3v
	jCA1zCCD3t/5zAhSIyzgLTH/fwpIDYuAqsS+5pusIDavgKVE5/xlULagxI/J91hAbGYBLYn1
	O48zQdjyEpvXvGWGOEhBYsfZ12AjRQT0JBacDIEoEZHY9+Id2FoJgUvsEvOv72CH2CUg8W3y
	IRaQegkBWYlNB6DGSEocXHGDZQKj2Cwkm2ch2TwLyeZZSFYsYGRZxSiaWpBcUJyUXmSqV5yY
	W1yal66XnJ+7iREYiaf/PZu4g/H+AetDjMlA6ycyS4km5wMjOa8k3tDYzMjC1MTU2Mjc0ow0
	YSVx3vRHSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGPn2cnVPLDri/fGyetiSm0/dnzc7
	vTJllutkDE6wVUhpuHMjfs2T5yFme1nKWvdKbPvy7J/RQ/XYUDunw7PCzfo2dglzSv7+Liyw
	uVzk+Iosueg8b3f1i1pLt61qEVCt04pymDBN75nHq4eNq/im6d6f8ikv6dP9+Qud1Jw76k1N
	Uq7tXV8hrcRSnJFoqMVcVJwIABb9gHHaAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsVy+t9jQV3x6Oxgg2dLlCyWTrzEbLHl2D1G
	i5nz7rBZ7Nl7ksXi8q45bBatPT/ZLRb13WJ0YPc4tUjCo+nMUWaP1Re2Mnr0bVnF6PF5k1wA
	a1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0BlK
	CmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxoxbZ56wFnzmq1h+5CVbA2Mn
	TxcjJ4eEgIlE/6aH7BC2mMSFe+vZuhi5OIQEpjNKrHi6hAXC+csocayxG6iKg4NNQFvizxZR
	kAYRAVeJeXe/M4LUMAssZZR4f+czI0iNsIC3xPz/KSA1LAKqEvuab7KC2LwClhKd85dB2YIS
	PybfYwGxmQW0JNbvPM4EYctLbF7zlhniIAWJHWdfg40UEdCTWHAyBKJERGLfi3eMExgFZiGZ
	NAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnCkP5PewbiqweIQowAH
	oxIPb4ZzVrAQa2JZcWXuIUYJDmYlEV4e/+xgId6UxMqq1KL8+KLSnNTiQ4zJQI9OZJYSTc4H
	JqG8knhDYxMzI0sjc0MLI2Nz0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamBUYVNNs21b
	/2zNxSQz83vRfKFhZybO2MX4J+Xklmj+U7bL2n78XuW6v6xcedX2rX+O5MZuNfrpb2lX6dCb
	ZP2p3NBvzrLyzEnPhZJ4/sS1Wh/5espEd8nfINbXBsc0uYvv+DFc5jBOad0+9+Tuy5F/lue+
	5m2ctURT0vz31ElF9ZOcv5SxlgsqsRRnJBpqMRcVJwIAeV+N8jgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In continuation of the work of making the process of non linear editing of
media files faster, we introduce here the new flag FALLOC_FL_INSERT_RANGE
for fallocate.

This flag will work opposite to the newly added FALLOC_FL_COLLAPSE_RANGE flag.
As such, specifying FALLOC_FL_INSERT_RANGE flag will insert zeroed-out space
in between the file within the range specified by offset and len. User can
write new data in this space. e.g. ads.
Like collapse range, currently we have the limitation that offset and len should
be block size aligned for both XFS and Ext4.

The semantics of the flag are :
1) It allocates new zeroed out on disk space of len bytes starting
   at offset byte without overwriting any existing data. All the data blocks
   from offset to EOF are shifted towards right to make space for inserting
   new blocks
2) It should be used exclusively. No other fallocate flag in combination.
3) Offset and length supplied to fallocate should be fs block size aligned
   in case of xfs and ext4.
4) Insert range does not work for the case when offset is overlapping/beyond
   i_size. If the user wants to allocate space at the end of file they are
   advised to use either ftruncate(2) or fallocate(2) with mode 0.
5) It increses the size of file by len bytes.


Namjae Jeon (10):
 fs: Add support FALLOC_FL_INSERT_RANGE for fallocate
 xfs: Add support FALLOC_FL_INSERT_RANGE for fallocate
 ext4: Add support FALLOC_FL_INSERT_RANGE for fallocate
 xfsprogs: xfs_io: add finsert command for insert range via fallocate
 xfstests: generic/027: Standard insert range tests
 xfstests: generic/028: Delayed allocation insert range
 xfstests: generic/029: Multi insert range tests
 xfstests: generic/030: Delayed allocation multi insert
 xfstests: fsstress: Add fallocate insert range operation
 xfstests: fsx: Add fallocate insert range operation

-- 
1.7.11-rc0

