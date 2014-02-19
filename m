Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbaBSBtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 20:49:23 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:6429 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaBSBtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 20:49:22 -0500
Message-ID: <53040D7F.3000905@huawei.com>
Date: Wed, 19 Feb 2014 09:48:47 +0800
From: xiakaixu <xiakaixu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: <a.p.zijlstra@chello.nl>, <paulus@samba.org>, <mingo@redhat.com>,
        <acme@ghostprotocols.net>
CC: <linux-kernel@vger.kernel.org>, Huxinwei <huxinwei@huawei.com>,
        Genghui <hui.geng@huawei.com>, <peifeiyue@huawei.com>
Subject: A Bug Inquiry in linux/tools/perf/builtin-record.c
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.100.238]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

There is a bug found in my work when running "perf record". The basic information
is here. As we know, perf record is a parent process and the programme traced is
a child process when running "perf record". Sometimes the child process become
zombie state and disappear until the parent process is killed. The bug stays in linux/
tools/perf/builtin-record.c.
*********************************************************************
static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
    ......
	if (hits == rec->samples) {
                         if (done)
                                 break;
                         err = poll(evsel_list->pollfd, evsel_list->nr_fds, -1);
                         waking++;
                 }
    ......
*********************************************************************
The parent process still call the function
poll(evsel_list->pollfd, evsel_list->nr_fds, -1) when the child process has exited
already, which caused a zombie process.

May I have your opinion ?
Waiting for your reply!

Best Regards
Kaixu Xia

