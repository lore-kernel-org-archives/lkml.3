Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033Ab3JHJKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 05:10:55 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:55160 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab3JHJKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 05:10:53 -0400
X-AuditID: 9c930179-b7b7fae000002758-a1-5253cc1ce662
From: Namhyung Kim <namhyung@kernel.org>
To: fche@redhat.com (Frank Ch. Eigler)
Cc: Hemant Kumar <hkshaw@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, mingo@redhat.com, anton@redhat.com,
        systemtap@sourceware.org, masami.hiramatsu.pt@hitachi.com,
        aravinda@linux.vnet.ibm.com
Subject: Re: [PATCH v2 0/3] Perf support to SDT markers
References: <20131007063911.11693.33624.stgit@hemant-fedora>
	<y0m38odytfm.fsf@fche.csb>
Date: Tue, 08 Oct 2013 18:10:52 +0900
In-Reply-To: <y0m38odytfm.fsf@fche.csb> (Frank Ch. Eigler's message of "Mon,
	07 Oct 2013 11:47:09 -0400")
Message-ID: <874n8sku03.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frank,

On Mon, 07 Oct 2013 11:47:09 -0400, Frank Ch. Eigler wrote:
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
>
> It may be worthwhile to document an even-simpler case:
>
> - no .d file
> - no invocation of the dtrace python script
> - no generated .h or .o file
> - in the C file, just add:
>
>   #include <sys/sdt.h>
>
>   void main () {
>        /* ... */
>        STAP_PROBE(provider_name,probe_name);
>        /* ... */
>   }
>
> - gcc file.c
> - stap -l 'process("./a.out").mark("*")' to list

Yes, looks much simpler and better.

Hemant, would you add it to the doc too?

Thanks,
Namhyung
