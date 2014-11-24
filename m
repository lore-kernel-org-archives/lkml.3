Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbaKXQEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 11:04:51 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14385 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbaKXQEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 11:04:49 -0500
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: ezequiel.garcia@free-electrons.com, dwmw2@infradead.org,
        computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: UBI: Add support for scatter gather and blk-mq
Date: Mon, 24 Nov 2014 17:04:38 +0100
Message-Id: <1416845080-16663-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This two patches implement blk-mq support for the UBI block driver.
As the scatter gather part is rather generic I've moved it directl
into UBI such that it can be reused later.
So far only reading data into a scatter gather list is possible.
After implementing  ubi_eba_read_leb_sg() we could slowly start
removing a bunch of vmalloc() from the UBI core code and use scatter gather.
This should lower the memory footprint of UBI.

[PATCH 1/2] UBI: Add initial support for scatter gather
[PATCH 2/2] UBI: Block: Add blk-mq support

Thanks,
//richard
