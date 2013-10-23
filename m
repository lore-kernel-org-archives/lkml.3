Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab3JWMmt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 08:42:49 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:65119 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab3JWMmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 08:42:47 -0400
MIME-Version: 1.0
In-Reply-To: <1382530790.16097.29.camel@dabdike.quadriga.com>
References: <1382527624.16097.23.camel@dabdike.quadriga.com>
	<CA+55aFzo-sA4P_rMC1wWfLp50QswfP0GdLxMQ+Wbw8ArK5capw@mail.gmail.com>
	<1382530790.16097.29.camel@dabdike.quadriga.com>
Date: Wed, 23 Oct 2013 13:42:46 +0100
X-Google-Sender-Auth: vd2Y7e8WNO243Y3gl3dXbuub6ys
Message-ID: <CA+55aFyLpN6aym28n96+eO-cJhopZ5G9Er=nHvf-d4i72fQsGQ@mail.gmail.com>
Subject: Re: [GIT PULL] SCSI fixes for 3.12-rc6
From: Linus Torvalds <torvalds@linux-foundation.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 1:19 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> OK, so is the new driver exception gone then?

The new driver exception was about supporting new hardware, so we can
add things like new ID's etc (or even whole new drivers) later in the
development process than the merge window.

And any "new code" (that is behind a new config option or totally new
system call or something like that, so that the code cannot be
triggered by old users) can admittedly get changes more easily if it
cannot regress (since it didn't exist before). But that's more a "I'll
let it slide for rc2-3" thing than any big concept, and it's
definitely not about rc7.

And neither of those issues have ever made it acceptable to random
pointless churn. If it doesn't add support for new hardware, it's not
under some kind of "new hardware support" exception. And just "it's
new code, so we cannot possibly regress" is an excuse for making
slightly more invasive changes (especially to ABI's etc that need to
get fixed before a release), but it's not some blanket "we can do
anything" exception.

And quite frankly, even the "new driver" exception was about hardware
that normal people actually are expected to use.  Things that are
relevant for a possibly large number of users. If it's something that
random people can be expected to pick up and use in Fry's or Office
Depot, we want to make sure we have a driver available as soon as
humanly possible.

In contrast, if it's a driver for some enterprise hardware that is
only used by people who are going to run enterprise kernels anyway (ie
often several years down the line), there is ABSOLUTELY NO REASON to
merge it late in the release window. The enterprise users aren't using
bleeding edge kernels anyway, their time constraints are different.

So if people thought it was some carte blanche for "anything goes",
people were confused.

You need to think about *WHY* we had a "new driver" exception. And
realize that it probably will never actually be relevant for any SCSI
driver (not counting things like USB storage etc).

          Linus
