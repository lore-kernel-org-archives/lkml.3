Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab3KUSLd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 13:11:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55229 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569Ab3KUSLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 13:11:31 -0500
Message-ID: <528E4CBA.8000808@zytor.com>
Date: Thu, 21 Nov 2013 10:11:06 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Akinobu Mita <akinobu.mita@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Subject: Re: [PATCH] x86: enable DMA CMA with swiotlb
References: <1384903939-3371-1-git-send-email-akinobu.mita@gmail.com>	<528D4A1A.2050100@zytor.com> <CAC5umyh0Hfx3NgHX11eqskuifhrdYGB8L1nx1u0YUdBGchRTxw@mail.gmail.com>
In-Reply-To: <CAC5umyh0Hfx3NgHX11eqskuifhrdYGB8L1nx1u0YUdBGchRTxw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2013 07:02 AM, Akinobu Mita wrote:
> 
> I want to use DMA CMA for the feature that requires a single huge chunk
> (about 64MB) of host memory.

That is tautological.  "I want to use the Contiguous Memory Allocator to
allocate contiguous memory."

> Please refer 3 of 24 in:
> http://www.jedec.org/sites/default/files/T_Fujisawa_MF_2013.pdf

But yes, it makes sense that a device using host memory would not be
able to leverage swiotlb, because the software simply has no clue what
the DMA transactions are.  In that sense it is fundamentally different
from a real IOTLB.

	-hpa

