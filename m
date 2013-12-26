Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab3LZSIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 13:08:09 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:44131 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468Ab3LZSIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 13:08:07 -0500
MIME-Version: 1.0
In-Reply-To: <52BC6E3B.9040703@zytor.com>
References: <20131225145447.GA18146@gmail.com>
	<20131226100348.GA7751@infradead.org>
	<CAMe9rOqx1HDT_rtiz2R0Cz5iAp0AFXhjw6RpTkjgFT_DDDWfVA@mail.gmail.com>
	<52BC6E3B.9040703@zytor.com>
Date: Thu, 26 Dec 2013 10:08:07 -0800
Message-ID: <CAMe9rOo5qOn-mV8bzKo04eL4bP123-8C4WG1wCbqwG5Sja5Avg@mail.gmail.com>
Subject: Re: [PATCH] Use __kernel_long_t/__kernel_ulong_t in <linux/resource.h>
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=089e015383e40bb66404ee73dcca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e015383e40bb66404ee73dcca
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Dec 26, 2013 at 9:58 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/26/2013 05:52 AM, H.J. Lu wrote:
>>
>>>  c) why you suddenly need these changes now and not when the x32 ABI
>>>     support was submitted and hopefully heavily tested
>>
>> Kernel headers had been wrong for -m32/-mx32 on x86-64
>> for a long long time.  Linux/x86-64 normally use header
>> files from glibc, which avoids broken kernel header files.
>> Kernel uabi header files fix -m32, but not -mx32, which I am
>> working on now.
>>
>
> In other words, this work is really part of making *libc make use the
> kernel uabi headers, which is a valuable work.  The fact that the kernel
> headers never got fully ported to x32 is a big reason why x32 is still
> labeled experimental.
>
> MIPS N32 and ARM64 ILP32 are x32-like ABIs which of course need to not
> be broken.  However, currently __kernel_[u]long_t is [unsigned] long for
> all ABIs other than x32, so changing [unsigned] long to
> __kernel_[u]long_t will be a null change for anything but x32.  They
> perhaps *SHOULD* be different for N32 or ARM64 ILP32, but that is for
> those arch maintainers to set.
>
> However, I believe H.J.'s patches from this morning conditionalizing
> this on __BITS_PER_LONG are just plain wrong.

FWIW, I prefer my first alternative.  I only added the second one
since I can't test for other ABIs.

I am enclosing my kernel header file checker.  It compares
kernel header files against glibc header files for -m64, -m32
and -mx32.

-- 
H.J.

--089e015383e40bb66404ee73dcca
Content-Type: application/x-xz; name="kernel-headers.tar.xz"
Content-Disposition: attachment; filename="kernel-headers.tar.xz"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hpobppx00

/Td6WFoAAATm1rRGAgAhARYAAAB0L+Wj4Cf/BM1dADgYS3Zs2QpOuJqzz6GzBKslePyepc2iB6gh
axGgoHvhRRjELADnhpNcJ5pi35peiqkXz0/XYt3TNao4Mg3gIZxdDpiadj/OUgW/BIk/DGjl6Tal
Xq/xMBAUAszFJfCG5PZSIjWl44ujil0KWbMWbMmUlPHJK2OEmBa1cdHjJJMhBdy8D8oZrgr4DnT3
qjs94X9GhGNgO0mkhiejpT0nzEClq8NH+ign8cLwr8xffBGH1p/rzmJXiiTwWcA727HvB3pGjaYZ
Yn70/x4xYoYXgAzCpTWVBNBA4nm3KOu7fJuJyqk7UcUAWkFgifxAi+wW//CUDvtHKlpqgt4Q9kQb
63rrdu3zUSCx2OqKDkwZtT3KLwjh5og7GbXCBzEHhjlH+f6UApcphONyYNtK2o13GhmcnAuYLMsO
paNOUflz49xWXcU9ALjCN2xAbJeDYzk5Jq/bVmcUaG9yWx7GkiTSVQ+dsFrKfoQQkxz8cMtE+oZX
oN/NwdblslPPGUpK53rdz51+Ev3CPgPlkpEK2gvuAfnkKg5O3c2I/dt+cQak0n+D7RY0DyVIaQi0
kQqs1eYaVXvyUJx2rnnpXsJCPU/TmyOXkGdvbNef/pjz9ikWVhgRIqEXkjc1RRWq+shvPm2dSKrj
yWhcRCLst9x7iDkXqF5RSGNdFS1CDSxkmThiwsIWL6hNpiTjo9hU2r0T+ZQ8gF8WytMR4oVAP2QE
MLeWtdrWr4Vm6FxVASIGrLMSdsVZ3V+Ujc50diitso6Prxz50+5mN/C59zbmyJifTV5GuXX+W4rM
vLBaF7hsBgbDNLFUAOyzCGpz8Sade/htJFJYemR7NK6NfByfNVq73PeRQecunDxuKIwzW6KX8FQh
U/UFM8oVRltmbdai/UQa3N06CE38u85Z/+D8DtRaK5Akk7Q7R5L32wQjTYEv8CpLQyYaMGtY6y0/
8Gi6qqpgm0aB1IBlgXb17bmpyk26sdRLwVQW4dvm5LE6S5xueZTv1n54WvpD8nM0JZ9R1iiahuKm
+xRh3u0Mzgl+dKkFchVAvSmmqNQIo7TLok/9LLbzgVhjTXR9IdVNsSpbGE45A0UiQ6yibe00Ki5y
PLEgT3n8dNfj5WM4JGqlhMS/H27OP4tb9QJyDR8vsGQps424Uz4y9FUKqQfCGTYDpKUhLDqFJhGn
+jEdZwKq2QXojo5ZbkDGc3EIzWUxqwBr41I20FzU7QZHXPRejkHFHxNw6gXTJAOjmV6FDo9ca2BD
yu/aMM6WMhprFMcxM4Mhi/WSTCXIrKZmmEQRomYGeQiC5ijJ7p8FRBYmR7Pz0+E3NHTQB4IXbdHq
lOlII829XI10z3imhrIhFPIEHTXKbbo4366rJnaQoPdIpAb6I7MuAAmA1J8GmxsUPlM6mxosJTn9
TM90c79AAPCSWaNNMCRDuFracdcM8rS2nW9jzq9ONOJ/k465H0JgP1tZl7oHzks+Zqk1DM/VKkNf
cRKmjl13k23nOAhMG7Ny5YEDd/XCLL2FA6xd7ZGPWhxJ09kskkncPccSTrYuNF8elV1U1q1thZjR
FmOVcNZSYLfYJWSj7stotOEeV5sWkt1VcoQ4rwB8GbbC6kOPITMKuTx3ReMJRh0YX2kIYDpaNkEx
QaOIdD9dAAAAAM5eR2lsJEEsAAHpCYBQAABtZOt+scRn+wIAAAAABFla
--089e015383e40bb66404ee73dcca--
