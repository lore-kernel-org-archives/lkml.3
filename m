Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750807AbbABJk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 04:40:29 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:24990 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbbABJk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 04:40:26 -0500
X-AuditID: cbfee68f-f791c6d000004834-65-54a66787f027
From: Namjae Jeon <namjae.jeon@samsung.com>
To: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com, linux-ext4 <linux-ext4@vger.kernel.org>,
        Ashish Sangwan <a.sangwan@samsung.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH v7 0/11] fs: Introduce FALLOC_FL_INSERT_RANGE for fallocate
Date: Fri, 02 Jan 2015 18:40:23 +0900
Message-id: <003e01d02670$21a8d610$64fa8230$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdAmbn5noWoxQOXAQj2al0iMc/79mA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsWyRsSkQLc9fVmIwZln1hZLJ15itnj3ucpi
	y7F7jBYz591hs9iz9ySLxeVdc9gsWnt+slss6rvF6MDhcWqRhEfTmaPMHqsvbGX0eL/vKptH
	35ZVjB6fN8kFsEVx2aSk5mSWpRbp2yVwZaybupW5YCV/xdSJDewNjDt5uhg5OCQETCQ6/md3
	MXICmWISF+6tZ+ti5OIQEljKKPHpygpmiISJxNVN+1kgEtMZJQ4/uMkI4fxllHi77TITyCQ2
	AW2JP1tEQRpEBFwl5t39DlbDLHCCUeLI91ksIAlhAW+Jp58nsoPYLAKqEr2fT4DFeQUsJd6e
	PssMYQtK/Jh8DyzOLKAlsX7ncSYIW15i85q3UBcpSOw4+5oRYpmexOVHy9kgakQk9r14B7ZY
	QuAWu8SdvuWMEMsEJL5NPsQC8bKsxKYDUHMkJQ6uuMEygVFsFpLVs5CsnoVk9SwkKxYwsqxi
	FE0tSC4oTkovMtYrTswtLs1L10vOz93ECIzP0/+e9e9gvHvA+hCjAAejEg+vwrWlIUKsiWXF
	lbmHGE2BLprILCWanA9MAnkl8YbGZkYWpiamxkbmlmZK4rwLpX4GCwmkJ5akZqemFqQWxReV
	5qQWH2Jk4uCUamDc/XabQM31hV5JSW0ibyYHzPl/Uu7qgVDDhksV6yM4H3r1FyQL8d97oV+t
	//FZUFvZEoM1B6fwsVz79STUPORt2Q+PY/kuW9oL9n877qfokasv82biXpWrCSFzAjaKvYrR
	v3Pm89Wgbwt0fmtnK8itlj7K1JQ77/qvoFyGnQ6bNfx+xGYXth1VYinOSDTUYi4qTgQAulU9
	/8oCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+xoG57+rIQg8vrjS2WTrzEbPHuc5XF
	lmP3GC1mzrvDZrFn70kWi8u75rBZtPb8ZLdY1HeL0YHD49QiCY+mM0eZPVZf2Mro8X7fVTaP
	vi2rGD0+b5ILYItqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy
	8QnQdcvMAbpHSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5ixbupW5oKV
	/BVTJzawNzDu5Oli5OSQEDCRuLppPwuELSZx4d56ti5GLg4hgemMEocf3GSEcP4ySrzddpmp
	i5GDg01AW+LPFlGQBhEBV4l5d7+D1TALnGCUOPJ9FtgkYQFviaefJ7KD2CwCqhK9n0+AxXkF
	LCXenj7LDGELSvyYfA8sziygJbF+53EmCFteYvOat8wQFylI7Dj7mhFimZ7E5UfL2SBqRCT2
	vXjHOIFRYBaSUbOQjJqFZNQsJC0LGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgTH/zPp
	HYyrGiwOMQpwMCrx8CpcWxoixJpYVlyZe4hRgoNZSYS3T25JiBBvSmJlVWpRfnxRaU5q8SFG
	U6BPJzJLiSbnA1NTXkm8obGJmZGlkbmhhZGxuZI4r5J9W4iQQHpiSWp2ampBahFMHxMHp1QD
	Y7n6jeyFlvKf3Y/lW3g+3dR/zbfhyKtlskfy52bU9P6uPpP9WqX361m3eaXT7T7G3PLT/P0y
	uGULX/WP1qyJky5yP1iz/I7Tj+5+v9Rc+Y0903I4eD5McjdxmZT36aDsyTeGDCdav7ssNGae
	GHAhOTx9xwHpoKeLl0xn5As48SW9Zb4Wf8qZn0osxRmJhlrMRcWJAAcXGe0VAwAA
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


Namjae Jeon (11):
 fs: Add support FALLOC_FL_INSERT_RANGE for fallocate
 xfs: Add support FALLOC_FL_INSERT_RANGE for fallocate
 ext4: Add support FALLOC_FL_INSERT_RANGE for fallocate
 xfsprogs: xfs_io: add finsert command for insert range via fallocate
 xfstests: generic/039: Standard insert range tests
 xfstests: generic/040: Delayed allocation insert range
 xfstests: generic/041: Multi insert range tests
 xfstests: generic/042: Delayed allocation multi insert
 xfstests: generic/043: Test multiple fallocate insert/collapse range calls
 xfstests: fsstress: Add fallocate insert range operation
 xfstests: fsx: Add fallocate insert range operation

-- 
1.7.11-rc0

