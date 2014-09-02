Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459AbaIBNRH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 09:17:07 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57738 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753978AbaIBNRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 09:17:05 -0400
X-Sasl-enc: +fto86vtaf+isLdqkQJsMsA1Yr6ekSsvY0vA/WFhKtCM 1409663823
Date: Tue, 2 Sep 2014 10:16:51 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: early microcode: how to disable at runtime?
Message-ID: <20140902131651.GA10691@khazad-dum.debian.net>
References: <20140809231911.GA4843@khazad-dum.debian.net>
 <20140831194548.GA12628@khazad-dum.debian.net>
 <54037C07.8060703@zytor.com>
 <20140831201126.GB12628@khazad-dum.debian.net>
 <20140901051302.GA28402@nazgul.tnic>
 <5404A035.3070707@zytor.com>
 <20140901174322.GA15533@khazad-dum.debian.net>
 <ea40f7c4-ec8d-4be5-8f8c-bbd11ab07252@email.android.com>
 <20140901195921.GA18675@khazad-dum.debian.net>
 <20140902063354.GA32105@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140902063354.GA32105@nazgul.tnic>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Sep 2014, Borislav Petkov wrote:
> > This can be a very big deal when things go wrong: it is hard for the
> > regular user to recover from an initramfs image that crashes the
> > system, and the early initramfs has no "disable" trigger.
> 
> This maybe is a serious problem but disabling microcode loading is not
> the proper solution. If the microcode in the initrd is corrupted, it
> should simply not get loaded and system should continue as much as it
> can - it *should* *not* be a requirement to disable the ucode loader in
> order to workaround corrupted initrds.

Things do go wrong in other ways, not just corrupt microcode data/initramfs
images.

This stuff runs too early.  It is easy to break, and annoying to debug.

> And frankly, I'm trying to imagine how a corrupted microcode in an
> initrd would ever fail the booting. So Henrique, if you have something
> which is *not* hypothetical, please say so. It needs to be fixed
> properly and not with disabling the ucode loader.

I am not worried about corrupted microcode, or even corrupted initramfs
images.  I am just worried about regular bugs introduced by a kernel update
causing systems to fail to reboot later.

I don't want to tell an user he has to use rescue media to get his system
back into working order when a kernel parameter would have been enough to
get it to boot.

Although, on the corrupted microcode topic, I have this very strong feeling
that at least the Intel driver would benefit from a careful audit on the
microcode container handling if we want to be sure it won't do stupid things
when fed specially crafted hostile data.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
