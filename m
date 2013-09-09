Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab3IIP6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:58:41 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:46356 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab3IIP6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:58:40 -0400
MIME-Version: 1.0
X-Originating-IP: [89.2.206.189]
From: Tom Gundersen <teg@jklm.no>
Date: Mon, 9 Sep 2013 17:58:19 +0200
Message-ID: <CAG-2HqWaoovz+-pY2JnA4BSTULa4Hq=_5Oy4hzWOdQbrkijQKw@mail.gmail.com>
Subject: [BUG?] staging: zram: Add auto loading of module if user opens /dev/zram.
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Minchan Kim <minchan@kernel.org>, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay@vrfy.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Konrad,

The above commit (c70bda9 in mainline) doesn't appear to work for me.
I.e., depmod does not create an entry in modules.devname and hence no
device node is created on boot.

If I understand correctly, you'd also need to create the correct
"char-major-<MAJOR>-<MINOR>" alias. But I don't really see how this is
meant to work as I thought zram only created /dev/zramX type device
nodes, and not /dev/zram, or am I missing something?

Cheers,

Tom
