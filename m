Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759055Ab3EWRzM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 13:55:12 -0400
Received: from mail-oa0-f68.google.com ([209.85.219.68]:55967 "EHLO
	mail-oa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758076Ab3EWRzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 13:55:10 -0400
MIME-Version: 1.0
Date: Thu, 23 May 2013 10:55:09 -0700
Message-ID: <CABXedaTC=TiWsTeZ5ZWzjbdh8t5-8=6s-aLB41ZvZczoMrgGAg@mail.gmail.com>
Subject: how to get coalesced I/O in block layer
From: Shri Agarwal <agashri@gmail.com>
To: linux-kernel@vger.kernel.org, Shri Agarwal <agashri@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
i am trying to develop a blk driver,
i have registered my I/O handler function with
blk_init_queue(my function, lock)


my function get called for every Read and write as expected but all
I/O are page sized only.
so even if i send 32K I/O from application to my device, it gets me 8
4k(page size ) I/O.

so i have now two choice:
1. either i get I/O before got split
2. after elevator has aggregated them.



i have tried QUEUE_FLAG_PLUGGED to get large I/O but I/O are not
consistent(corruption happens after read and writing with
QUEUE_FLAG_PLUGGED).
any info would be highly appreciated.

thanks
