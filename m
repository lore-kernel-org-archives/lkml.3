Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416Ab3EWCrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 22:47:15 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:40296 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757150Ab3EWCrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 22:47:13 -0400
Message-ID: <519D8331.3060203@igel.co.jp>
Date: Thu, 23 May 2013 11:47:13 +0900
From: Damian Hobson-Garcia <dhobsong@igel.co.jp>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        "linux-c6x-dev@linux-c6x.org" <linux-c6x-dev@linux-c6x.org>,
        "deller@gmx.de" <deller@gmx.de>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] dma-mapping: Define dma_{alloc,free}_attrs() for
 all archs
References: <1367290899-10410-1-git-send-email-dhobsong@igel.co.jp> <519C2F5D.8000809@igel.co.jp> <20130522094741.GE14322@arm.com>
In-Reply-To: <20130522094741.GE14322@arm.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,
On 2013/05/22 18:47, Catalin Marinas wrote:
> On Wed, May 22, 2013 at 03:37:17AM +0100, Damian Hobson-Garcia wrote:
>> Hello,
>> On 2013/04/30 12:01, Damian Hobson-Garcia wrote:
>>> Most architectures that define CONFIG_HAVE_DMA=y, have implementations for
>>> both dma_alloc_attrs() and dma_free_attrs().  All achitectures that do
>>> not define CONFIG_HAVE_DMA also have both of these definitions provided by
>>> dma-mapping-broken.h.
> 
> BTW, shouldn't this be called CONFIG_HAVE_DMA_ATTRS?

CONFIG_HAVE_DMA_ATTRS is currently used to enable the functions to
set/get the DMA attribute values. Poking through the headers, it looks
like the struct dma_attrs is defined regardless of the
CONFIG_HAVE_DMA_ATTRS setting, so in that respect
we always seem to "have" DMA attributes (if we have DMA), but they may
not always be meaningful (ie. set to some value).

> 
>>> Provide a default definition for the archs that define CONFIG_HAVE_DMA=y,
>>> but have no implementation for dma_{alloc,free}_attrs(). 
>>>
>>> As I don't have hardware for any of these systems, the patches are only
>>> compile-tested where I could (arm64, s390) and untested for the archs
>>> where I couldn't find a readily available prebuilt cross-compiler (c6x, parisc).
>>
>>>  arch/arm64/include/asm/dma-mapping.h  |   17 +++++++++++------
>>>  arch/c6x/include/asm/dma-mapping.h    |    3 +++
>>>  arch/parisc/include/asm/dma-mapping.h |    3 +++
>>>  arch/s390/include/asm/dma-mapping.h   |   17 +++++++++++------
>>>  4 files changed, 28 insertions(+), 12 deletions(-)
>>>
>>
>> Since this series spans several architectures, what would be the best
>> way to have this patch series merged?
>> Should I resubmit each patch to the mailing list for each architecture
>> separately?
> 
> I'm happy to take the arm64 patch.
Very much appreciated.

> 
> Thanks.
> 
Damian
-- 
Damian Hobson-Garcia
IGEL Co.,Ltd
http://www.igel.co.jp
