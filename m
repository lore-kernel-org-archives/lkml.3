Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbaE0JYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 05:24:25 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:55103 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbaE0JYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 05:24:23 -0400
Message-ID: <538459C2.90408@redhat.com>
Date: Tue, 27 May 2014 11:24:18 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Nadav Amit <namit@cs.technion.ac.il>
CC: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH kvm-unit-tests] x86: test mov DR with ignored mod bits
References: <538330D8.40602@redhat.com> <1401138417-29949-1-git-send-email-namit@cs.technion.ac.il>
In-Reply-To: <1401138417-29949-1-git-send-email-namit@cs.technion.ac.il>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 26/05/2014 23:06, Nadav Amit ha scritto:
> Tests whether the emulator ignores the mod bits on mov DR instruction.  The
> test performs regular mov to DR0 and reads back the data using custom mov from
> DR0 while mod bits are set to zero. The expected result is obviously the value
> which was written to DR0 before.
>
> The test is performed in realmode and is only expected to fail if the CPU does
> not support unrestricted mode. Note that mov-CR/DR in protected mode are
> usually not handled by the emulator, as their data is available in the exit
> information fields.
>
> Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
> ---
>  x86/realmode.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/x86/realmode.c b/x86/realmode.c
> index 9c22d41..839ac34 100644
> --- a/x86/realmode.c
> +++ b/x86/realmode.c
> @@ -1636,6 +1636,16 @@ static void test_perf_memory_rmw(void)
>  	print_serial(" cycles/emulated memory RMW instruction\n");
>  }
>
> +void test_dr_mod(void)
> +{
> +	MK_INSN(drmod, "movl %ebx, %dr0\n\t"
> +		       ".byte 0x0f \n\t .byte 0x21 \n\t .byte 0x0\n\t");
> +	inregs.eax = 0xdead;
> +	inregs.ebx = 0xaced;
> +	exec_in_big_real_mode(&insn_drmod);
> +	report("mov dr with mod bits", R_AX | R_BX, outregs.eax == 0xaced);
> +}
> +
>  void realmode_start(void)
>  {
>  	test_null();
> @@ -1681,6 +1691,7 @@ void realmode_start(void)
>  	test_xlat();
>  	test_salc();
>  	test_fninit();
> +	test_dr_mod();
>  	test_nopl();
>  	test_perf_loop();
>  	test_perf_mov();
>

Thanks, applied.

Paolo
