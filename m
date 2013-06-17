Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab3FQAjr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 20:39:47 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:54307 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618Ab3FQAjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 20:39:46 -0400
MIME-Version: 1.0
In-Reply-To: <20130616091005.GP18614@n2100.arm.linux.org.uk>
References: <1371338108-26354-1-git-send-email-grant.likely@linaro.org> <20130616091005.GP18614@n2100.arm.linux.org.uk>
From: Grant Likely <grant.likely@linaro.org>
Date: Mon, 17 Jun 2013 01:39:25 +0100
X-Google-Sender-Auth: 8feRIaNji7Z_Dn3XJGgFXPccvks
Message-ID: <CACxGe6vy6kNzmP7s1NPvKYCfe+1mKHGJbOobr9Kxy=J16r2L0A@mail.gmail.com>
Subject: Re: [RFC] arm: Remove sa1111 special case from mm setup code
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Nicolas Pitre <nico@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 16, 2013 at 10:10 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sun, Jun 16, 2013 at 12:15:08AM +0100, Grant Likely wrote:
>> I don't think this special case is needed anymore. From what I can tell,
>> setup_dma_zone() takes care of marking the region to be reserved for
>> DMA, and that happens before arm_memblock_init() which calls
>> arm_mm_memblock_reserve(). Therefore the mm setup should already know
>> about the reserved region and it won't need to be explicitly reserved
>> and then freed. That means the special case can be dropped from the
>> common code.
>
> No it doesn't.  setup_dma_zone is all about setting the high watermark
> for GFP_DMA allocations.  It has nothing to do with _temoprarily_
> reserving the low 1MB, ensuring that no other user can use any of that
> precious SA1111 memory during the kernel boot.

Ah, okay. So it's to protect against early allocations. All right,
I've got an alternate patch that at least gets rid of one of the
special case hooks. I'll post that one shortly.

g.
