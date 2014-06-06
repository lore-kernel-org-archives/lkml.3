Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbaFFGaz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 02:30:55 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:33834 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaFFGay convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 02:30:54 -0400
MIME-Version: 1.0
In-Reply-To: <539152B3.5070702@linux.vnet.ibm.com>
References: <1401981695-3682-1-git-send-email-shreyas@linux.vnet.ibm.com>
	<539152B3.5070702@linux.vnet.ibm.com>
Date: Fri, 6 Jun 2014 08:30:52 +0200
X-Google-Sender-Auth: T98qHPrcs7kdhHELfRQWioz53e8
Message-ID: <CAMuHMdXrKUoj_+ApkJpyxKSUiduTNJ4svJD0qNcMbSM1CspiEw@mail.gmail.com>
Subject: Re: [PATCH 1/2] powerpc/powernv: include asm/smp.h to handle UP config
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 6, 2014 at 7:33 AM, Anshuman Khandual
<khandual@linux.vnet.ibm.com> wrote:
> On 06/05/2014 08:51 PM, Shreyas B. Prabhu wrote:
>> Build throws following errors when CONFIG_SMP=n
>> arch/powerpc/platforms/powernv/setup.c: In function ‘pnv_kexec_wait_secondaries_down’:
>> arch/powerpc/platforms/powernv/setup.c:179:4: error: implicit declaration of function ‘get_hard_smp_processor_id’
>>     rc = opal_query_cpu_status(get_hard_smp_processor_id(i),
>>
>> The usage of get_hard_smp_processor_id() needs the declaration from
>> <asm/smp.h>. The file setup.c includes <linux/sched.h>, which in-turn
>> includes <linux/smp.h>. However, <linux/smp.h> includes <asm/smp.h>
>> only on SMP configs and hence UP builds fail.
>>
>> Fix this by directly including <asm/smp.h> in setup.c unconditionally.
>
> Can you please clean up the description in the commit message ? and also
> the first line in the commit message should mention that the patch is
> trying to fix a UP specific build failure.

Both the one-line summary and the first line already mention "UP" or
"CONFIG_SMP=n".

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
