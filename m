Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362Ab3J1LXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 07:23:51 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:56631 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498Ab3J1LXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 07:23:50 -0400
Message-ID: <526E4940.8000608@hitachi.com>
Date: Mon, 28 Oct 2013 20:23:44 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
Cc: Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        hegdevasant@linux.vnet.ibm.com, Ingo Molnar <mingo@redhat.com>,
        anton@redhat.com, systemtap@sourceware.org,
        Namhyung Kim <namhyung@kernel.org>, aravinda@linux.vnet.ibm.com
Subject: Re: Re: [PATCH v4 2/3] Support for perf to probe into SDT markers:
References: <20131023044511.1886.82571.stgit@hemant-fedora> <20131023050502.1886.15779.stgit@hemant-fedora> <CAOJsxLFKm3TxeTmGjbpr1r4sZ8fHcM481-5BM_Cq0J8hhtvBqQ@mail.gmail.com>
In-Reply-To: <CAOJsxLFKm3TxeTmGjbpr1r4sZ8fHcM481-5BM_Cq0J8hhtvBqQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/10/25 21:38), Pekka Enberg wrote:
> Hello Hemant,
> 
> On Wed, Oct 23, 2013 at 7:05 AM, Hemant Kumar <hkshaw@linux.vnet.ibm.com> wrote:
>> This allows perf to probe into the sdt markers/notes present in
>> the libraries and executables. We try to find the associated location
>> and handle prelinking (since, stapsdt notes section is not allocated
>> during runtime). Prelinking is handled with the help of base
>> section which is allocated during runtime. This address can be compared
>> with the address retrieved from the notes' description. If its different,
>> we can take this difference and then add to the note's location.
>>
>> We can use existing '-a/--add' option to add events for sdt markers.
>> Also, we can add multiple events at once using the same '-a' option.
>>
>> Usage:
>> perf probe -x /lib64/libc.so.6 -a 'my_event=%libc:setjmp'
>>
>> Output:
>> Added new event:
>>   libc:my_event        (on 0x35981)
>>
>> You can now use it in all perf tools, such as:
>>
>>     perf record -e libc:my_event -aR sleep 1
> 
> Is there a technical reason why 'perf list' could not show all the
> available SDT markers on a system and that the 'market to event'
> mapping cannot happen automatically?

By the way, what happens if multiple binaries has same SDT marker?
Yeah, perf list shows just one and ignores others. However, if we
probe one, and run binary which use the other one, user will never
see the marker.

So, it still needs a concrete binary path to list or, we should
support a syntax which specify actual binary, as like as below.

 perf probe 'my_event=%libc:setjmp@/lib64/libc.so.6'

And perf list may show the marker as in same syntax (for copy&paste).

# perf list --sdt
 %libc:setjmp@/lib64/libc.so.6
 ...

Note that we need '%' to separate namespace :(, since user can define
any marker(provider) name in their binary...

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


