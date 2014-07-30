Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaG3Jn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 05:43:59 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:61069 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbaG3Jn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 05:43:57 -0400
X-AuditID: cbfee61a-f79e46d00000134f-7f-53d8be5a47eb
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, mina86@mina86.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com, k.opasiak@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v3 0/3] usb: gadget: f_fs: userspace API fixes and improvements
Date: Wed, 30 Jul 2014 11:43:40 +0200
Message-id: <1406713423-32472-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplluLIzCtJLcpLzFFi42I5/e+xoG7UvhvBBofazCxmvWxnsTh4v96i
	efF6NovbE6exWVzeNYfNYtGyVmaLtUfuslssON7CavHg8E52B06P/XPXsHus+/OKyaNvyypG
	j+M3tjN5fN4kF8AaxWWTkpqTWZZapG+XwJUx48JRloJFXBX3z99ma2BcyNHFyMkhIWAiMW3W
	XGYIW0ziwr31bF2MXBxCAtMZJX6/aWWBcNqZJK497gSrYhPQkdjyfQIjiC0iICCx/sUldpAi
	ZoEHjBLtty4DtXNwCAv4S7T0CIHUsAioSty4/x2snlfAVaL9Ui/UNjmJk8cms05g5F7AyLCK
	UTS1ILmgOCk911CvODG3uDQvXS85P3cTIzhwnkntYFzZYHGIUYCDUYmHd8b/68FCrIllxZW5
	hxglOJiVRHj71t4IFuJNSaysSi3Kjy8qzUktPsQozcGiJM57oNU6UEggPbEkNTs1tSC1CCbL
	xMEp1cB4egWvk/Q5T8WMWsEp0dM+FvT9EBC846/c9JZbxkDs0JnsH4XJX/f/sq6JvmCzT+ru
	5t0/S5qN7X3fLtBpmqFu77b8n8K5c65t1jKXa59qHf7OEWqR8NhzDa/6z5a1nw8JF0xZe3Pa
	wrnWIruO7tRdx9G3JMHtYa5tVZHxlBN1y/U0he69PfVViaU4I9FQi7moOBEATs1KdhgCAAA=
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

v3:
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

 drivers/usb/gadget/f_fs.c           | 107 +++++++++++++++++++++++++++++++-----
 drivers/usb/gadget/u_fs.h           |   4 ++
 include/uapi/linux/usb/functionfs.h |   7 +++
 3 files changed, 105 insertions(+), 13 deletions(-)

-- 
1.9.1

