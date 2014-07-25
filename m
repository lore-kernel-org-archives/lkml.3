Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760351AbaGYNgQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 09:36:16 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:30005 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbaGYNgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 09:36:14 -0400
X-AuditID: cbfee61a-f79e46d00000134f-1d-53d25d4cda7b
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, mina86@mina86.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2 0/3] usb: gadget: f_fs: userspace API fixes and improvements
Date: Fri, 25 Jul 2014 15:36:00 +0200
Message-id: <1406295363-26998-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkluLIzCtJLcpLzFFi42I5/e+xoK5P7KVgg0v/FS1mvWxnsTh4v96i
	efF6NovLu+awWSxa1spssfbIXXaLBcdbWC0eHN7J7sDhsX/uGnaPdX9eMXn0bVnF6HH8xnYm
	j8+b5AJYo7hsUlJzMstSi/TtErgyettusBXM4ax4MWcCWwPjWvYuRk4OCQETiXurDjBC2GIS
	F+6tZ+ti5OIQEpjOKLH9aRMrhNPOJPH94z6wDjYBHYkt3yeAdYgICEisf3GJHaSIWeA4o8TM
	T1+YQBLCAv4SJxdfYAGxWQRUJe63vGUDsXkFXCVeHD/MArFOTuLkscmsExi5FzAyrGIUTS1I
	LihOSs811CtOzC0uzUvXS87P3cQIDphnUjsYVzZYHGIU4GBU4uHtqL8YLMSaWFZcmXuIUYKD
	WUmEtzbqUrAQb0piZVVqUX58UWlOavEhRmkOFiVx3gOt1oFCAumJJanZqakFqUUwWSYOTqkG
	xprZLlWN0cyiDkcDr26+5D5Fr27qYu/YGo0C549cCw2+HVRLl7e7veBo4nzpA4frzRie7fuj
	r8AZ558i8N9/yv7TF+dyzjjp/CyUr+SWm3+Dnccd59gdwXLVnGs6wvuZ7K67MxxSPJL95M8+
	r1dtvUoJAVVftud98vVMm7U52LDTTp3z57u5SizFGYmGWsxFxYkAJdYKEBQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains changes in FunctionFS making it easier and
safer to use. It introduces virtual address mapping which allows
to separate endpoint address space in function from physical endpoint
addresses, and allow to refer to endpoints with address chosen by user.
It also adds new ioctl allowing to obtain endpoint descriptor, and
introduces new endpoint files naming convention to unify number identifying
each single endpoint.

Changelog:

v2:
- return proper endpont address in setup request handling
- add patch usb: gadget: f_fs: add ioctl returning ep descriptor
- add patch usb: gadget: f_fs: make numbers in ep file names the same
  as ep addresses

v1: https://lkml.org/lkml/2014/7/18/1010

Robert Baldyga (3):
  usb: gadget: f_fs: virtual address mapping
  usb: gadget: f_fs: add ioctl returning ep descriptor
  usb: gadget: f_fs: make numbers in ep file names the same as ep
    addresses

 drivers/usb/gadget/f_fs.c           | 102 +++++++++++++++++++++++++++++++-----
 drivers/usb/gadget/u_fs.h           |   4 ++
 include/uapi/linux/usb/functionfs.h |   7 +++
 3 files changed, 100 insertions(+), 13 deletions(-)

-- 
1.9.1

