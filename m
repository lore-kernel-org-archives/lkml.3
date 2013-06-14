Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab3FNPiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 11:38:22 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:50934 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab3FNPiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 11:38:20 -0400
MIME-Version: 1.0
In-Reply-To: <20130614080528.GM4165@ZenIV.linux.org.uk>
References: <20130614080528.GM4165@ZenIV.linux.org.uk>
Date: Fri, 14 Jun 2013 08:38:19 -0700
X-Google-Sender-Auth: HEU8An9zqG63L45DChn_pOWZwqA
Message-ID: <CA+55aFyEuDsLtKXDCd1w_dUfOg-4_7b2WBO3P+5VMFXB4XS=YQ@mail.gmail.com>
Subject: Re: [RFC] should read(2) update the position if it returns an error?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 1:05 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
>         Comments?  I'd obviously prefer to solve it that way (i.e. leave
> ->f_pos untouched if vfs_read() returns an error), but I might be missing
> some case where we want position updated even though read() returns an
> error.  I can't come up with one, but then I hadn't RTFS through every
> ->read() instance in drivers in search of weird cases like that - we've
> too many instances ;-/

Not updating f_pos on errors sounds like the right thing to do to me,
and if it also ends up fixing some nasty issues with hpfs and
potentially other cases, I'd say "go for it".

Not for 3.10, though. It's not like this is a new - or acute - problem.

             Linus
