Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab3IYIpc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 04:45:32 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:40431 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab3IYIp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 04:45:29 -0400
Message-ID: <5242A2A3.303@hitachi.com>
Date: Wed, 25 Sep 2013 17:45:23 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Hemant <hkshaw@linux.vnet.ibm.com>
Cc: Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org
Subject: Re: [PATCH 1/2] SDT markers listing by perf
References: <20130903072944.4793.93584.stgit@hemant-fedora> <20130903073655.4793.20013.stgit@hemant-fedora> <87ioyht7e4.fsf@sejong.aot.lge.com> <5226E8F4.5060505@hitachi.com> <523599C2.6020204@linux.vnet.ibm.com> <5242687A.9030209@hitachi.com> <52427CAE.8030600@linux.vnet.ibm.com>
In-Reply-To: <52427CAE.8030600@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/09/25 15:03), Hemant wrote:
>>> I have one doubt here. Why do we need [ARG ...] in the syntax you
>>> specified? I believe these args are to fetched from the sdt notes'
>>> section of the elf of the executable/library. Or am I taking this in a
>>> wrong way and this suggested syntax is actually for the uprobe_events
>>> file in the tracing directory?
>> Hm, indeed. Since all the arguments of the marker is defined in sdt notes,
>> we actually don't need to specify each of them. However, other probe syntax
>> has those arguments. I'd like to keep the same syntax style in the
>> same command (action) for avoiding confusion.
> 
> Hmm, got it.
> 
>> I recommend this way; at the first step, we just find the marker address from
>> sdt. And next, we will make the argument available. And eventually,
>> it is better to introduce "$args" meta argument to fetch all the arguments
>> of the marker.
>>
>> At this point, we can do
>>
>> perf probe %foo:bar $args
> 
> So, at first step (ignoring the arguments), we can go with :
> perf probe %foo:bar

Right,

> And, once, the argument support is enabled (all the arguments will be
> fetched at the marker location), we can go with:
> perf probe %foo:bar $args

Correct ;). In my plan, $parms and $vars will be also introduced for
accessing all function parameters and local variables correspondingly.

Thank you!

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


