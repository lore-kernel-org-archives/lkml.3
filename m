Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbaDWHKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 03:10:30 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:51792 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbaDWHK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 03:10:27 -0400
MIME-Version: 1.0
In-Reply-To: <20140422123914.GB1053@distanz.ch>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
	<1397824031-4892-20-git-send-email-lftan@altera.com>
	<20140422123914.GB1053@distanz.ch>
Date: Wed, 23 Apr 2014 15:10:26 +0800
X-Google-Sender-Auth: B5Tq73c85QrAorPiD0oJTc_vqvM
Message-ID: <CAFiDJ5-S8bD7Z+5XcwUK_mZ+ShCMp5nj7km4NSn+Ecck3xnBxQ@mail.gmail.com>
Subject: Re: [PATCH 23/28] nios2: Nios2 registers
From: Ley Foon Tan <lftan@altera.com>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        cltang@codesourcery.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tobias


On Tue, Apr 22, 2014 at 8:39 PM, Tobias Klauser <tklauser@distanz.ch> wrote:
> On 2014-04-18 at 14:27:06 +0200, Ley Foon Tan <lftan@altera.com> wrote:

>> +
>> +/* estatus register bits */
>> +#define ESTATUS_EPIE (1 << 0)        /* processor interrupt enable */
>> +#define ESTATUS_EU   (1 << 1)        /* user mode */
>> +#define ESTATUS_EH   (1 << 2)        /* Exception mode */
>> +
>> +/* tlbmisc register bits */
>> +#define TLBMISC_PID_SHIFT    4
>> +#define TLBMISC_PID_MASK     ((1UL << cpuinfo.tlb_pid_num_bits) - 1)
>
> You should probably #include <asm/cpuinfo.h> here since struct cpuinfo
> is used in the definition.
Okay, but I think we should add #ifndef __ASSEMBLY__ at #include
<asm/cpuinfo.h> and at line #define TLBMISC_PID_MASK.
Assembly source file might include this file as well.

>
>> +#define TLBMISC_WAY_MASK     0xf
>> +#define TLBMISC_WAY_SHIFT    20
>> +
>> +#define TLBMISC_PID  (TLBMISC_PID_MASK << TLBMISC_PID_SHIFT) /* TLB PID */
>> +#define TLBMISC_WE   (1 << 18)       /* TLB write enable */
>> +#define TLBMISC_RD   (1 << 19)       /* TLB read */
>> +#define TLBMISC_WAY  (TLBMISC_WAY_MASK << TLBMISC_WAY_SHIFT) /* TLB way */
>> +
>> +#endif /* _ASM_NIOS2_REGISTERS_H */

>>
