Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbaIYOky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 10:40:54 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:35089 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753075AbaIYOkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 10:40:39 -0400
X-Sasl-enc: +xkv/fUVTRPOZhREnroRN/b7YUb4oVXRxNtOgZURrN+5 1411656037
Date: Thu, 25 Sep 2014 11:40:25 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: Chuck Ebbert <cebbert.lkml@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: x86, microcode: BUG: microcode update that changes x86_capability
Message-ID: <20140925144025.GA14030@khazad-dum.debian.net>
References: <20140919110014.GC29639@khazad-dum.debian.net>
 <20140919112953.GA3256@nazgul.tnic>
 <20140919075415.5149d5f2@as>
 <20140919150042.GC5318@nazgul.tnic>
 <20140919164217.GD17456@khazad-dum.debian.net>
 <20140923200054.GB16467@pd.tnic>
 <20140924145658.GB31678@khazad-dum.debian.net>
 <20140925085158.GF22317@nazgul.tnic>
 <20140925113643.GB10569@khazad-dum.debian.net>
 <20140925121007.GA25334@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140925121007.GA25334@nazgul.tnic>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2014, Borislav Petkov wrote:
> On Thu, Sep 25, 2014 at 08:36:45AM -0300, Henrique de Moraes Holschuh wrote:
> > This isn't an useless fix, it will allow systems without early initramfs
> > support to operate correctly after a microcode update.
> 
> So what do we do if we update the microcode late and some userspace task
> is using HLE and all of a sudden it segfaults and gets killed due to
> #UD. I'll forward all those complaint emails to you then, no?
> 
> :-)
> 
> What's saying is, a reboot in this case is maybe the lesser of two evils.

In that case we should blacklist to refuse to apply the update, and reboot
only if the blacklist wasn't good enough and we detect that something really
important in the cpu feature cpuid bits changed.

However, a reboot is even worse than everything linked to libpthread
segfaulting, as it will also cause data loss for the stuff that didn't get
SIGILL'd to death.  Meh.

Backporting early initramfs support to 3.0/3.2/3.4 doesn't seem doable, or
wise.

At this point, what alternatives are left?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
