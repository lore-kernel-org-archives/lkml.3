Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbaDGF2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 01:28:40 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:56092 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbaDGF2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 01:28:37 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>, acme@ghostprotocols.net,
        LKML <linux-kernel@vger.kernel.org>, jmario@redhat.com,
        fowles@inreach.com, bp@alien8.de
Subject: Re: [PATCH 1/4] perf: Allow ability to map cpus to nodes easily
References: <1395689577-214654-1-git-send-email-dzickus@redhat.com>
	<1395689577-214654-2-git-send-email-dzickus@redhat.com>
	<874n2byncs.fsf@sejong.aot.lge.com>
	<20140406121546.GC1164@krava.brq.redhat.com>
Date: Mon, 07 Apr 2014 14:28:35 +0900
In-Reply-To: <20140406121546.GC1164@krava.brq.redhat.com> (Jiri Olsa's message
	of "Sun, 6 Apr 2014 14:15:46 +0200")
Message-ID: <87mwfxyags.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Apr 2014 14:15:46 +0200, Jiri Olsa wrote:
> On Thu, Apr 03, 2014 at 02:48:51PM +0900, Namhyung Kim wrote:
>> More generally, this sysfs access needs to check actual mountpoint using
>> sysfs__mountpoint() IMHO.
>> 
>> Also this API can be generalized like reading int value from a sysfs
>> file as the filename itself represents the content in most cases.
>> 
>> So how about changing this way?  It might reside on somewhere in tools/lib/api/fs/.
>> 
>>   max_cpu_num = sysfs__read_int("devices/system/cpu/possible");
>> 
>>   max_node_num = sysfs__read_int("devices/system/node/possible");
>> 
>> 
>> Hmm.. looking at the code, perf already has filename__read_{int,str} API
>> in util/util.c.  Maybe you can just use it instead.
>
> I think those just read the file, while Don needs to parse
> the map to get max cpu number

Ah, missed that... sorry for noise.

Thanks,
Namhyung
