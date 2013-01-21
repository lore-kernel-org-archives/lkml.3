Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab3AUGK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 01:10:28 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:1615 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab3AUGK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 01:10:26 -0500
Message-ID: <50FCDB5C.4050608@huawei.com>
Date: Mon, 21 Jan 2013 14:08:28 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: John Fastabend <john.r.fastabend@intel.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>
CC: LKML <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: [BUG] Bug in netprio_cgroup and netcls_cgroup ?
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not a network developer, so correct me if I'm wrong.

Since commit 406a3c638ce8b17d9704052c07955490f732c2b8
("net: netprio_cgroup: rework update socket logic"), sock->sk->sk_cgrp_prioidx
is set when the socket is created, and won't be updated unless the task is
moved to another cgroup.

Now the problem is, a socket can be _shared_ by multiple processes (fork, SCM_RIGHT).
If we place those processes in different cgroups, and each cgroup has
different configs, but all of the processes will send data via this socket
with the same network priority.

Similar with cls cgroup.
