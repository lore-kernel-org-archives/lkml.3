Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab3IWIHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 04:07:37 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:53286 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab3IWIHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 04:07:34 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-1d-523ff6c4c1a2
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH] usb: s3c-hsotg: add isochronous transfers support
Date: Mon, 23 Sep 2013 10:07:11 +0200
Message-id: <1379923632-11205-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t9jQd0j3+yDDN6uMLDYOGM9q8XB+/UW
	zYvXs1lc3jWHzWLRslZmi7VH7rJbPDi8k92B3WP/3DXsHn1bVjF6HL+xncnj8ya5AJYoLpuU
	1JzMstQifbsEroxr1zazF3xkq1i97CJzA+M11i5GTg4JAROJOVvOsUPYYhIX7q1n62Lk4hAS
	mM4o8W7tHHYIp51JYtK7PrAONgEdiS3fJzCC2CICAhLrX1wCK2IW2M4o8eR/F1hCWMBJ4tDW
	ucwgNouAqsTZhstgzbwCrhJr3v5n6mLkAFqnIDFnks0ERu4FjAyrGEVTC5ILipPScw31ihNz
	i0vz0vWS83M3MYJD45nUDsaVDRaHGAU4GJV4eCMS7YOEWBPLiitzDzFKcDArifA2dQKFeFMS
	K6tSi/Lji0pzUosPMUpzsCiJ8x5otQ4UEkhPLEnNTk0tSC2CyTJxcEo1MJq+Wm+ssHA/ywX2
	S08/3a+/9HPuNf+sv+98/tQk+e04EZsi/+zPxG8ajGs388yrWbvI/lGny6XOa+0Pz/ennRQP
	nrB8B1/OxChWn54Ny1hEiuNe8GfODr/cPF+ms+PbEv9c7osrTZ8VMhqybHvzsIRD59O5KSxT
	40vFf6yedu95QPrEgHvMR5YpsRRnJBpqMRcVJwIAhBTlMgkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

There is my initial proposal for isochronous transfers support in s3c-hsotg
driver.

This patch does few modifications:
- Fix few functions to make them usable in isochronous transfers handling.
- Add few fields to s3c_hsotg_ep structure, used for isochronous ep handling.
- Add isochronous specific endpoint descriptor fields handling.
- Add high-speed high-bandwidth trensfers support by correct Multi Count
  handling and Odd/Even frame toggle for interval=1.
- Improve endpoint interrupt handling by ignoring unneded interrupts for
  isochronous endpoints.

Best regards
Robert Baldyga
Samsung R&D Institute Poland

Robert Baldyga (1):
  USB: gadget: s3c-hsotg: add isochronous transfers support

 drivers/usb/gadget/s3c-hsotg.c |   74 +++++++++++++++++++++++++++++++---------
 1 file changed, 57 insertions(+), 17 deletions(-)

-- 
1.7.9.5

