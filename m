Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbaKDVDz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 16:03:55 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:40265 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbaKDVDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 16:03:54 -0500
MIME-Version: 1.0
From: Gregory Fong <gregory.0xf0@gmail.com>
Date: Tue, 4 Nov 2014 13:03:22 -0800
Message-ID: <CADtm3G7DtGkvPk36Fiunwen8grw-94V6=iv82iusGumfNJkn-g@mail.gmail.com>
Subject: CMA alignment question
To: linux-mm@kvack.org
Cc: lauraa@codeaurora.org, iamjoonsoo.kim@lge.com, mina86@mina86.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The alignment in cma_alloc() is done w.r.t. the bitmap.  This is a
problem when, for example:

- a device requires 16M (order 12) alignment
- the CMA region is not 16 M aligned

In such a case, can result with the CMA region starting at, say,
0x2f800000 but any allocation you make from there will be aligned from
there.  Requesting an allocation of 32 M with 16 M alignment, will
result in an allocation from 0x2f800000 to 0x31800000, which doesn't
work very well if your strange device requires 16M alignment.

This doesn't have the behavior I would expect, which would be for the
allocation to be aligned w.r.t. the start of memory.  I realize that
aligning the CMA region is an option, but don't see why cma_alloc()
aligns to the start of the CMA region.  Is there a good reason for
having cma_alloc() alignment work this way?

Thanks and regards,
Gregory
