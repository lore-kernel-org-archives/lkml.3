Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020AbaIDGcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 02:32:43 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:14725 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932957AbaIDGcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 02:32:41 -0400
X-AuditID: cbfee61b-f79f86d00000144c-8d-540807877e89
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, mina86@mina86.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com, k.opasiak@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v7 0/2] usb: gadget: f_fs: userspace API fixes and improvements
Date: Thu, 04 Sep 2014 08:32:16 +0200
Message-id: <1409812338-16012-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplluLIzCtJLcpLzFFi42I5/e+xoG47O0eIwcefYhazXrazWBy8X2/R
	vHg9m8XtidPYLC7vmsNmsWhZK7PF2iN32S0WHG9htXhweCe7A6fH/rlr2D3W/XnF5NG3ZRWj
	x/Eb25k8Pm+SC2CN4rJJSc3JLEst0rdL4Mp41RBX0M9X8XbCDtYGxuvcXYycHBICJhLfNm5k
	hbDFJC7cW8/WxcjFISQwnVHi3q99zBBOO5PE8bZnbCBVbAI6Elu+T2AEsUUEBCTWv7jEDlLE
	LPCAUaL91mWwImEBf4k9N5eyg9gsAqoS2xe0gNm8Aq4Se06sZ4NYJydx8thk1gmM3AsYGVYx
	iqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBAfOM+kdjKsaLA4xCnAwKvHwFrxgDxFiTSwrrsw9
	xCjBwawkwjv7LFCINyWxsiq1KD++qDQntfgQozQHi5I478FW60AhgfTEktTs1NSC1CKYLBMH
	p1QDo0hphUToY75ni8yeJy5KfPtktd2bjQd5c44esO0O1VE4aH956byGO8sb7p4vcr/Q/Zzp
	BA9rl9LmpqI5JwTy3hSY/lkZ6VTzLnrSryUT3/9ful5bSdFwTd6u4ikvp1tbmc0Niti4IvZW
	7p7w582TQwW/G8gG/JiX8d/O7q3ZhntyQo8sHu15/1WJpTgj0VCLuag4EQCFIPBTGAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains changes in FunctionFS making it easier and
safer to use. It fixes bug in endpoint files handling code, adds new
ioctl allowing to obtain endpoint descriptor, and introduces virtual
address mapping which allows to separate endpoint address space in
function from physical endpoint addresses, and introduces new endpoint
files naming convention.

Changelog:

v7:
- return proper value from ffs_epfile_ioctl() function
- remove patch "usb: gadget: f_fs: fix the redundant ep files problem"
  from this patchset because it's already in Gregs tree

v6: https://lkml.org/lkml/2014/8/25/101
- unlock spinlock before copy_to_user() call 
- remove duplicated eps_count value check
- few minor fixes

v5: https://lkml.org/lkml/2014/8/21/252
- fix typo pointed by Sergei Shtylyov

v4: https://lkml.org/lkml/2014/8/20/277
- change if() sequence into switch() statement
v3: https://lkml.org/lkml/2014/7/30/115
- move fix for the redundant ep files problem into sepatare patch
- merge user space API affecting changes into single patch
- add flag switching between old and new style API

v2: https://lkml.org/lkml/2014/7/25/296
- return proper endpont address in setup request handling
- add patch usb: gadget: f_fs: add ioctl returning ep descriptor
- add patch usb: gadget: f_fs: make numbers in ep file names the same
  as ep addresses

v1: https://lkml.org/lkml/2014/7/18/1010

Robert Baldyga (2):
  usb: gadget: f_fs: add ioctl returning ep descriptor
  usb: gadget: f_fs: virtual endpoint address mapping

 drivers/usb/gadget/function/f_fs.c  | 46 +++++++++++++++++++++++++++++++++++--
 drivers/usb/gadget/function/u_fs.h  |  2 ++
 include/uapi/linux/usb/functionfs.h |  7 ++++++
 3 files changed, 53 insertions(+), 2 deletions(-)

-- 
1.9.1

