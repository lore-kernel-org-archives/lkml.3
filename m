Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbaHHFF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 01:05:29 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:25531 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbaHHFFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 01:05:25 -0400
X-AuditID: cbfee691-b7f306d000003d81-93-53e45a93d8aa
From: Namjae Jeon <namjae.jeon@samsung.com>
To: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
        =?iso-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH v5 0/10] fs: Introduce FALLOC_FL_INSERT_RANGE for fallocate
Date: Fri, 08 Aug 2014 14:05:23 +0900
Message-id: <004101cfb2c6$5c0194f0$1404bed0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+yvdpLZZhppUsVRoavl1NNMg7M+A==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsWyRsSkSHdy1JNgg4WdGhbvPldZbDl2j9Fi
	2YPNLBYz591hs9iz9ySLxeVdc9gsWnt+slss6rvF6MDhcWqRhEfTmaPMHqsvbGX0eL/vKpvH
	501yAaxRXDYpqTmZZalF+nYJXBnHG66zFdzhq7j65wFzA+M37i5GTg4JAROJ2c0rmSFsMYkL
	99azdTFycQgJLGWU2DvtOCNM0eP7x6ESixgl2j+dYQFJCAn8ZZSY8FKoi5GDg01AW+LPFlGQ
	sIiAq8S8u9/BepkF7jBK/FpjDGILC3hLrNz7hxXEZhFQldi9cRLYGF4BS4n3l7pZIWxBiR+T
	77GAjGQW0JH4OikCYoy8xOY1b6HuVJDYcfY1I8QqPYlJN45DrRKR2PfiHSPImRICl9glHi38
	wAyxS0Di2+RDYDMlBGQlNh2AmiMpcXDFDZYJjGKzkGyehbB5FpLNs5BsWMDIsopRNLUguaA4
	Kb3IVK84Mbe4NC9dLzk/dxMjMB5P/3s2cQfj/QPWhxiTgbZPZJYSTc4HxnNeSbyhsZmRhamJ
	qbGRuaUZacJK4rzpj5KChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTAyTThwanmcw8+AJvd3
	kwLEWWrY456/O75/3dbDrNt/zdnEJ8d46o9MzLmY+zGRR3Y16iybfEzHp1pqV1w1e9I1hl3d
	QRbHEu5WBvvek+qYE3Mv5C1P5sWd/sITVsVue736+JrZft8uhdZdPWLze3WDzLNLW0O3SSk0
	RDbwec3pubqez3Sx4fzbSizFGYmGWsxFxYkAcki6tN0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t9jAd3JUU+CDfZ3KFi8+1xlseXYPUaL
	ZQ82s1jMnHeHzWLP3pMsFpd3zWGzaO35yW6xqO8WowOHx6lFEh5NZ44ye6y+sJXR4/2+q2we
	nzfJBbBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl
	5gCdoqRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMON5wna3gDl/F1T8P
	mBsYv3F3MXJySAiYSDy+f5wNwhaTuHBvPZDNxSEksIhRov3TGRaQhJDAX0aJCS+Fuhg5ONgE
	tCX+bBEFCYsIuErMu/udEcRmFrjDKPFrjTGILSzgLbFy7x9WEJtFQFVi98ZJYGN4BSwl3l/q
	ZoWwBSV+TL7HAjKSWUBH4uukCIgx8hKb17xlhjhHQWLH2deMEKv0JCbdOA61SkRi34t3jBMY
	BWYhmTQLYdIsJJNmIelYwMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM42p9J72Bc1WBx
	iFGAg1GJh1eg+3GwEGtiWXFl7iFGCQ5mJRHems9AId6UxMqq1KL8+KLSnNTiQ4ymQH9OZJYS
	Tc4HJqK8knhDYxMzI0sjc0MLI2NzJXHeg63WgUIC6YklqdmpqQWpRTB9TBycUg2MU1vqebnM
	382csyAzL9Vb6/jUFRdeKAVxzfVxCvrkOc/0a//+Dccn8yrNDT269mDsGfZoJdkz9r8mRRwx
	/PpX9c7TjAUzb5kf36XqpiPGfPXq+zX/ZFz0yz5xer15dzTOukDmcA73BoOvrB+Np948Yt2s
	/Svid0y6yVELcZ4v32UN2/Jfah6UU2Ipzkg01GIuKk4EAHwNum8MAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In continuation of the work of making the process of non linear editing of
media files faster, we introduce here the new flag FALLOC_FL_INSERT_RANGE
for fallocate.

This flag will work opposite to the FALLOC_FL_COLLAPSE_RANGE flag.
As such, specifying FALLOC_FL_INSERT_RANGE flag will create new space inside file
by inserting a hole within the range specified by offset and len. 
User can write new data in this space. e.g. ads.
Like collapse range, currently we have the limitation that offset and len should
be block size aligned for both XFS and Ext4.

The semantics of the flag are :
1) It creates space within file by inserting a hole of  len bytes starting
   at offset byte without overwriting any existing data. All the data blocks
   from offset to EOF are shifted towards right to make hole space.
2) It should be used exclusively. No other fallocate flag in combination.
3) Offset and length supplied to fallocate should be fs block size aligned
   in case of xfs and ext4.
4) Insert range does not work for the case when offset is overlapping/beyond
   i_size. If the user wants to insert space at the end of file they are
   advised to use either ftruncate(2) or fallocate(2) with mode 0.
5) It increses the size of file by len bytes.


Namjae Jeon (10):
 fs: Add support FALLOC_FL_INSERT_RANGE for fallocate
 xfs: Add support FALLOC_FL_INSERT_RANGE for fallocate
 ext4: Add support FALLOC_FL_INSERT_RANGE for fallocate
 xfsprogs: xfs_io: add finsert command for insert range via fallocate
 xfstests: generic/029: Standard insert range tests
 xfstests: generic/030: Delayed allocation insert range
 xfstests: generic/031: Multi insert range tests
 xfstests: generic/032: Delayed allocation multi insert
 xfstests: fsstress: Add fallocate insert range operation
 xfstests: fsx: Add fallocate insert range operation

-- 
1.7.11-rc0

