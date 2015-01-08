Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564AbbAHWmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 17:42:42 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:43584 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbbAHWmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 17:42:40 -0500
MIME-Version: 1.0
In-Reply-To: <20150108104933.GA25083@sepie.suse.cz>
References: <20150108104933.GA25083@sepie.suse.cz>
Date: Thu, 8 Jan 2015 14:42:38 -0800
X-Google-Sender-Auth: q69z3cfh-ykLyPPhSICi3x3n1Ls
Message-ID: <CA+55aFxrc1CiyjQfWoZHD6UgwOTgj=NVBXPPsY2eygfPMzgsPg@mail.gmail.com>
Subject: Re: [GIT PULL] make mrproper fix for v3.19-rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 8, 2015 at 2:49 AM, Michal Marek <mmarek@suse.cz> wrote:
>
> make mrproper / distclean stopped removing the generated debian/
> directory in v3.16.

So "make distclean" still doesn't actually clean everything.

I don't personally much care, since I've taught my fingers to just do

    git clean -dqfx

instead, but since I tested "make distclean" after pulling from you, I
thought I'd just mention it.

Just do

    make allmodconfig
    .. build the tree ..
    make distclean
    git ls-files -o

to see any files that are left-over despite the distclean ("git
ls-files -o" basically shows all untracked files - 'o' stands for
'others' - so anything that isn't in the actual distributed sources
shows up)

But I really am not sure how much effort we should spend on "make
distclean", given than "git clean" is so much easier and requires no
effort at all.

                      Linus
