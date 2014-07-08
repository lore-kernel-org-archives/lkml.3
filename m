Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbaGHL7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 07:59:38 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:18927 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaGHL7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 07:59:34 -0400
X-AuditID: cbfee690-b7fb56d000003439-29-53bbdd246626
From: Namjae Jeon <namjae.jeon@samsung.com>
To: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?iso-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Ashish Sangwan <a.sangwan@samsung.com>, xfs@oss.sgi.com
Subject: [PATCH 0/3] fs: introduce IOC_MOV_DATA ioctl
Date: Tue, 08 Jul 2014 20:59:32 +0900
Message-id: <003d01cf9aa4$14386cf0$3ca946d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+aopve62ajSocMTpGwICvq23LGFw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsWyRsSkRFfl7u5gg23b1SyWTrzEbPHuc5XF
	lmP3GC1OT1jEZLHswWYWi5nz7rBZ7Nl7ksXi8q45bBatPT/ZLRb13WJ04PI4tUjCY/MKLY+m
	M0eZPVZf2Mro8X7fVTaPvi2rGD0+b5ILYI/isklJzcksSy3St0vgyvhzzbngsWzF9ts7mBoY
	J4t3MXJySAiYSPT/2MIEYYtJXLi3nq2LkYtDSGApo0Tjhd/MMEX3e7czQSQWMUr0rZoOlhAS
	+MsoMW9veRcjBwebgLbEny2iIGERAVeJeXe/M4LUMwusZZI4NfMzI0iNsICpxIZJqSA1LAKq
	EtNmHmcDsXkFLCXOXj/BBGELSvyYfI8FpJxZQEfi66QIkDCzgLzE5jVvoc5RkNhx9jUjxCo9
	iZWTzzFC1IhI7HvxjhGi5ie7xNcVYRCrBCS+TT4ENlJCQFZi0wGoMZISB1fcYJnAKDYLyeJZ
	CItnIVk8C8mCBYwsqxhFUwuSC4qT0otM9IoTc4tL89L1kvNzNzECI/b0v2cTdjDeO2B9iDEZ
	aPtEZinR5HxgxOeVxBsamxlZmJqYGhuZW5qRJqwkzqv2KClISCA9sSQ1OzW1ILUovqg0J7X4
	ECMTB6dUA2Ns9DrvQv9twVEXJGO2WloyyLZx2z15p8u11YcpIpf3bJPAtXqpa1828JdFLs3b
	urz74NXZy+45hidp1VSmcE9/k6emaZq8tzey7W3DonWpi3uf1fMe1pvA4n14OtNXmbf7mpji
	Tx1eV7vS5MiK3LggW5/okvsqW7ny155f+1Qw1kJ/zuGsX0osxRmJhlrMRcWJANJIcKDuAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgK7K3d3BBqs/yVosnXiJ2eLd5yqL
	LcfuMVqcnrCIyWLZg80sFjPn3WGz2LP3JIvF5V1z2Cxae36yWyzqu8XowOVxapGEx+YVWh5N
	Z44ye6y+sJXR4/2+q2wefVtWMXp83iQXwB7VwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pm
	YKhraGlhrqSQl5ibaqvk4hOg65aZA3SdkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4
	HiMDNJCwhjHjzzXngseyFdtv72BqYJws3sXIySEhYCJxv3c7E4QtJnHh3nq2LkYuDiGBRYwS
	faumM4MkhAT+MkrM21vexcjBwSagLfFniyhIWETAVWLe3e+MIPXMAmuZJE7N/MwIUiMsYCqx
	YVIqSA2LgKrEtJnH2UBsXgFLibPXTzBB2IISPybfYwEpZxbQkfg6KQIkzCwgL7F5zVtmiHMU
	JHacfc0IsUpPYuXkc4wQNSIS+168Y5zAKDALyaRZCJNmIZk0C0nHAkaWVYyiqQXJBcVJ6bmG
	esWJucWleel6yfm5mxjBCeGZ1A7GlQ0WhxgFOBiVeHhXHNwVLMSaWFZcmXuIUYKDWUmE98up
	3cFCvCmJlVWpRfnxRaU5qcWHGE2B/pzILCWanA9MVnkl8YbGJmZGlkbmhhZGxuZK4rwHWq0D
	hQTSE0tSs1NTC1KLYPqYODilGhhXZ56bu7zmF3/+lad5/txPhC/emP4vZuPlmrM/drz6tkXr
	SsdOr3lPEq/wTUt1emIYt9f6d+WyuetepwWe/G2pMaXhn9h70XqHKepH5nU+zgiY1rHJ/Zrg
	zuecxyx+X0zjDMkLUGg6N/XjVd21v+yWe/TGdjt8+bl/QY4Xp4FzcGAdt88tU7MQJZbijERD
	Leai4kQAfRv/XB4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For speeding non linear media editing operations, we have already implemeted
FALLOC_FL_COLLAPSE_RANGE (merged in kernel since 3.15) and 
FALLOC_FL_INSERT_RANGE (currently awaiting review).
Both of these fallocate flags are used to remove/insert data within same file.
In continuation of our effort of speeding non linear media editing
(although the use case is not limited to just media editing) we introduce here
an ioctl FS_IOC_MOV_DATA which moves arbitrary (but fs block size aligned
as of now) bytes of data from one file into other file .

The movement takes place by transfering complete extents from donor file to
receiver file and leaves a hole in the donor file at the point from where
the blocks are moved. To eliminate the hole from donor, user can call
COLLAPSE_RANGE after the ioctl is finished if contiguous file space is required.

The main data structure for this ioctl is:
struct mov_data {
       int     donor_fd;               /* fd of donor file */
       int     receiver_fd;            /* fd of receiver file */
       loff_t  donor_offset;           /* offset into donor file */
       loff_t  receiver_offset;        /* offset into receiver file */
       loff_t  length;                 /* data length to be moved */
       loff_t  moved_len;              /* data length actually moved after completion */
       int     flags;                  /* Currently unused */
};

FS_IOC_MOV_DATA will move length bytes of data from donor_fd's donor_offset
to receiver_fd's receiver_offset. The prerequisite is that there must be 
atleast length size hole present @receiver_offset.

For inserting hole within file size at receiver_offset, FALLOC_FL_INSERT_RANGE
can be used. We will shortly post new version of FALLOC_FL_INSERT_RANGE which
enables inserting hole instead of current behavior of allocating unwritten
extents. If the requirement is to create hole at the end of file, truncate(2)
will suffice.

The semantics of this ioctl are:
1) Like collapse range, offsets and length should be file system block size
   aligned.
2) In the receiver file, atleast length size hole should be present at
   receiver_offset
3) It does not change file size of any of donor or receiver file.
4) It leaves a hole at the place from where blocks are moved out in donor file.
5) Both (donor_offset + length) and (receiver_offset + length) should be within
   size of donor file and receiver file respectively.
   Only unwritten extents resides beyond file size and it does not make sense
   to transfer unwritten extents, leave apart the security issues it may raise.
6) If the range to be transfered from donor file contain any holes, they are
   replicated as it is in receiver file. It mean holes are preserved and
   the length of hole will be added to moved_len signifying that the hole range
   is succesfully transfered.

Currently, flags field is unused but could be used to expand new functionalities
in future.
Some potential enhancements could be:
1) Instead of moving data, one could use it for zero copying between 2 regular
   files.
2) Can expand it for a generic VFS interface for defragmenting files.
   Copying data from donor to receiver and than swapping their extents.
   Currently xfs has swap_extent ioctl and ext4 has move_extent ioctl.
   These two calls could additionaly go through the common interface.
3) Or it can be expanded just for swapping extents without copying.

Note: These patchse are created on source included INSERT RANGE patches.
Please Firstly Apply INSERT RANGE patches before applying IOC_MOV_DATA patches.

Namjae Jeon (3):
 fs: Add support IOC_MOV_DATA ioctl
 xfs: Add support IOC_MOV_DATA ioctl
 ext4: Add support IOC_MOV_DATA ioctl
 TODO: Add testcases in xfstests
-- 
1.7.11-rc0

