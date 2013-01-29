Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542Ab3A2O0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 09:26:24 -0500
Received: from goliath.siemens.de ([192.35.17.28]:24355 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200Ab3A2O0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 09:26:21 -0500
Message-ID: <5107DBF3.6000802@siemens.com>
Date: Tue, 29 Jan 2013 15:25:55 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: Re: [PATCH v5 16/20] scripts/gdb: Add internal helper and convenience
 function for per-cpu lookup
References: <cover.1359463075.git.jan.kiszka@siemens.com> <04960fa208fbd9c0962eb4f70aa45d28aec59e8d.1359463075.git.jan.kiszka@siemens.com> <20130129135109.GF14302@pd.tnic> <5107D528.2010305@siemens.com> <20130129141202.GH14302@pd.tnic>
In-Reply-To: <20130129141202.GH14302@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-01-29 15:12, Borislav Petkov wrote:
> On Tue, Jan 29, 2013 at 02:56:56PM +0100, Jan Kiszka wrote:
>> Let me guess: You are dumping a weird QEMU/KVM CPU, right?
> 
> Nah, I actually have the silicon! :-)
> 
> Joking, of course. I wish. I'm booting the guest with -cpu phenom (it
> has been like that since forever in my boot-kernel-in-kvm script) but
> the host is Intel.
> 
> If I do this on an AMD host, all is ok:
> 
> (gdb) p $lx_per_cpu("cpu_info").x86_vendor_id
> $1 = "AuthenticAMD\000\000\000"
> (gdb) p $lx_per_cpu("cpu_info").x86_model_id
> $2 = "AMD Phenom(tm) 9550 Quad-Core Processor", '\000' <repeats 24 times>
> (gdb)

Remains a bug of QEMU, though possibly a minor one.

> 
> [ … ]
> 
>>>> +class PerCpu(gdb.Function):
>>>> +	__doc__ = "Return per-cpu variable.\n" \
>>>> +		  "\n" \
>>>> +		  "$lx_per_cpu(\"VAR\"[, CPU]): Return the per-cpu variable called VAR for the\n" \
>>>> +		  "given CPU number. If CPU is omitted, the CPU of the current context is used.\n" \
>>>> +		  "Note that VAR has to be quoted as string."
>>>
>>>
>>> Ok, seriously now:
>>>
>>> apropos shows the "Return per-cpu... " line above. Have you found out
>>> which gdb command shows the rest? help and info both say "Undefined
>>> command".
>>
>> help function lx_...
>>
>> It took me a while to find this, too.
> 
> Maybe worth documenting it then at the end of gdb-kernel-debugging.txt?
> 

Done. Will come with v6 (if needed), otherwise as an add-on patch.

Thanks,
Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SDP-DE
Corporate Competence Center Embedded Linux
