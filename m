Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbaBZIDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 03:03:42 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:50021 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbaBZIDk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 03:03:40 -0500
X-AuditID: 9c93017d-b7c89ae000006ae1-bf-530d9fda6d19
From: Namhyung Kim <namhyung@kernel.org>
To: xiakaixu <xiakaixu@huawei.com>
Cc: <a.p.zijlstra@chello.nl>, <paulus@samba.org>, <mingo@redhat.com>,
        <acme@ghostprotocols.net>, <linux-kernel@vger.kernel.org>,
        Huxinwei <huxinwei@huawei.com>, Genghui <hui.geng@huawei.com>,
        <peifeiyue@huawei.com>
Subject: Re: A Bug Inquiry in linux/tools/perf/builtin-record.c
References: <53040D7F.3000905@huawei.com> <530C4330.20706@huawei.com>
Date: Wed, 26 Feb 2014 17:03:37 +0900
In-Reply-To: <530C4330.20706@huawei.com> (xiakaixu@huawei.com's message of
	"Tue, 25 Feb 2014 15:16:00 +0800")
Message-ID: <87lhwyuwpy.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi xiakaixu,

> 于 2014/2/19 9:48, xiakaixu 写道:
>> Hi all,
>> 
>> There is a bug found in my work when running "perf record". The basic information
>> is here. As we know, perf record is a parent process and the programme traced is
>> a child process when running "perf record". Sometimes the child process become
>> zombie state and disappear until the parent process is killed. The bug stays in linux/
>> tools/perf/builtin-record.c.
>> *********************************************************************
>> static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
>>     ......
>> 	if (hits == rec->samples) {
>>                          if (done)
>>                                  break;
>>                          err = poll(evsel_list->pollfd, evsel_list->nr_fds, -1);
>>                          waking++;
>>                  }
>>     ......
>> *********************************************************************
>> The parent process still call the function
>> poll(evsel_list->pollfd, evsel_list->nr_fds, -1) when the child process has exited
>> already, which caused a zombie process.
>> 
>> May I have your opinion ?
>> Waiting for your reply!

Do you have a real bug report based on this?

AFAIK perf record installed a signal handler for SIGCHLD so it'll set
the 'done' variable when child exits and then break the loop.

Thanks,
Namhyung
