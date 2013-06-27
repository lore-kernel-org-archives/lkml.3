Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab3F0KVd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 06:21:33 -0400
Received: from intranet.asianux.com ([58.214.24.6]:55381 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab3F0KVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 06:21:32 -0400
X-Spam-Score: -100.9
Message-ID: <51CC11F7.2060306@asianux.com>
Date: Thu, 27 Jun 2013 18:20:39 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: arm64: include: asm: add pci.h to pass compiling
References: <51CA5F71.207@asianux.com> <20130626140730.GB23309@arm.com> <51CB87B0.8030805@asianux.com> <9028702.KGsxCx1772@wuerfel>
In-Reply-To: <9028702.KGsxCx1772@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2013 04:43 PM, Arnd Bergmann wrote:
> On Thursday 27 June 2013 08:30:40 Chen Gang wrote:
>> > On 06/26/2013 10:07 PM, Catalin Marinas wrote:
>>> > > On Wed, Jun 26, 2013 at 04:26:41AM +0100, Chen Gang wrote:
>>> > > I wonder whether it makes sense to include pci-dma-compat.h in
>>> > > asm-generic/pci.h, I don't see why one would want the generic pci.h but
>>> > > not the generic pci-dma-compat.h (cc'ing Arnd).
>> > 
>> > I think, it will let architecture guys easier to add their own
>> > pci-dma-compat.h (although they still need generic pci_dma_compat.h, and
>> > generic pci.h, too).
>> > 
>> > e.g. one architecture want include generic pci-dma-compat.h firstly,
>> > then define its own features in its own pci-dma-compat.h.
> I think there is no excuse for still keeping the asm-generic/pci-dma-compat.h
> header around any more.
> 
> All architectures use the same implementation and have done so for years.
> We should just convert the remaining users to use the dma_mapping.h
> interfaces directly.

in "asm-generic/pci-dma-compat.h", it include "linux/dma-mapping.h" firstly.

So can we say it also has additional features (at least for compatible
old things) which "dma-mapping.h" not have ?

Thanks.
-- 
Chen Gang
