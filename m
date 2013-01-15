Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309Ab3AOSiW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:38:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755462Ab3AOSiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:38:20 -0500
Message-ID: <50F5A215.5020708@redhat.com>
Date: Tue, 15 Jan 2013 13:38:13 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Gleb Natapov <gleb@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [RFCv3][PATCH 2/3] fix kvm's use of __pa() on percpu areas
References: <20130109185904.DD641DCE@kernel.stglabs.ibm.com> <20130109185905.0DCFC236@kernel.stglabs.ibm.com>
In-Reply-To: <20130109185905.0DCFC236@kernel.stglabs.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2013 01:59 PM, Dave Hansen wrote:
> In short, it is illegal to call __pa() on an address holding
> a percpu variable.  The times when this actually matters are
> pretty obscure (certain 32-bit NUMA systems), but it _does_
> happen.  It is important to keep KVM guests working on these
> systems because the real hardware is getting harder and
> harder to find.
>
> This bug manifested first by me seeing a plain hang at boot
> after this message:
>
> 	CPU 0 irqstacks, hard=f3018000 soft=f301a000
>
> or, sometimes, it would actually make it out to the console:
>
> [    0.000000] BUG: unable to handle kernel paging request at ffffffff
>
> I eventually traced it down to the KVM async pagefault code.
> This can be worked around by disabling that code either at
> compile-time, or on the kernel command-line.

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
