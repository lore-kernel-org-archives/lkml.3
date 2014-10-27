Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbaJ0RUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 13:20:18 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:57788 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaJ0RUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 13:20:15 -0400
MIME-Version: 1.0
In-Reply-To: <20140901065916.28909.35097.stgit@zurg>
References: <20140901065916.28909.35097.stgit@zurg>
Date: Mon, 27 Oct 2014 21:20:14 +0400
Message-ID: <CALYGNiOC7E9kPLn_+rA7Wv7AMQgzyrot9Uyd0s3DDEw+78KWGQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] kconfig: store default ARCH in .config
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Michal Marek <mmarek@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: Paul Bolle <pebolle@tiscali.nl>, Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bump.

On Mon, Sep 1, 2014 at 11:16 AM, Konstantin Khlebnikov <koct9i@gmail.com> wrote:
> This is second attempt of fixing target archecture amnesia.
> v1 patch: http://lkml.kernel.org/r/20140706080234.19520.96704.stgit@zurg
>
> First version saved ARCH as CONFIG_DEFAULT_ARCH and used it as defult ARCH.
>
> This version changes semantic of Kconfig option env="...", now it acts more
> like the user input, except that the value comes from the environment.
> Variable from environment overrides all defaults and value from config file.
> If environment variable is not defined this option has no effect.
>
> So, now ARCH is saved as CONFIG_ARCH.
>
> Also this patchset links CONFIG_CROSS_COMPILE and CROSS_COMPILE in the same way.
> Changing it in command line/environment also updates value in the config file.
>
> ---
>
> Konstantin Khlebnikov (4):
>       kconfig: save values imported from environment into config file
>       scripts/config: add option for changing output for undefined options
>       kconfig: get target architecture from config file
>       kconfig: link CONFIG_CROSS_COMPILE with environment variable
>
>
>  Documentation/kbuild/kconfig-language.txt |   10 ++++------
>  Documentation/kbuild/makefiles.txt        |    3 ++-
>  Makefile                                  |   21 +++++++++++++++------
>  init/Kconfig                              |    1 +
>  scripts/config                            |   15 ++++++++++++---
>  scripts/kconfig/confdata.c                |   26 ++++++++++++++++++++++++++
>  scripts/kconfig/expr.h                    |    2 +-
>  scripts/kconfig/symbol.c                  |    3 ---
>  8 files changed, 61 insertions(+), 20 deletions(-)
>
> --
> Signature
