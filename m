Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbaHUMJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 08:09:45 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:38323 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196AbaHUMJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 08:09:43 -0400
X-AuditID: cbfee61b-f79f86d00000144c-3c-53f5e185bde4
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, mina86@mina86.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com, k.opasiak@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v5 0/3] usb: gadget: f_fs: userspace API fixes and improvements
Date: Thu, 21 Aug 2014 14:09:16 +0200
Message-id: <1408622959-4096-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjluLIzCtJLcpLzFFi42I5/e+xgG7rw6/BBmcWmFvMetnOYnHwfr1F
	8+L1bBa3J05js7i8aw6bxaJlrcwWa4/cZbdYcLyF1eLB4Z3sDpwe++euYfdY9+cVk0ffllWM
	HsdvbGfy+LxJLoA1issmJTUnsyy1SN8ugSvj3dXzTAXnuSs+LJ3A3MB4jLOLkZNDQsBEYs3K
	iYwQtpjEhXvr2boYuTiEBBYxSux/cpMVwmlnklj9t5kFpIpNQEdiy/cJYB0iAgIS619cYgcp
	YhZ4wCjRfusyG0hCWMBfYnfzTmYQm0VAVWL/rmWsIDavgIvEj3VdbBDr5CROHpvMOoGRewEj
	wypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4NB5Jr2DcVWDxSFGAQ5GJR5eCbWvwUKsiWXF
	lbmHGCU4mJVEeM+cBgrxpiRWVqUW5ccXleakFh9ilOZgURLnPdhqHSgkkJ5YkpqdmlqQWgST
	ZeLglGpg9Lj68MvSBk1WETOhKq+0dT98UgMiX/C//5hxNfixhECu7p+ldRZv265HeXgkdZ+/
	7zxf7mom2/zLB8UqdGJKRL9w5a1y/CHNU1/acyli5699yzP185XXLGBU3FXy6V3FGeMd579J
	3sr7VVSxuG/F+vA83e9ZN4X/FNybx8I7Z9U/LemZ72y0lViKMxINtZiLihMBWdIXpBkCAAA=
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

v5:
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

Robert Baldyga (3):
  usb: gadget: f_fs: fix the redundant ep files problem
  usb: gadget: f_fs: add ioctl returning ep descriptor
  usb: gadget: f_fs: virtual endpoint address mapping

 drivers/usb/gadget/function/f_fs.c  | 111 +++++++++++++++++++++++++++++++-----
 drivers/usb/gadget/function/u_fs.h  |   4 ++
 include/uapi/linux/usb/functionfs.h |   7 +++
 3 files changed, 109 insertions(+), 13 deletions(-)

-- 
1.9.1

