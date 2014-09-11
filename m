Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870AbaIKE1V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 00:27:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33056 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbaIKE1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 00:27:20 -0400
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC/PATCH v2 02/10] x86_64: add KASan support
From: "H. Peter Anvin" <hpa@zytor.com>
X-Mailer: iPad Mail (11D257)
In-Reply-To: <5410D486.4060200@intel.com>
Date: Wed, 10 Sep 2014 21:26:46 -0700
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Content-Transfer-Encoding: 7bit
Message-Id: <9E98939B-E2C6-4530-A822-ED550FC3B9D2@zytor.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com> <1410359487-31938-1-git-send-email-a.ryabinin@samsung.com> <1410359487-31938-3-git-send-email-a.ryabinin@samsung.com> <5410724B.8000803@intel.com> <CAPAsAGzm29VWz8ZvOu+fVGn4Vbj7bQZAnB11M5ZZXRTQTchj0w@mail.gmail.com> <5410D486.4060200@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Except you just broke PVop kernels.

Sent from my tablet, pardon any formatting problems.

> On Sep 10, 2014, at 15:45, Dave Hansen <dave.hansen@intel.com> wrote:
> 
>> On 09/10/2014 01:30 PM, Andrey Ryabinin wrote:
>> Yes, there is a reason for this. For inline instrumentation we need to
>> catch access to userspace without any additional check.
>> This means that we need shadow of 1 << 61 bytes and we don't have so
>> many addresses available.
> 
> That sounds reasonable.
