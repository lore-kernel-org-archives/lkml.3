Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414AbaIRRAC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 13:00:02 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:17197 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932173AbaIRRAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 13:00:00 -0400
Message-ID: <541B0E35.4090302@oracle.com>
Date: Thu, 18 Sep 2014 12:54:13 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Andrey Ryabinin <a.ryabinin@samsung.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Dave Hansen <dave.hansen@intel.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Christoph Lameter <cl@linux.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC/PATCH v2 02/10] x86_64: add KASan support
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com> <1410359487-31938-1-git-send-email-a.ryabinin@samsung.com> <1410359487-31938-3-git-send-email-a.ryabinin@samsung.com> <5410724B.8000803@intel.com> <CAPAsAGzm29VWz8ZvOu+fVGn4Vbj7bQZAnB11M5ZZXRTQTchj0w@mail.gmail.com> <5410D486.4060200@intel.com> <9E98939B-E2C6-4530-A822-ED550FC3B9D2@zytor.com> <54112512.6040409@oracle.com> <54118CC9.8070405@samsung.com>
In-Reply-To: <54118CC9.8070405@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2014 07:51 AM, Andrey Ryabinin wrote:
> On 09/11/2014 08:29 AM, Sasha Levin wrote:
>> > On 09/11/2014 12:26 AM, H. Peter Anvin wrote:
>>> >> Except you just broke PVop kernels.
>> > 
>> > So is this why v2 refuses to boot on my KVM guest? (was digging
>> > into that before I send a mail out).
>> > 
> Maybe this will help?
> 
> 
> From: Andrey Ryabinin <a.ryabinin@samsung.com>
> Subject: [PATCH] x86_64: kasan: fix kernel boot with CONFIG_DEBUG_VIRTUAL=y
> 
> Use __pa_nodebug instead of __pa before shadow initialized.
> __pa with CONFIG_DEBUG_VIRTUAL=y may result in __asan_load
> call before shadow area initialized.

Woops, I got sidetracked and forgot to reply. Yes, this patch fixed
the issue, KASan is running properly now.


Thanks,
Sasha
