Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932Ab3FCPwF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:52:05 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:49646 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677Ab3FCPwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:52:02 -0400
MIME-Version: 1.0
Date: Mon, 3 Jun 2013 17:52:01 +0200
Message-ID: <CAOPDcRyMr2RL+4azAzDeBK0Ja_9zNvWFjBy3Z8XL9BKH_a+A7w@mail.gmail.com>
Subject: Clarifications on PFN_UP macro
From: stl <st.lambert02@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I need some clarifications concerning the macro

#define PFN_UP(x)    (((x) + PAGE_SIZE-1) >> PAGE_SHIFT)

found in "pfn.h"

I suppose that its aim is to give the page frame number of the page
following the page holding the physical adress x, contrary to
PFN_DOWN(x) which give the page frame number of the page holding the
adress x.

Assuming that the first page has the range 0x0000 to 0x0FFF,
the second 0x1000 to 0x1FFF and so on, it seems that there is
an issu with the starting adress of each page, for example:
x = 0x10000  (PFN number 10)
0x10000 + 0xFFF >> 12    =    10, but should be 11 no?

I certainly misunderstood something.
Could someone clarify this point please?

Thanks.
