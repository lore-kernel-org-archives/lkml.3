Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbbAWMso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 07:48:44 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:54882 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbbAWMsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 07:48:41 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-b9-54c2429628b0
Message-id: <54C24321.5010205@samsung.com>
Date: Fri, 23 Jan 2015 15:48:33 +0300
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org
Cc: Dmitry Vyukov <dvyukov@google.com>, Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, linux-mm@kvack.org, Jonathan Corbet <corbet@lwn.net>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:KERNEL BUILD + fi..." <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH v9 01/17] Add kernel address sanitizer infrastructure.
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1421859105-25253-1-git-send-email-a.ryabinin@samsung.com>
 <1421859105-25253-2-git-send-email-a.ryabinin@samsung.com>
 <54C23FFB.5010800@suse.cz>
In-reply-to: <54C23FFB.5010800@suse.cz>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t/xa7rTnA6FGHxay2/xe+9MVos569ew
	WRy59p3d4vq3N4wWTw60M1p8evmA0eL5w4fsFhMetrFbrOxuZrPY/uwtk8XKzgesFgvblrBY
	/Nm1g8ni8q45bBb31vxntbh0YAGTRcu+C0wWx3sPMFksPnKb2eLds8nMFj82PGZ1EPWYv/Mj
	o8fOWXfZPRZsKvXYvELLY/Gel0wem1Z1snls+jSJ3aPr7RUmjxMzfrN4PLkyncljcd9kVo+P
	T2+xeLzfd5XN48yCI+wenzfJBfBHcdmkpOZklqUW6dslcGXsnPWEueAxS8XxL3cZGxifMXcx
	cnJICJhItM19AWWLSVy4t56ti5GLQ0hgKaPE11/bGSGcZiaJzf3vgRwODl4BLYlXG5xBGlgE
	VCXuNh0Ea2YT0JP4N2s7G4gtKhAh8WHVVzCbV0BQ4sfkeywgtoiAvcS/ll4WkJnMAo9ZJfo+
	ngVrFhbwkngw4RM7xLI7jBKfN61gAklwCqhLPLr1DWwxM5A9ZUouSJhZQF5i85q3zBMYBWYh
	2TELoWoWkqoFjMyrGEVTS5MLipPSc430ihNzi0vz0vWS83M3MUIi+usOxqXHrA4xCnAwKvHw
	HnhzMESINbGsuDL3EKMEB7OSCK+15qEQId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYwi+UxV+ya9
	PqVmtXRm9wHHTWWvp+2ZlpQ+yeaxH1vaydO5sek6lhtkZaf3X8sUm921o9/78MyLu+qvbJh8
	dfPBHpEHLPM2TjCqV8lRMjbWKnRU4Fuxr6hqfoWI0zqFfn+Fsy5V600XNK/u8D61WnPTm6j9
	jqzLbXo7WPiE98w+L3rgcOuJH+eVWIozEg21mIuKEwEBKNePxgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2015 03:35 PM, Michal Marek wrote:
> On 2015-01-21 17:51, Andrey Ryabinin wrote:
>> +ifdef CONFIG_KASAN_INLINE
>> +	call_threshold := 10000
>> +else
>> +	call_threshold := 0
>> +endif
> 
> Can you please move this to a Kconfig helper like you did with
> CONFIG_KASAN_SHADOW_OFFSET? Despite occasional efforts to reduce the
> size of the main Makefile, it has been growing over time. With this
> patch set, we are approaching 2.6.28's record of 1669 lines.
> 

How about moving the whole kasan stuff into scripts/Makefile.kasan
and just include it in generic Makefile?

> Michal
> 

