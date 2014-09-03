Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428AbaICMnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:43:16 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59911 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932091AbaICMnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:43:14 -0400
X-Sasl-enc: p/m8U1y0D0kx3NfefbmUddocqiQ5oAMu/f5/mO8y0SOG 1409748193
Date: Wed, 3 Sep 2014 09:43:02 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: early microcode: how to disable at runtime?
Message-ID: <20140903124302.GA18507@khazad-dum.debian.net>
References: <54037C07.8060703@zytor.com>
 <20140831201126.GB12628@khazad-dum.debian.net>
 <20140901051302.GA28402@nazgul.tnic>
 <5404A035.3070707@zytor.com>
 <20140901174322.GA15533@khazad-dum.debian.net>
 <ea40f7c4-ec8d-4be5-8f8c-bbd11ab07252@email.android.com>
 <20140901195921.GA18675@khazad-dum.debian.net>
 <20140902063354.GA32105@nazgul.tnic>
 <20140902131651.GA10691@khazad-dum.debian.net>
 <20140903064015.GA3941@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140903064015.GA3941@nazgul.tnic>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Sep 2014, Borislav Petkov wrote:
> On Tue, Sep 02, 2014 at 10:16:51AM -0300, Henrique de Moraes Holschuh wrote:
> > Things do go wrong in other ways, not just corrupt microcode data/initramfs
> > images.
> > 
> > This stuff runs too early.  It is easy to break, and annoying to debug.
> 
> How is this stuff easy to break? Please stop with the conjectures and
> give concrete issues, if any.

Half the things you'd usually do when writing kernel code cannot be done
that early, that's how.  It is not that the code is bad or especially
fragile (at least not the core or the AMD driver.  The Intel driver is
convoluted).

You have fixed several such bugs recently, commit ids:
75a1ba5b2c529db60ca49626bcaf0bddf4548438,
84516098b58e05821780dc0b89abcee434b4dca5,
5335ba5cf475369f88db8e6835764efdcad8ab96.

> > Although, on the corrupted microcode topic, I have this very strong
> > feeling that at least the Intel driver would benefit from a careful
> > audit on the microcode container handling if we want to be sure it
> > won't do stupid things when fed specially crafted hostile data.
> 
> If loading the microcode can disrupt the system (and not simply be
> ignored if faulty) then we have to fix that. Disabling the loader is only
> a stop-gap measure in such situation anyway - not a real solution.

Yes.  It is a stop gap solution, I never claimed it to be anything else.

What I did claim is that it is going to be a far more user-friendly stop gap
than the "boot from rescue media" option.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
