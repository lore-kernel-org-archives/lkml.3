Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965112AbaLMFNK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 00:13:10 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:63608 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaLMFNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 00:13:08 -0500
MIME-Version: 1.0
Date: Sat, 13 Dec 2014 10:43:04 +0530
Message-ID: <CALHRZuotPpSoX9bnQin=93k0Hr7tEp_HZDaaBvfKaPfmoi_EBQ@mail.gmail.com>
Subject: query on DWC3
From: sundeep subbaraya <sundeep.lkml@gmail.com>
To: "balbi@ti.com" <balbi@ti.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

In DWC3 driver, for three stage Control OUT transfer there is a check:

   else if (!IS_ALIGNED(req->request.length, dep->endpoint.maxpacket)

             && (dep->number == 0)) {.
    }

I understand that we check for alignment of sizes and if not we
prepare trb with maxpacket and enable interrupt on short packet. In
databook I could not find anything related to this, it talks only
about addresses should be aligned. In Control transfer programming
model there is no difference between Control OUT or IN transfer, if
three stage transfer - prepare trb with length wLength. Initially I
followed this and not able to receive data on EP0 OUT.:( .After adding
the above check it is working. Please help me to understand why we do
this?

Thank in advance,
Sundeep.B.S.
