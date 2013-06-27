Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab3F0Ilo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 04:41:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51624 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab3F0Ilm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 04:41:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chen Gang <gang.chen@asianux.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: arm64: include: asm: add pci.h to pass compiling
Date: Thu, 27 Jun 2013 10:43:01 +0200
Message-ID: <9028702.KGsxCx1772@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.4; x86_64; ; )
In-Reply-To: <51CB87B0.8030805@asianux.com>
References: <51CA5F71.207@asianux.com> <20130626140730.GB23309@arm.com> <51CB87B0.8030805@asianux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:03xGBo8IpoipFjunusAhViLK9L4dECiefFBqOaGFBaE
 JvH1L7ANkmvUJAnVKGI3F3L3C5OnfQEncm3PRT8x4ReuFSQNu/
 y6ihEZpGQJQbAbQzn+pcQI0xF0iuQlDw4LopPzKC2A/er0H5QJ
 4SL2RBg/vo4KEPRfCXhRYk2rQKVrS70zTd9HJxQU/AkY8y+ZDO
 Ca4ax5Vxot/YtapXX1V0fEpvZtmQdIKVv5r+Er5hw/RfNR8C+q
 MuqS5DYIhz78ffPNLosgawMJdNNTks+t5AB+6ffxKb5LTcG60I
 rQAOEcYohBBzF6EM1e+cwhbOqh9ylyMQmfLEGsGjtEoldCRIVx
 wRp09fFTm7aH6pSTb4ZQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 June 2013 08:30:40 Chen Gang wrote:
> On 06/26/2013 10:07 PM, Catalin Marinas wrote:
> > On Wed, Jun 26, 2013 at 04:26:41AM +0100, Chen Gang wrote:
> > I wonder whether it makes sense to include pci-dma-compat.h in
> > asm-generic/pci.h, I don't see why one would want the generic pci.h but
> > not the generic pci-dma-compat.h (cc'ing Arnd).
> 
> I think, it will let architecture guys easier to add their own
> pci-dma-compat.h (although they still need generic pci_dma_compat.h, and
> generic pci.h, too).
> 
> e.g. one architecture want include generic pci-dma-compat.h firstly,
> then define its own features in its own pci-dma-compat.h.

I think there is no excuse for still keeping the asm-generic/pci-dma-compat.h
header around any more.

All architectures use the same implementation and have done so for years.
We should just convert the remaining users to use the dma_mapping.h
interfaces directly.

	Arnd
