Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247AbaISQLU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 12:11:20 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:50234 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754306AbaISQLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 12:11:18 -0400
X-Sasl-enc: nqlk2whPsQze0eL8zE/TuI1RNJhk9baJfT9vr+fFjxlz 1411143075
Date: Fri, 19 Sep 2014 13:11:08 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        H Peter Anvin <hpa@zytor.com>
Subject: Re: x86, microcode: BUG: microcode update that changes x86_capability
Message-ID: <20140919161108.GC17456@khazad-dum.debian.net>
References: <20140918135202.GA26038@khazad-dum.debian.net>
 <541B2F33.8000002@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <541B2F33.8000002@amacapital.net>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2014, Andy Lutomirski wrote:
> > [2] instantly segfaulting every running process using libpthread-2.19,
> >     as well as any other users of Intel TSX.
> >     https://bugs.launchpad.net/intel/+bug/1370352
> > 
> >     And yes, this means we will kill support for microcode updates
> >     outside of the initramfs/early-initramfs, at least in Debian,
> >     and likely in Ubuntu.
> 
> Given that there is exactly one microcode update like this (at least of
> the sort that blows up userspace), I think that we should seriously
> consider blacklisting just this particular microcode update once
> userspace is running.

This was just the first one.  It is likely that there will be others.

Anyway, IMHO kernel blacklists are of limited value for this kind of issue.
Sure, we can add them to the microcode driver (*not* the early microcode
driver) to protect the unwary after the fact, but the useful fast-reaction
blacklisting will be done by the distros in userspace.

In fact, a big thank-you to Canonical's QA process and to Felix Geyer, for
raising the early alarm (https://bugs.launchpad.net/intel/+bug/1370352)...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
