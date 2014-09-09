Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbaIIGXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 02:23:32 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:28303 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbaIIGXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 02:23:30 -0400
X-AuditID: cbfee61a-f79e46d00000134f-73-540e9ce0773c
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v8 0/3] usb: gadget: f_fs: userspace API fixes and improvements
Date: Tue, 09 Sep 2014 08:23:14 +0200
Message-id: <1410243797-9719-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLJMWRmVeSWpSXmKPExsVy+t9jAd2Hc/hCDDasYLY4eL/eonnxejaL
	y7vmsFksWtbKbPHg8E52B1aP/XPXsHv0bVnF6HH8xnYmj8+b5AJYorhsUlJzMstSi/TtErgy
	Fn04ylZwk7fi0O15rA2MU7m7GDk5JARMJOZ9amGFsMUkLtxbz9bFyMUhJLCIUWLxtX8sEE47
	k8T1ppeMIFVsAjoSW75PALNFBAQk1r+4xA5SxCzQyCjx4/cMsFHCAv4Sa5/OZQaxWQRUJV6v
	uMoCYvMKuEgsf3GQCWKdnMTJY5NZJzByL2BkWMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kR
	HAjPpHYwrmywOMQowMGoxMObEcwXIsSaWFZcmXuIUYKDWUmE13sGUIg3JbGyKrUoP76oNCe1
	+BCjNAeLkjjvgVbrQCGB9MSS1OzU1ILUIpgsEwenVANjzrmPzVK3BFcf375b44/XpvNrGzea
	fpwTGGcumlDzvzdFqGLvap193il74toOePWfM2tPko1tMfz7sHVTeJa5dJWh1OfPISWqahzX
	H8a/OPZ83tQ9V0X6BbZbi/VtYRQIVLp0lXfSS/koub3sFxtvnNiX+dmLZcOW1k+KHGbOFkZd
	r2cc23hJiaU4I9FQi7moOBEAGWQYjAACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

I have finally prepated patchset that should apply and build with your
testing/next tree.

Best regards
Robert Baldyga

Changelog:

v8:
- add patch "usb: gadget: f_fs: fix the redundant ep files problem" to
  make it possible to apply to Felipe tree

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

Robert Baldyga (3):
  usb: gadget: f_fs: fix the redundant ep files problem
  usb: gadget: f_fs: add ioctl returning ep descriptor
  usb: gadget: f_fs: virtual endpoint address mapping

 drivers/usb/gadget/function/f_fs.c  | 112 +++++++++++++++++++++++++++++++-----
 drivers/usb/gadget/function/u_fs.h  |   4 ++
 include/uapi/linux/usb/functionfs.h |   7 +++
 3 files changed, 110 insertions(+), 13 deletions(-)

-- 
1.9.1

