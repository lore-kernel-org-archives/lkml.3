Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab3EVSTq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 14:19:46 -0400
Received: from mout.gmx.net ([212.227.17.22]:49831 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756653Ab3EVSTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 14:19:43 -0400
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX19Rftd4tVdRqpL3LCVw4ZL4k2L9e6b4CVApd+kowU
	EmEWE3tNPdeAoN
Message-ID: <519D0C39.6090201@gmx.de>
Date: Wed, 22 May 2013 20:19:37 +0200
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Damian Hobson-Garcia <dhobsong@igel.co.jp>
CC: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        linux-arm-kernel@lists.infradead.org, msalter@redhat.com,
        linux-c6x-dev@linux-c6x.org, linux-parisc@vger.kernel.org
Subject: Re: [PATCH v2 0/4] dma-mapping: Define dma_{alloc,free}_attrs() for
 all archs
References: <1367290899-10410-1-git-send-email-dhobsong@igel.co.jp> <519C2F5D.8000809@igel.co.jp>
In-Reply-To: <519C2F5D.8000809@igel.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2013 04:37 AM, Damian Hobson-Garcia wrote:
> Hello,
> On 2013/04/30 12:01, Damian Hobson-Garcia wrote:
>> Most architectures that define CONFIG_HAVE_DMA=y, have implementations for
>> both dma_alloc_attrs() and dma_free_attrs().  All achitectures that do
>> not define CONFIG_HAVE_DMA also have both of these definitions provided by
>> dma-mapping-broken.h.
>>
>> Provide a default definition for the archs that define CONFIG_HAVE_DMA=y,
>> but have no implementation for dma_{alloc,free}_attrs(). 
>>
>> As I don't have hardware for any of these systems, the patches are only
>> compile-tested where I could (arm64, s390) and untested for the archs
>> where I couldn't find a readily available prebuilt cross-compiler (c6x, parisc).
>>
> 
> 
>>  arch/arm64/include/asm/dma-mapping.h  |   17 +++++++++++------
>>  arch/c6x/include/asm/dma-mapping.h    |    3 +++
>>  arch/parisc/include/asm/dma-mapping.h |    3 +++
>>  arch/s390/include/asm/dma-mapping.h   |   17 +++++++++++------
>>  4 files changed, 28 insertions(+), 12 deletions(-)
>>
> 
> Since this series spans several architectures, what would be the best
> way to have this patch series merged?
> Should I resubmit each patch to the mailing list for each architecture
> separately?

I already pushed the parisc change upstream.
See commit 7f64fb41aad9a8504dd76e81b2391eae64e1498a

Helge
