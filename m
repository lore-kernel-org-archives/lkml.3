Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613AbaLAWp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 17:45:28 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:56215 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbaLAWp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 17:45:27 -0500
MIME-Version: 1.0
In-Reply-To: <CAE8gLhn9wFBLvdxTonD5m8Q_wYG_eg_TQOuZnEFPEVXstHdbvw@mail.gmail.com>
References: <CAE8gLhn9wFBLvdxTonD5m8Q_wYG_eg_TQOuZnEFPEVXstHdbvw@mail.gmail.com>
Date: Mon, 1 Dec 2014 23:45:26 +0100
Message-ID: <CAE8gLhkBUWrXsRxBDTpj1sNVKZLe7aVeqMuJArW2ACOkvpR-OQ@mail.gmail.com>
Subject: Re: PROBLEM: [Launchpad #1396889] [Lenovo ThinkPad T400] kexec reboot fails
From: MegaBrutal <megabrutal@gmail.com>
To: Linux kernel <linux-kernel@vger.kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-01 7:32 GMT+01:00 MegaBrutal <megabrutal@gmail.com>:
> [X.] Other notes, patches, fixes, workarounds:
> Downstream report (Ubuntu Launchpad):
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1396889
>
> With kernel bisection, I've found, the first bad commit is
> 8ab3820fd5b2896d66da7bb2a906bc382e63e7bc x86, kaslr: Return location
> from decompress_kernel
> which introduces KASLR.
> http://lkml.kernel.org/r/1381450698-28710-3-git-send-email-keescook@chromium.org
>
> The problem only presents itself when CONFIG_RANDOMIZE_BASE=y.
>
> For workaround, there is a "nokaslr" kernel parameter to disable the
> feature, even if the kernel was compiled with CONFIG_RANDOMIZE_BASE.

Need to add: as I tested today, unfortunately the "nokaslr" kernel
option doesn't work around the bug. If a kernel was compiled with
CONFIG_RANDOMIZE_BASE, it won't properly kexec on my ThinkPad T400,
even if the "nokaslr" kernel option is provided!

This could actually help to find the bug, as whatever bad happens must
happen before the kernel checks for the presence of the "nokaslr"
kernel parameter.
