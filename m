Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944AbaIJWq7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 18:46:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:25802 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbaIJWq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 18:46:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,501,1406617200"; 
   d="scan'208";a="601114814"
Message-ID: <5410D486.4060200@intel.com>
Date: Wed, 10 Sep 2014 15:45:26 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
CC: Andrey Ryabinin <a.ryabinin@samsung.com>,
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
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC/PATCH v2 02/10] x86_64: add KASan support
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>	<1410359487-31938-1-git-send-email-a.ryabinin@samsung.com>	<1410359487-31938-3-git-send-email-a.ryabinin@samsung.com>	<5410724B.8000803@intel.com> <CAPAsAGzm29VWz8ZvOu+fVGn4Vbj7bQZAnB11M5ZZXRTQTchj0w@mail.gmail.com>
In-Reply-To: <CAPAsAGzm29VWz8ZvOu+fVGn4Vbj7bQZAnB11M5ZZXRTQTchj0w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2014 01:30 PM, Andrey Ryabinin wrote:
> Yes, there is a reason for this. For inline instrumentation we need to
> catch access to userspace without any additional check.
> This means that we need shadow of 1 << 61 bytes and we don't have so
> many addresses available.

That sounds reasonable.
