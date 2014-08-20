Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaHTFrE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 01:47:04 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:59712 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaHTFrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 01:47:01 -0400
X-AuditID: cbfee61a-f79e46d00000134f-23-53f436486208
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, mina86@mina86.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com, k.opasiak@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v4 0/3] usb: gadget: f_fs: userspace API fixes and improvements
Date: Wed, 20 Aug 2014 07:46:22 +0200
Message-id: <1408513585-28261-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjluLIzCtJLcpLzFFi42I5/e+xgK6H2Zdgg78TdC1mvWxnsTh4v96i
	efF6NovbE6exWVzeNYfNYtGyVmaLtUfuslssON7CavHg8E52B06P/XPXsHus+/OKyaNvyypG
	j+M3tjN5fN4kF8AaxWWTkpqTWZZapG+XwJXx8/1RloK/XBX/ll1gbmBs5Oxi5OSQEDCRePdn
	LTOELSZx4d56ti5GLg4hgUWMEltvdbNCOO1MEgfXHAKrYhPQkdjyfQIjiC0iICCx/sUldpAi
	ZoEHjBLtty6zgSSEBfwlHkybAtbAIqAq8X/hDCYQm1fAVeLBzFY2iHVyEiePTWadwMi9gJFh
	FaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZw6DyT2sG4ssHiEKMAB6MSD69C9udgIdbEsuLK
	3EOMEhzMSiK8bBpfgoV4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmi1DhQSSE8sSc1OTS1ILYLJ
	MnFwSjUwyp6vDGd4VdRf+s70evqdYmWZHZJxqZ9mrb/Kl/JZbyXb3qQ1knIzzt+R9l23wDSi
	XDn0OlPwQjNpzs+HrCNVD3ru8Q2Z+6Tj3BcnNwvDck6v5cyPVj30eGhcP/OTls5Cb4Yfgoty
	Ntj1cOX//qP+reb9rUNL+jc0++hJh/9Ysk73clLeP683SizFGYmGWsxFxYkAH4gzihkCAAA=
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

v4:
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

