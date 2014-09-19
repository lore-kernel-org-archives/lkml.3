Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbaISLAY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:00:24 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:43396 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751498AbaISLAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:00:22 -0400
X-Sasl-enc: 9f9obtmbFynP0wf3wSxmIg/e104ho6Phs3dabRPWVHbA 1411124421
Date: Fri, 19 Sep 2014 08:00:15 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Borislav Petkov <bp@alien8.de>, Chuck Ebbert <cebbert.lkml@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: x86, microcode: BUG: microcode update that changes x86_capability
Message-ID: <20140919110014.GC29639@khazad-dum.debian.net>
References: <20140918135202.GA26038@khazad-dum.debian.net>
 <541B2F33.8000002@amacapital.net>
 <20140918145328.0253f009@as>
 <9c84cde6-3d70-4337-8738-0283d06d8cf0@email.android.com>
 <20140918200659.GA5331@khazad-dum.debian.net>
 <20140919001311.GB5331@khazad-dum.debian.net>
 <CALCETrVoeqQUXH7g+reu=hUvCJoiy+edHKBqYKPWXPCS3_UtUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVoeqQUXH7g+reu=hUvCJoiy+edHKBqYKPWXPCS3_UtUw@mail.gmail.com>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2014, Andy Lutomirski wrote:
> On Sep 18, 2014 5:13 PM, "Henrique de Moraes Holschuh" <hmh@hmh.eng.br> wrote:
> > Here's a plan that might work, pending actually checking the libpthread TSX
> > code to make sure it keys on /proc/cpuinfo flags:
> 
> Surely it checks cpuid directly, though.

Unfortunately, you're correct.  It uses cpuid() directly.  So, my plan is
not going to work.

> Can we twiddle the cpuid bit?  I never noticed any way in the docs to

No, we can't, at least not by manipulating cpuid itself.

And if the old microcode had such a Intel TSX on/off switch (which would
also reset the bit), the "fix" that disables Intel TSX should have been a
BIOS update, not a microcode update... so I consider that very unlikely.

I'm filling a bug on Debian glibc, asking them to blacklist HLE until
further notice.

So that's two nice features that might go the way of the Dodo over this:
We're also killing microcode update support outside of the initramfs in
Debian.  It has become obvious that anything other than the early initramfs
method of microcode updates should be considered a developer thing.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
