Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243Ab3AQB2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 20:28:15 -0500
Received: from hermes.domdv.de ([193.102.202.1]:2908 "EHLO hermes.domdv.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755928Ab3AQB2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 20:28:14 -0500
X-Greylist: delayed 524 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jan 2013 20:28:14 EST
Message-ID: <1358385543.7040.54.camel@host028-server-9.lan.domdv.de>
Subject: LIO - the broken iSCSI target implementation
From: Andreas Steinmetz <ast@domdv.de>
To: linux-kernel@vger.kernel.org
Cc: hch@infradead.org, torvalds@linux-foundation.org
Date: Thu, 17 Jan 2013 02:19:03 +0100
Organization: D.O.M. Datenverarbeitung GmbH
Content-Type: text/plain; charset="ansi_x3.4-1968"
X-Mailer: Evolution 3.6.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not a technical point of view. This is a more or less political
and user point of view. And for any replies, I'm not subscribed (haven't
been now for years).

As a user, I was in need for an iSCSI target. Actually, I needed to
export a SAS tape device (Ultrium 5) - which is one of the devices still
sufficiently expensive to go the iSCSI target way) - well, not any disks
(cheap enough, NFS available) or CD/DVD writers (I'd call these penny
targets nowadays).

Thus, lio (http://www.linux-iscsi.org/) seemed to be the politically and
technically favoured solution. Except: it simply doesn't work, userspace
utilities are seemingly not maintained, the web site is - simply put -
sales talk and when one tries to write manually to configfs the results
are kernel panics.

A little bit more detail:

The mentioned website doesn't have any usable documentation on how to
use the provided utilities. It does, however, include lots of sales
pointers for a certain company. Looking at
http://www.risingtidesystems.com/git/ the latest changes are older than
3 months. And this userspace stuff is full of bugs. Whatever tool I
tried - either the tools complained or there were easily detectable bugs
that were never fixed.

Oh, well, maybe I do expect too much when a certain commercial
institution calls LIO "the standard open-source storage Target". Maybe
one should not expect typical hardware to be supported except, maybe,
when a commercial contract exists...

Though the only chance to get the LIO target working for me was to try
to write hopefully proper values to configfs manually. Without any
usable documentation, that is. The result was: kernel panics (@hch:
don't ask me how to repeat - hire some apes hacking at LIO configfs,
that's whats required, apes need no documentation, either).

The fun part of it was that I finally ended up using SCST - which was
refrained from kernel inclusion for technical reasons beyond my
knowledge. What makes me prefer SCST is quite simple:

It works, it is sufficiently documented and it is maintained. And, @hch:
Beautiful in kernel code first needs to work without producing kernel
panics (3.7.x) and it needs to be accompanied by working and
sufficiently documented user space utilities or, it needs to have a well
documented API (documentation needs to include a variety of examples,
not the old IBM way of simply documenting every flag without any
overview).

As long as LIO userspace is a not maintained and instead seemingly a
sales playground and as long as LIO kernel code causes panics by simple
writes to configfs LIO seems to me worse than any alpha quality code. It
is simply useless.

Maybe I'm the first to state this but for sure I'm not the first to
detect this.

Finally, I'm not willing to take part nor am I intending to start a
flame war. I'm just stating how things are with regards to LIO from a
user's point of view. It is up to other powers to decide, when and if
stuff gets fixed. It is, however, clear from a user's perspective that
LIO should be marked as *BROKEN* as long as it stays as unusable as it
is.

@hch - Remember: Implement, then *document* and *test*. Otherwise you
produce or review dead code - maybe even infradead code.
-- 
Andreas Steinmetz                       SPAMmers use robotrap@domdv.de

