Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbaIYPaX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:30:23 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51640 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751981AbaIYPaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:30:21 -0400
X-Sasl-enc: yqcox/Tqhb4LnMwl0cx9nAjFI21hZExQP7qsuPfdznhY 1411659018
Date: Thu, 25 Sep 2014 12:30:06 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: Chuck Ebbert <cebbert.lkml@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: x86, microcode: BUG: microcode update that changes x86_capability
Message-ID: <20140925153006.GB10814@khazad-dum.debian.net>
References: <20140919075415.5149d5f2@as>
 <20140919150042.GC5318@nazgul.tnic>
 <20140919164217.GD17456@khazad-dum.debian.net>
 <20140923200054.GB16467@pd.tnic>
 <20140924145658.GB31678@khazad-dum.debian.net>
 <20140925085158.GF22317@nazgul.tnic>
 <20140925113643.GB10569@khazad-dum.debian.net>
 <20140925121007.GA25334@nazgul.tnic>
 <20140925144025.GA14030@khazad-dum.debian.net>
 <20140925145655.GA28201@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140925145655.GA28201@nazgul.tnic>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2014, Borislav Petkov wrote:
> On Thu, Sep 25, 2014 at 11:40:25AM -0300, Henrique de Moraes Holschuh wrote:
> > At this point, what alternatives are left?
> 
> Here's what we could do:
> 
> * Install microcode to /lib/firmware/...
> 
> * Refuse to update the microcode and tell the user that she needs to reboot.
> 
> * Reboot and load the microcode
> 
> For that to work though, we'd need to detect the that we're freshly
> booting and only then load the microcode (if we're coming in later,
> we should refuse because something linking to libpthread might've run
> already).

Userspace can install the microcode only inside the initramfs, if it wants
to avoid it being loaded later.  It is not even too difficult to do so.

But the kernel currently doesn't have a away to know that happened.

We could just add the blacklist _and_ support for x86_capability changes
that don't touch something the kernel uses, and bypass the blacklist the
first time userspace writes 2 to the sysfs update trigger.

So, it would be an one-use trapdoor that the initramfs can use to update the
Haswells at boot.  If someone really wants to use it again, he can rmmod +
modprobe (no way to do it if the microcode driver is built-in, though).

> The other thing we could do is backport early ucode loading...
> 
> Hmm, I'm not crazy about both possibilities though, TBH.

Indeed.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
