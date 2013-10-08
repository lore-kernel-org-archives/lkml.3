Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab3JHNch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:32:37 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:52386 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab3JHNcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:32:35 -0400
Message-ID: <52540945.5060107@linux.vnet.ibm.com>
Date: Tue, 08 Oct 2013 19:01:49 +0530
From: Hemant <hkshaw@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Frank Ch. Eigler" <fche@redhat.com>
CC: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        namhyung@kernel.org, masami.hiramatsu.pt@hitachi.com,
        aravinda@linux.vnet.ibm.com
Subject: Re: [PATCH v2 0/3] Perf support to SDT markers
References: <20131007063911.11693.33624.stgit@hemant-fedora> <y0m38odytfm.fsf@fche.csb>
In-Reply-To: <y0m38odytfm.fsf@fche.csb>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100813-1618-0000-0000-000004C103D5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/07/2013 09:17 PM, Frank Ch. Eigler wrote:
> Hemant Kumar <hkshaw@linux.vnet.ibm.com> writes:
>
>> [...]
>> A simple example to show this follows.
>> - Create a file with .d extension and mention the probe names in it with
>> provider name and marker name.
>> [...]
>> - Now create the probes.h and probes.o file :
>> $ dtrace -C -h -s probes.d -o probes.h
>> $ dtrace -C -G -s probes.d -o probes.o
>> [...]
> It may be worthwhile to document an even-simpler case:
>
> - no .d file
> - no invocation of the dtrace python script
> - no generated .h or .o file
> - in the C file, just add:
>
>    #include <sys/sdt.h>
>
>    void main () {
>         /* ... */
>         STAP_PROBE(provider_name,probe_name);
>         /* ... */
>    }
>
> - gcc file.c
> - stap -l 'process("./a.out").mark("*")' to list
>
>
> - FChE
>

Will add this example to the doc too.

-- 
Thanks
Hemant

