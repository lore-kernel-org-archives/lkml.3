Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbaHYJQw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 05:16:52 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:29009 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbaHYJQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 05:16:48 -0400
X-AuditID: cbfee61a-f79e46d00000134f-8c-53fafefde8e6
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, mina86@mina86.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com, k.opasiak@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v6 0/3] usb: gadget: f_fs: userspace API fixes and improvements
Date: Mon, 25 Aug 2014 11:16:26 +0200
Message-id: <1408958189-20611-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplluLIzCtJLcpLzFFi42I5/e+xoO7ff7+CDR7+N7WY9bKdxeLg/XqL
	5sXr2SxuT5zGZnF51xw2i0XLWpkt1h65y26x4HgLq8WDwzvZHTg99s9dw+6x7s8rJo++LasY
	PY7f2M7k8XmTXABrFJdNSmpOZllqkb5dAlfG1VN/GAue81RM6t3N1sB4lKuLkZNDQsBE4vj5
	v8wQtpjEhXvr2boYuTiEBKYzSix60MYC4bQzSZw8/IcNpIpNQEdiy/cJjCC2iICAxPoXl9hB
	ipgFHjBKtN+6DFYkLOAvcW79U6AiDg4WAVWJ9XNVQMK8Aq4Slye+ZYPYJidx8thk1gmM3AsY
	GVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBAfOM6kdjCsbLA4xCnAwKvHwruT8FSzEmlhW
	XJl7iFGCg1lJhFfjD1CINyWxsiq1KD++qDQntfgQozQHi5I474FW60AhgfTEktTs1NSC1CKY
	LBMHp1QD4+4X2/VcJh94HaI+s2ay2M/CHTv+TWu61L46fqf05KyH37UKLvDPMzNbemDzV5G3
	WhdDL+/9GTSxQesOa24Bd0TDq6Y7HgJxbzZt+pTyeSqjxcZHiWJpswT+bfYx3/3G5dKfdf3z
	Gc/1ylysXpuxu5o/9jlzyCezRMcdF+7UlH3wTZ+/XE+u/qQSS3FGoqEWc1FxIgD6sqvhGAIA	AA==
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

v6:
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

