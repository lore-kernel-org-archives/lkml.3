Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758998Ab3ANVrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 16:47:22 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:58817 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758208Ab3ANVrU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 16:47:20 -0500
MIME-Version: 1.0
In-Reply-To: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D6F3C@MYMBX.MY.STEC-INC.AD>
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D6F3C@MYMBX.MY.STEC-INC.AD>
From: Mike Snitzer <snitzer@redhat.com>
Date: Mon, 14 Jan 2013 16:46:58 -0500
X-Google-Sender-Auth: nYJfIMdSxe0V875H5jujcdSH4kY
Message-ID: <CAMM=eLdgD8GKeK48SU2rfC49u3H4WRf9-xFxM4ymVPbKkx+mCw@mail.gmail.com>
Subject: Re: Announcement: STEC EnhanceIO SSD caching software for Linux kernel
To: Amit Kale <akale@stec-inc.com>
Cc: LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amit,

On Fri, Jan 11, 2013 at 12:18 PM, Amit Kale <akale@stec-inc.com> wrote:
> Greetings,
>
> STEC is happy to announce hosting of our EnhanceIO SSD caching software on github.
> We would like to invite kernel hackers to try it. We'll appreciate your valuable feedback to help us improve it to the standards of Linux kernel source code. We hope to eventually submit it for a possible inclusion in Linux kernel.

The github code you've referenced is in a strange place; it is
obviously in a bit of flux.

> Repository location -  https://github.com/stec-inc/EnhanceIO
> License - GPL
> Source - Derived from the source base of EnhanceIO product Current state - Alpha.
> Ongoing work - Code cleanup, testing, more documentation.
>
> Do try it. If you face problems, file bugs at github or write to me.
>
> First section of the README.txt file in this repository introduces EnhanceIO and is as follows
>
> ----------------
> EnhanceIO driver is based on EnhanceIO SSD caching software product developed by STEC Inc. EnhanceIO was derived from Facebook's open source Flashcache project. EnhanceIO uses SSDs as cache devices for traditional rotating hard disk drives (referred to as source volumes throughout this document).

Earlier versions of EnhanceIO made use of Device Mapper (and your
github code still has artifacts from that historic DM dependency, e.g.
eio_map still returns DM_MAPIO_SUBMITTED).

As a DM target, EnhanceIO still implemented its own bio splitting
rather than just use the DM core's bio splitting, now you've decided
to move away from DM entirely.  Any reason why?

Joe Thornber published the new DM cache target on dm-devel a month ago:
https://www.redhat.com/archives/dm-devel/2012-December/msg00029.html

( I've also kept a functional git repo with that code, and additional
fixes, in the 'dm-devel-cache' branch of my github repo:
git://github.com/snitm/linux.git )

It would be unfortunate if Joe's publishing of the dm-cache codebase
somehow motivated STEC's switch away from DM (despite EnhanceIO's DM
roots given it was based on FB's flashcache which also uses DM).

DM really does offer a compelling foundation for stacking storage
drivers in complementary ways (e.g. we envision dm-cache being stacked
in conjunction with dm-thinp).  So a DM-based caching layer has been
of real interest to Red Hat's DM team.

Given dm-cache's clean design and modular cache replacement policy
interface we were hopeful that any existing limitations in dm-cache
could be resolved through further work with the greater community
(STEC included).  Instead, in addition to bcache, with EnhanceIO we
have more fragmentation for a block caching layer (a layer which has
been sorely overdue in upstream Linux).

Hopefully upstream Linux will get this caching feature before its
utility is no longer needed.  The DM team welcomes review of dm-cache
from STEC and the greater community.  We're carrying on with dm-cache
review/fixes for hopeful upstream inclusion as soon as v3.9.

Mike
