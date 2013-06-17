Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab3FQVIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 17:08:38 -0400
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:36431
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753540Ab3FQVIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 17:08:37 -0400
Message-ID: <51BF7ABD.3080508@caviumnetworks.com>
Date: Mon, 17 Jun 2013 14:08:13 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        David Daney <david.daney@cavium.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: Linux 3.10-rc6
References: <CA+55aFwdcdf0Zy82P70YsaF2Kqf4UTKKeDfMN0MPXXwSrGr4yw@mail.gmail.com> <CAMuHMdWMYxg9QC_4EpDgcgevsTAt=3v6iaCa0cHxtzYbMheQ-w@mail.gmail.com> <CA+55aFzw7b7qH37ZLSCAZ8xTd5ez2q44LmeY+GLFPsHEqDPfxA@mail.gmail.com> <20130617133055.20463ce157e104af15ef60a1@linux-foundation.org> <51BF7610.10803@caviumnetworks.com> <20130617135920.587959a34da85d7940a6936f@linux-foundation.org>
In-Reply-To: <20130617135920.587959a34da85d7940a6936f@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-Forefront-PRVS: 0880FB6EC1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(24454002)(51704005)(199002)(189002)(69234005)(479174002)(377454002)(74706001)(65956001)(16406001)(59896001)(23756003)(80022001)(51856001)(66066001)(65806001)(36756003)(69226001)(74876001)(53806001)(56816003)(74662001)(77096001)(81342001)(49866001)(64126003)(33656001)(47976001)(81542001)(47776003)(53416002)(47736001)(74366001)(47446002)(76482001)(54316002)(50986001)(31966008)(63696002)(76796001)(4396001)(56776001)(77982001)(74502001)(59766001)(50466002)(76786001)(79102001)(46102001)(54356001);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR07MB017;H:BY2PRD0712HT003.namprd07.prod.outlook.com;RD:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: DuplicateDomain-a3ec847f-e37f-4d9a-9900-9d9d96f75f58.caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2013 01:59 PM, Andrew Morton wrote:
> On Mon, 17 Jun 2013 13:48:16 -0700 David Daney <ddaney@caviumnetworks.com> wrote:
>
>> On 06/17/2013 01:30 PM, Andrew Morton wrote:
>> [...]
>>>
>>> From: Andrew Morton <akpm@linux-foundation.org>
>>> Subject: include/linux/smp.h:on_each_cpu(): switch back to a macro
>>>
>>> f21afc25f9ed4 ("smp.h: Use local_irq_{save,restore}() in !SMP version of
>>> on_each_cpu()") converted on_each_cpu() to a C function.  This required
>>> inclusion of irqflags.h, which broke ia64 and mn10300 (at least) due to
>>> header ordering hell.
>>>
>>> Switch on_each_cpu() back to a macro to fix this.
>>
>> FYI:  I have already sent a pair of patches that fix the include
>> dependencies:
>>
>> https://lkml.org/lkml/2013/6/16/113
>> https://lkml.org/lkml/2013/6/17/422
>
> I wasn't cc'ed.
>
>> Obviously, it is Linus' choice as to how best to handle the failure, but
>> I think it is important to know that there are two options (fixing ia64
>> and mn10300, or reverting the patch).
>
> I certainly prefer the inline function over a crappy macro.  The
> additional nested include is regrettable - more complexity.
>
> Also, it's good to have the SMP and non-SMP versions either both using
> macros or both using C.  Having them different can cause irritating
> unused-variable compilation warnings when using the macro version.

Although all these points are true, they are not why I wrote the patch.

The key difference, for me, between the SMP and !SMP versions is that 
the !SMP version unconditionally enables interrupts, and this enabling 
interrupts breaks my kernel

>
> I think switch-back-to-a-macro is simplest and safest for now.  Perhaps
> you can queue a 3.11 patch which restores the C function and fixes up
> mn10300 and ia64?
>

If the patch is reverted, I will do that.

David Daney

