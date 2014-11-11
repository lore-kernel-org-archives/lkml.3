Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436AbaKKQ5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 11:57:44 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:55877 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751164AbaKKQ5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 11:57:43 -0500
X-Sasl-enc: XDcgZfH+8Q2+jeIzh/fenBZhJLbJlRQPtgiOHxSvK34s 1415725062
Date: Tue, 11 Nov 2014 14:57:31 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 7/8] x86, microcode, intel: guard against misaligned
 microcode data
Message-ID: <20141111165731.GA2584@khazad-dum.debian.net>
References: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
 <1410197875-19252-8-git-send-email-hmh@hmh.eng.br>
 <20141107195905.GE5180@pd.tnic>
 <20141107225425.GC18128@khazad-dum.debian.net>
 <20141107234806.GG5180@pd.tnic>
 <20141108215749.GC32023@khazad-dum.debian.net>
 <20141111104700.GC31490@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141111104700.GC31490@pd.tnic>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2014, Borislav Petkov wrote:
> On Sat, Nov 08, 2014 at 07:57:49PM -0200, Henrique de Moraes Holschuh wrote:
> * you either write down *why* kmalloc guarantees alignment. From a quick
> look it might but it might not, hint
> 
> #define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)

Meh, I don't know where I came up with the wrong information that kmalloc
aligned to 16-bytes instead of 8 bytes.

I do wonder why I didn't hit this while testing, though.  Maybe an artifact
of slub, or just my luck that I never got a memory block that was not
aligned to 16 bytes.

I will fix this.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
