Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbaGIXdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 19:33:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:58745 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753945AbaGIXdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 19:33:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,634,1400050800"; 
   d="scan'208";a="541145302"
Message-ID: <53BDD135.1000105@intel.com>
Date: Wed, 09 Jul 2014 16:33:09 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>, Andi Kleen <andi@firstfloor.org>
CC: Andrey Ryabinin <a.ryabinin@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Alexey Preobrazhensky <preobr@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        kbuild <linux-kbuild@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, x86 maintainers <x86@kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [RFC/PATCH RESEND -next 00/21] Address sanitizer for kernel (kasan)
 - dynamic memory error detector.
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>	<53BDB1D6.1090605@intel.com>	<8761j6nr53.fsf@tassilo.jf.intel.com> <CAOMGZ=Fmqg6MWyx3NygqVmYiqw=npkPQrO9ifhF489bq5Gxz4A@mail.gmail.com>
In-Reply-To: <CAOMGZ=Fmqg6MWyx3NygqVmYiqw=npkPQrO9ifhF489bq5Gxz4A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2014 02:59 PM, Vegard Nossum wrote:
>> > But I could see KASAN eventually deprecating kmemcheck, which
>> > is just incredible slow.
> FWIW, I definitely agree with this -- if KASAN can do everything that
> kmemcheck can, it is no doubt the right way forward.

That's very cool.  For what it's worth, the per-arch work does appear to
be pretty minimal and the things like the string function replacements
_should_ be able to be made generic.  Aren't the x86_32/x86_64 and arm
hooks pretty much copied-and-pasted?

