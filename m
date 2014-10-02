Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbaJBOtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 10:49:20 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:33062 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbaJBOtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 10:49:19 -0400
Message-ID: <542D65E9.7020207@oracle.com>
Date: Thu, 02 Oct 2014 10:49:13 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Chuck Ebbert <cebbert.lkml@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: pipe/page fault oddness.
References: <20140930033327.GA14558@redhat.com>	<20140930043309.GA16196@redhat.com>	<CA+55aFwxdOBKHwwp7Zq1k19mHCyHYmYqigCVt59AtB-P7Zva1w@mail.gmail.com>	<CA+55aFynr-Abo_JY1=GGOf9e2tjJvexbX2kVTgD0bkq7BXacJw@mail.gmail.com>	<20140930160510.GA15903@redhat.com>	<CA+55aFzTEXxxh_4_BwVydw1UgCu-NRF95OrzVhj=cievXFTJTg@mail.gmail.com>	<20140930162201.GC15903@redhat.com>	<20140930164047.GA18354@redhat.com>	<CA+55aFzKgJ41Mp=Ub8Kq_uFDHYzkHo3zhO3MHOJo_O2iExdYmQ@mail.gmail.com>	<20140930182059.GA24431@redhat.com>	<CA+55aFzfvXHd2LUhQ5OiV1H1Oq2y3PL8hX_Hrv-C907PyDNugA@mail.gmail.com>	<alpine.LSU.2.11.1410010031070.1902@eggly.anvils>	<CA+55aFyJ09+iv2HX1nfAaDi0-7=L3KxKi11CACbM8K_Coo6kzg@mail.gmail.com>	<CA+55aFzHgemAV7igyG=0pmctTaV7cZfO4fdqukhrCc8VXTrZuw@mail.gmail.com>	<CA+55aFzisEwtcBA93Xo74RM-6X9V=_go=YhN7eFJOHLeHs3HEQ@mail.gmail.com>	<542C7B5E.2020000@oracle.com>	<20141001172804.16e5986a@as>	<542CC73F.8050907@oracle.com> <20141002030300.1d2788ca@as>
In-Reply-To: <20141002030300.1d2788ca@as>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2014 04:03 AM, Chuck Ebbert wrote:
> On Wed, 01 Oct 2014 23:32:15 -0400
> Sasha Levin <sasha.levin@oracle.com> wrote:
> 
>> On 10/01/2014 06:28 PM, Chuck Ebbert wrote:
>>> On Wed, 01 Oct 2014 18:08:30 -0400
>>> Sasha Levin <sasha.levin@oracle.com> wrote:
>>>
>>>>> On 10/01/2014 04:20 PM, Linus Torvalds wrote:
>>>>>>> So I'm really sending this patch out in the hope that it will get
>>>>>>> comments, fixup and possibly even testing by people who actually know
>>>>>>> the NUMA balancing code. Rik?  Anybody?
>>>>>
>>>>> Hi Linus,
>>>>>
>>>>> I've tried this patch on the same configuration that was triggering
>>>>> the VM_BUG_ON that Hugh mentioned previously. Surprisingly enough it
>>>>> ran fine for ~20 minutes before exploding with:
>>>>>
>>>>> [ 2781.566206] kernel BUG at mm/huge_memory.c:1293!
>>> That's:
>>> 	BUG_ON(is_huge_zero_page(page));
>>>
>>> Can you change your scripts to show the source code line when
>>> the error is a BUG_ON()? The machine code disassembly after the
>>> oops message doesn't really help.
>>>
>>
>> Hum? The source code line is the first line in the trace:
>>
>> 	[ 2781.566206] kernel BUG at mm/huge_memory.c:1293!
>>
> 
> I meant, display the contents of that line so we can see what the
> BUG_ON() was triggered by. In some cases you might have a custom patch
> applied or be running a version that some people don't have handy.

Ah, the actual content? That's a good point - let me look into that.


Thanks,
Sasha

