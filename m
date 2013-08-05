Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab3HEITb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 04:19:31 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:20406 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400Ab3HEIT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 04:19:29 -0400
Message-ID: <51FF5FC9.8080302@huawei.com>
Date: Mon, 5 Aug 2013 16:18:17 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: stable: please queue commit 0231bb5 ("perf: Fix event group context
 move")
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Plese consider adding commit 0231bb5336758426b44ccd798ccd3c5419c95d58
to stable tree. It fixes a real bug, which was explained here:

	http://thread.gmane.org/gmane.linux.kernel.perf.user/1144

and I've managed to reproduce the bug in 3.4 kernel with the test
program attached in the above email, and I've confirmed the bug fix.

The effect of the bug is, if we open a group of mixed events(sw/hw)
and the "disabled" flag is not set and sw events come first, then
some of the perf events won't be started after the call to perf_event_open().

The bug fix should be applicable to kernels >= 3.0 && <= 3.7.

--
Li Zefan
