Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbaIDXTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 19:19:38 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49464 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751272AbaIDXTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 19:19:36 -0400
X-Sasl-enc: NNSnaCmmZzwMuM1Ij/oUwLsOYVTEy4ZXcT/k0pwY/ZKj 1409872775
Date: Thu, 4 Sep 2014 20:19:23 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Toshi Kani <toshi.kani@hp.com>, tglx@linutronix.de, mingo@redhat.com,
        akpm@linuxfoundation.org, arnd@arndb.de, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, jgross@suse.com,
        stefan.bader@canonical.com, luto@amacapital.net,
        konrad.wilk@oracle.com
Subject: Re: [PATCH 1/5] x86, mm, pat: Set WT to PA4 slot of PAT MSR
Message-ID: <20140904231923.GA15320@khazad-dum.debian.net>
References: <1409855739-8985-1-git-send-email-toshi.kani@hp.com>
 <1409855739-8985-2-git-send-email-toshi.kani@hp.com>
 <20140904201123.GA9116@khazad-dum.debian.net>
 <5408C9C4.1010705@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5408C9C4.1010705@zytor.com>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Sep 2014, H. Peter Anvin wrote:
> On 09/04/2014 01:11 PM, Henrique de Moraes Holschuh wrote:
> > I am worried of uncharted territory, here.  I'd actually advocate for not
> > enabling the upper four PAT entries on IA-32 at all, unless Windows 9X / XP
> > is using them as well.  Is this a real concern, or am I being overly
> > cautious?
> 
> It is extremely unlikely that we'd have PAT issues in 32-bit mode and
> not in 64-bit mode on the same CPU.

Sure, but is it really a good idea to enable this on the *old* non-64-bit
capable processors (note: I don't mean x86-64 processors operating in 32-bit
mode) ?

> As far as I know, the current blacklist rule is very conservative due to
> lack of testing more than anything else.

I was told that much in 2009 when I asked why cpuid 0x6d8 was blacklisted
from using PAT :-)

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
