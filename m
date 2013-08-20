Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885Ab3HTRTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 13:19:22 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:47173 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab3HTRTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 13:19:20 -0400
Message-ID: <5213A516.9020103@gmail.com>
Date: Tue, 20 Aug 2013 11:19:18 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf trace: Make command line arguments consistent with
 perf-record
References: <1377010076-21509-1-git-send-email-dsahern@gmail.com> <20130820145156.GC8488@ghostprotocols.net> <521397DE.5010306@gmail.com> <20130820171118.GE8488@ghostprotocols.net>
In-Reply-To: <20130820171118.GE8488@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/20/13 11:11 AM, Arnaldo Carvalho de Melo wrote:
>> grrrr... Added a check in the git pre-commit hook to remind me:
>>
>> $ git commit -a
>> changing command line arguments. Did you update the man page?
>
> Hey, post it somewhere, please! I'd like to use it too. :-)

$ cat .git/hooks/pre-commit
#!/bin/bash

git diff --cached | egrep -q 'OPT_'
if [ $? -eq 0 ]
then
	git diff --cached | egrep -q '^diff.*tools/perf/Documentation'
	if [ $? -ne 0 ]
	then
		echo "changing command line arguments. Did you update the man page?"
		exit 1
	fi
fi
exec git diff --cached | scripts/checkpatch.pl --no-signoff -q -
