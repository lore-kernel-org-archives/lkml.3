Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbaJAQcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 12:32:14 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:58841 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbaJAQcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 12:32:08 -0400
Message-ID: <542C2C7B.2080009@linux.vnet.ibm.com>
Date: Wed, 01 Oct 2014 22:01:55 +0530
From: Hemant Kumar <hemant@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        namhyung@kernel.org, aravinda@linux.vnet.ibm.com, penberg@iki.fi
Subject: Re: [PATCH v1 0/5] perf/sdt: SDT events listing/probing
References: <20140930152055.6698.82709.stgit@hemant-fedora> <542C26F2.6090206@hitachi.com>
In-Reply-To: <542C26F2.6090206@hitachi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100116-7014-0000-0000-00000043CE6D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

On 10/01/2014 09:38 PM, Masami Hiramatsu wrote:
> Hi,
>
> (2014/10/01 0:29), Hemant Kumar wrote:
>> This patchset helps in listing dtrace style markers(SDT) present in user space
>> applications through perf.
>> Notes/markers are placed at important places by the
>> developers. They have a negligible overhead when not enabled.
>> We can enable them and probe at these places and find some important information
>> like the arguments' values, etc.
>>
>> We have lots of applications which use SDT markers today, like:
>> Postgresql, MySql, Mozilla, Perl, Python, Java, Ruby, libvirt, QEMU, glib
>>
>> To add SDT markers into user applications:
>> We need to have this header sys/sdt.h present.
>> sys/sdt.h used is version 3.
>> If not present, install systemtap-sdt-devel package (for fedora-20).
>>
>> With this patchset,
>> - Use perf sdt-cache --add to add SDT events to a cache.
>>   # perf sdt-cache --add ./user_app
>>
>>    4 SDT events added for /home/user/user_app!
>>
>> - Use perf sdt-cache --del to remove SDT events from the cache>
>>   # perf sdt-cache --del ./user_app
>>
>>   4 events removed for /home/user/user_app!
>>
>> - Dump the cache onto stdout using perf sdt-cache --dump:
>>   # perf sdt-cache --dump
>>    /home/user/user_app :
>>    %user_app:foo_start
>>    %user_app:fun_start
>>
>> - To probe and trace an SDT event :
>>    # perf record -e %user_app:foo_start -aR sleep 10
> Looks great! :)

Thankyou :)

>
> However, when I've tried to build, I got below errors..
>
>    CC       util/sdt.o
> util/sdt.c: In function ‘sdt_err’:
> util/sdt.c:72:3: error: implicit declaration of function ‘pr_err’ [-Werror=implicit-function-declaration]
>     pr_err("%s: No SDT events found\n", target);
>     ^
> util/sdt.c:72:3: error: nested extern declaration of ‘pr_err’ [-Werror=nested-externs]
> util/sdt.c: In function ‘file_hash_list__init’:
> util/sdt.c:489:3: error: implicit declaration of function ‘pr_debug’ [-Werror=implicit-function-declaration]
>     pr_debug("Error in madvise\n");
>     ^
> util/sdt.c:489:3: error: nested extern declaration of ‘pr_debug’ [-Werror=nested-externs]
> cc1: all warnings being treated as errors
>
> Perhaps, you might working on the old tree. Could you update it?

Hmm. Yes, it was on an older tree. Will update it and repost them.

> [SNIP]
>

-- 
Thanks,
Hemant Kumar

