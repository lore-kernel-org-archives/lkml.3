Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab3JHNKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:10:05 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:36125 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab3JHNKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:10:01 -0400
Message-ID: <5254041D.70205@linux.vnet.ibm.com>
Date: Tue, 08 Oct 2013 18:39:49 +0530
From: Hemant <hkshaw@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org,
        srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, mingo@redhat.com, anton@redhat.com,
        systemtap@sourceware.org, masami.hiramatsu.pt@hitachi.com,
        aravinda@linux.vnet.ibm.com
Subject: Re: [PATCH v2 0/3] Perf support to SDT markers
References: <20131007063911.11693.33624.stgit@hemant-fedora> <y0m38odytfm.fsf@fche.csb> <874n8sku03.fsf@sejong.aot.lge.com>
In-Reply-To: <874n8sku03.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100813-5816-0000-0000-00000A4403D2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2013 02:40 PM, Namhyung Kim wrote:
> Hi Frank,
>
> On Mon, 07 Oct 2013 11:47:09 -0400, Frank Ch. Eigler wrote:
>> Hemant Kumar <hkshaw@linux.vnet.ibm.com> writes:
>>
>>> [...]
>>> A simple example to show this follows.
>>> - Create a file with .d extension and mention the probe names in it with
>>> provider name and marker name.
>>> [...]
>>> - Now create the probes.h and probes.o file :
>>> $ dtrace -C -h -s probes.d -o probes.h
>>> $ dtrace -C -G -s probes.d -o probes.o
>>> [...]
>> It may be worthwhile to document an even-simpler case:
>>
>> - no .d file
>> - no invocation of the dtrace python script
>> - no generated .h or .o file
>> - in the C file, just add:
>>
>>    #include <sys/sdt.h>
>>
>>    void main () {
>>         /* ... */
>>         STAP_PROBE(provider_name,probe_name);
>>         /* ... */
>>    }
>>
>> - gcc file.c
>> - stap -l 'process("./a.out").mark("*")' to list
> Yes, looks much simpler and better.
>
> Hemant, would you add it to the doc too?
>
> Thanks,
> Namhyung
>

Yes, it will be good to add this simpler example in the doc.

-- 
Thanks
Hemant

