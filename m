Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbaCQAnZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 20:43:25 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:52018 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725AbaCQAnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 20:43:23 -0400
X-AuditID: 9c93017d-b7c89ae000006ae1-30-5326452848dc
From: Namhyung Kim <namhyung@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, eranian@google.com, jolsa@redhat.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf, tools: Add script to easily decode addresses
References: <1394740438-27343-1-git-send-email-andi@firstfloor.org>
Date: Mon, 17 Mar 2014 09:43:18 +0900
In-Reply-To: <1394740438-27343-1-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Thu, 13 Mar 2014 12:53:58 -0700")
Message-ID: <87y509u02h.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Thu, 13 Mar 2014 12:53:58 -0700, Andi Kleen wrote:
> +def MASK(bits):
> +    return (1 << bits) - 1
> +
> +def decode_bits(val, names, bits, shift):
> +    v = (val >> shift) & MASK(bits)
> +    s = ""
> +    for name, index in zip(names, range(0, len(names))):
> +        if v & (1 << index):
> +            s += " " + name
> +    return s
> +
> +#        __u64   mem_op:5,       /* type of opcode */
> +#                mem_lvl:14,     /* memory hierarchy level */
> +#                mem_snoop:5,    /* snoop mode */
> +#                mem_lock:2,     /* lock instr */
> +#                mem_dtlb:7,     /* tlb access */
> +#                mem_rsvd:31;
> +
> +def decode_datasrc(d):
> +    s = ""
> +    s += decode_bits(d, ['', 'LOAD', 'STORE?', 'PREFETCH', 'EXEC'], 5, 0)
> +    s += decode_bits(d, ['', 'HIT', 'MISS', 'L1', 'LFB', 'L2', 'L3',
> +                         'LOC_RAM', 'REM-RAM-1', 'REM-RAM-2', 'REM-CACHE-1'
> +                         'REM-CACHE-2', 'REM-IO', 'REM-UNCACHED'], 14, 5)
> +    s += decode_bits(d, ['', 'NONE', 'MISS', 'HITM'], 19, 5)
> +    s += decode_bits(d, ['', 'LOCKED'], 24, 2)
> +    s += decode_bits(d, ['', 'L1', 'L2', 'WK', 'OS'], 26, 7)

Shouldn't it be like below (bits and shift exchanged)?

	s += decode_bits(d, ['', 'NONE', 'MISS', 'HITM'], 5, 19)
	s += decode_bits(d, ['', 'LOCKED'], 2, 24)
	s += decode_bits(d, ['', 'L1', 'L2', 'WK', 'OS'], 7, 26)

Thanks,
Namhyung
