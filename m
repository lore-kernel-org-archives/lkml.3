Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533AbaGYMxM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 08:53:12 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:50531 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752142AbaGYMxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 08:53:09 -0400
X-Sasl-enc: +b3vJb4MHlrFkiYHdlMs4ok+NNk5MkbLwp247CUd+uRG 1406292373
Date: Fri, 25 Jul 2014 09:46:01 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Theodore Ts'o" <tytso@mit.edu>, Andy Lutomirski <luto@amacapital.net>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH -v5] random: introduce getrandom(2) system call
Message-ID: <20140725124601.GB401@khazad-dum.debian.net>
References: <1406212287-9855-1-git-send-email-tytso@mit.edu>
 <20140724151814.GE32421@khazad-dum.debian.net>
 <CALCETrXAA=UzS-pRCo5tKSjSCOP9xfu66BG9QbRefVrovkavhQ@mail.gmail.com>
 <20140724190206.GL6673@thunk.org>
 <20140724203019.GA20737@khazad-dum.debian.net>
 <20140724232434.GN6673@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140724232434.GN6673@thunk.org>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2014, Theodore Ts'o wrote:
> On Thu, Jul 24, 2014 at 05:30:19PM -0300, Henrique de Moraes Holschuh wrote:
> > > I wouldn't add the error to the man page until we actually modify the
> > > kernel to add such a restriction.
> > 
> > By then, it might be too late.  It would be really sad to find ourselves
> > forced to return ENOSYS to getrandom(GRND_RANDOM) when we actually wanted to
> > return EPERM/EACCES.
> 
> I wouldn't worry about.  The reality is that anyone using GRND_RANDOM
> has to be checking for error codes anyway, and if they do something

...

> In general, all system calls can return errno's other than the ones
> documented in the man page.  This is certainly true for open(2), and
> read(2) if you are using a network file system such as NFS.  Someone

A few manpages might actually have warnings to that effect, but it is not
the rule.  Amusingly enough, the one for read(2) does, while open(2) does
not.

IMHO the getrandom(2) case is slightly different: we already know to a high
degree of confidence that we will want to convey a "permission denied"
condition to userspace for getrandom(GRND_RANDOM) sooner or later.

I'd be fine with text that mentions that GRND_RANDOM access by a process
may be restricted/rejected by system policy in the future, so code should
not assume any error return code from getrandom(GRND_RANDOM) would also
apply to getrandom() without GRND_RANDOM, and must degrade gracefully and
safely in that case.

> I don't think it's necessary to add a sentence that other errors can
> be returned in the future, and users much check for other errors, but
> if you really think people are that stupid that we need to say
> something which is true for every single system call in Linux, we can
> do that....

Well, I feel we could go a bit further than usual for getrandom(2), but
I've already stated my case.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
