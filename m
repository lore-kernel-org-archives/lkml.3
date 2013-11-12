Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab3KLOiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:38:55 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:42987 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab3KLOix convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:38:53 -0500
MIME-Version: 1.0
In-Reply-To: <yw1xd2m5vg9j.fsf@unicorn.mansr.com>
References: <CAGG-pUQrN6D_iSsWVptjQSA4B_oGn5NhbhBp+aLT0GJCFSmYRA@mail.gmail.com>
	<yw1xd2m5vg9j.fsf@unicorn.mansr.com>
Date: Tue, 12 Nov 2013 12:38:53 -0200
Message-ID: <CAGG-pUTZMpPWGzigXhW9AcrGDksEGLJyPPBtDVo65nFGNPP=aw@mail.gmail.com>
Subject: Re: [RFC] Coverity 1128445 - Reliance on integer endianness
From: =?ISO-8859-1?Q?Geyslan_Greg=F3rio_Bem?= <geyslan@gmail.com>
To: =?ISO-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, Ingo Molnar <mingo@redhat.com>,
        acme@ghostprotocols.net, kernel-br <kernel-br@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/11/12 Måns Rullgård <mans@mansr.com>:
> Geyslan Gregório Bem <geyslan@gmail.com> writes:
>
>> Hi,
>>
>> Coverity detected in 'arch/x86/kernel/cpu/perf_event_intel_uncore.c' a
>> possible reliance on integer endianness. Is that a positive one?
>
> No, x86 is always little endian.
>
>> static u64 ivt_uncore_irp_read_counter(struct intel_uncore_box *box,
>> struct perf_event *event)
>> 1369{
>> 1370        struct pci_dev *pdev = box->pci_dev;
>> 1371        struct hw_perf_event *hwc = &event->hw;
>> 1372        u64 count = 0;
>> 1373
>>
>> CID 1128445 (#1 of 1): Reliance on integer endianness
>> (INCOMPATIBLE_CAST)incompatible_cast: Pointer "&count" points to an
>> object whose effective type is "unsigned long long" (64 bits,
>> unsigned) but is dereferenced as a narrower "unsigned int" (32 bits,
>> unsigned). This may lead to unexpected results depending on machine
>> endianness.[show details]
>>
>> 1374        pci_read_config_dword(pdev, ivt_uncore_irp_ctrs[hwc->idx],
>> (u32 *)&count);
>> 1375        pci_read_config_dword(pdev, ivt_uncore_irp_ctrs[hwc->idx]
>> + 4, (u32 *)&count + 1);
>> 1376
>> 1377        return count;
>> 1378}
>
> This looks intentional and correct apart from possible strict aliasing
> issues.
>
> --
> Måns Rullgård
> mans@mansr.com

All right. Thanks.

-- 
Regards,

Geyslan G. Bem
hackingbits.com
