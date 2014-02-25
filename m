Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425AbaBYHQj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 02:16:39 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:15654 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaBYHQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 02:16:38 -0500
Message-ID: <530C4330.20706@huawei.com>
Date: Tue, 25 Feb 2014 15:16:00 +0800
From: xiakaixu <xiakaixu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: <a.p.zijlstra@chello.nl>, <paulus@samba.org>, <mingo@redhat.com>,
        <acme@ghostprotocols.net>
CC: <linux-kernel@vger.kernel.org>, Huxinwei <huxinwei@huawei.com>,
        Genghui <hui.geng@huawei.com>, <peifeiyue@huawei.com>
Subject: Re: A Bug Inquiry in linux/tools/perf/builtin-record.c
References: <53040D7F.3000905@huawei.com>
In-Reply-To: <53040D7F.3000905@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.111.100.238]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ÓÚ 2014/2/19 9:48, xiakaixu Ð´µÀ:
> Hi all,
> 
> There is a bug found in my work when running "perf record". The basic information
> is here. As we know, perf record is a parent process and the programme traced is
> a child process when running "perf record". Sometimes the child process become
> zombie state and disappear until the parent process is killed. The bug stays in linux/
> tools/perf/builtin-record.c.
> *********************************************************************
> static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
>     ......
> 	if (hits == rec->samples) {
>                          if (done)
>                                  break;
>                          err = poll(evsel_list->pollfd, evsel_list->nr_fds, -1);
>                          waking++;
>                  }
>     ......
> *********************************************************************
> The parent process still call the function
> poll(evsel_list->pollfd, evsel_list->nr_fds, -1) when the child process has exited
> already, which caused a zombie process.
> 
> May I have your opinion ?
> Waiting for your reply!
> 
> Best Regards
> Kaixu Xia
> 


