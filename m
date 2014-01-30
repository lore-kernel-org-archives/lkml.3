Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbaA3R3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 12:29:45 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:56126 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbaA3R3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 12:29:43 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: document "mach-virt" platform.
Date: Thu, 30 Jan 2014 18:28:59 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Ian Campbell <ian.campbell@citrix.com>, linux-kernel@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Olof Johansson <olof@lixom.net>
References: <1391098262-15944-1-git-send-email-ian.campbell@citrix.com>
In-Reply-To: <1391098262-15944-1-git-send-email-ian.campbell@citrix.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401301828.59294.arnd@arndb.de>
X-Provags-ID: V02:K0:W6JmOOtLMlLyuIcwhvznHQVSAaMILRRsPwSu850CLuq
 4Ay/AQp+eR5ZwGQgRrHpkitPVe46m3AAhtp6iHYs/apUnHWhPh
 I5Ojw3VoFO0IQIaLRNND5+yO6bfhxLR+LQQffQwgwSep9Gc6Pb
 ntECczFqzD3YTMen2y0DyBfvzO+exkslMaY9McszQeLYglHuy2
 hRcuMbqK8W2OgvswTy+wMx5/bexzaHsRwsxMFIDwsThc2iifUO
 iwUUWDRypqqR7PmYQzVLgYdawDcXcO5x55iNbUWPFIMy2RvP1K
 0vRia4CpI1w2b0YsTuOTOP8VJ7mRIQkLKENNxuF2s4Hev0zZSq
 yx58HisEUPX9ZADJa4FTBm84jU2wFonJb8JvvXeIP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 January 2014, Ian Campbell wrote:
> mach-virt has existed for a while but it is not written down what it actually
> consists of. Although it seems a bit unusual to document a binding for an
> entire platform since mach-virt is entirely virtual it is helpful to have
> something to refer to in the absence of a single concrete implementation.
> 
> I've done my best to capture the requirements based on the git log and my
> memory/understanding.
> 
> While here remove the xenvm dts example, the Xen tools will now build a
> suitable mach-virt compatible dts when launching the guest.

It might be worth noting in the changeset comment that the 'compatible'
string is actually no longer needed on newer kernels: All the members
of the machine descriptor are now the defaults (we should remove the
virt_init() function as well), and the fallback machine descriptor should
work just fine if any other string gets passed.

	Arnd
