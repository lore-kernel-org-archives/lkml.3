Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbaKXGQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 01:16:29 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:52327 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaKXGQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 01:16:27 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-96-5472cd38bd47
From: Namjae Jeon <namjae.jeon@samsung.com>
To: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>,
        xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
        Ashish Sangwan <a.sangwan@samsung.com>
Subject: [PATCH v6 0/10] fs: Introduce FALLOC_FL_INSERT_RANGE for fallocate
Date: Mon, 24 Nov 2014 15:16:23 +0900
Message-id: <002901d007ae$2c279580$8476c080$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdAHq+0B9RR8g/eTQfamwv0ozVUA5A==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsWyRsSkUNfibFGIwcaf0hZLJ15itthy7B6j
	xcx5d9gs9uw9yWJxedccNovWnp/sFov6bjE6sHucWiTh0XTmKLPH6gtbGT36tqxi9Pi8SS6A
	NYrLJiU1J7MstUjfLoEr48myecwFd/gqdh5ewdrA+I27i5GTQ0LARGLD73uMELaYxIV769m6
	GLk4hASWMkqc2HyWDabo6cz7LBCJRYwS7Y8vs4AkhAT+Mkqs3VXXxcjBwSagLfFniyhIWETA
	VWLe3e+MIPXMIIMuPn4CtkFYwFti0/IrjCD1LAKqEn27xUDCvAKWEkuaprBA2IISPybfA7OZ
	BbQk1u88zgRhy0tsXvOWGeIeBYkdZ18zQuzSk/i5dw5UvYjEvhfvwPZKCJxjl/j07BNYM4uA
	gMS3yYdYQPZKCMhKbDoANUdS4uCKGywTGMVmIVk9C8nqWUhWz0KyYgEjyypG0dSC5ILipPQi
	E73ixNzi0rx0veT83E2MwFg8/e/ZhB2M9w5YH2IU4GBU4uH9sLEoRIg1say4MvcQoynQRROZ
	pUST84ERn1cSb2hsZmRhamJqbGRuaaYkzvta6mewkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6p
	BsblK/69vv9U5XbgmruTmHlsFol2TW898eTxGvvmlRci5jzK4f632OTp7e/KB25f/s9l5Wxa
	25vyLXh5q7P5yullLfwdWj4h+Y8PvYq6u7G/fM+EW1+jT//9li3ZWKszOzJhrVZgtn2dxefF
	3OWcicU1jItfn8piv7N0W+I2Tj/vqxqfZzP8cAtSYinOSDTUYi4qTgQAMJA/cMACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsVy+t9jAV2Ls0UhBstbRSyWTrzEbLHl2D1G
	i5nz7rBZ7Nl7ksXi8q45bBatPT/ZLRb13WJ0YPc4tUjCo+nMUWaP1Re2Mnr0bVnF6PF5k1wA
	a1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0BlK
	CmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxowny+YxF9zhq9h5eAVrA+M3
	7i5GTg4JAROJpzPvs0DYYhIX7q1n62Lk4hASWMQo0f74MlhCSOAvo8TaXXVdjBwcbALaEn+2
	iIKERQRcJebd/c4IUs8ssJRR4uLjJ4wgCWEBb4lNy68wgtSzCKhK9O0WAwnzClhKLGmawgJh
	C0r8mHwPzGYW0JJYv/M4E4QtL7F5zVtmiHsUJHacfc0IsUtP4ufeOVD1IhL7XrxjnMAoMAvJ
	qFlIRs1CMmoWkpYFjCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYIj/Zn0DsZVDRaHGAU4
	GJV4eGesLwoRYk0sK67MPcQowcGsJMJ79l9hiBBvSmJlVWpRfnxRaU5q8SFGU6BHJzJLiSbn
	A5NQXkm8obGJmZGlkbmhhZGxuZI4742buSFCAumJJanZqakFqUUwfUwcnFINjLpfTSOOMW5O
	WaC6r/zl5dQrJx7NUdgwYbfQA+53Wyq2XA4rPOzr8Utuwr3A/DlXnsmuVw3b/rDjrNqJBalr
	Tdxqw95WOv0Q/GnQt1f/gbipo9/D3PObJwq73a/T8DTpW5PeLZPX/r3Gl/XWDav6z/H2m/N+
	p650emLDHBve9NXcTsv+eQR3txJLcUaioRZzUXEiAOt2tfIKAwAA
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
 xfstests: generic/038: Standard insert range tests
 xfstests: generic/039: Delayed allocation insert range
 xfstests: generic/040: Multi insert range tests
 xfstests: generic/041: Delayed allocation multi insert
 xfstests: fsstress: Add fallocate insert range operation
 xfstests: fsx: Add fallocate insert range operation

-- 
1.7.11-rc0

