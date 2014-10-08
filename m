Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200AbaJHL3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 07:29:36 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:62167 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059AbaJHL3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 07:29:34 -0400
MIME-Version: 1.0
In-Reply-To: <1412760595-3935-19-git-send-email-lftan@altera.com>
References: <1412760595-3935-1-git-send-email-lftan@altera.com>
	<1412760595-3935-19-git-send-email-lftan@altera.com>
Date: Wed, 8 Oct 2014 13:29:33 +0200
Message-ID: <CAFLxGvyjd8kA=QwFEju4zWG-ntYsRHnk6p4Sh6Rf_GJQuDR1tw@mail.gmail.com>
Subject: Re: [PATCH v4 18/29] nios2: Signal handling support
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Ley Foon Tan <lftan@altera.com>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, LeyFoon Tan <lftan.linux@gmail.com>,
        cltang@codesourcery.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 8, 2014 at 11:29 AM, Ley Foon Tan <lftan@altera.com> wrote:
> This patch adds support for signal handling.
>
> Signed-off-by: Ley Foon Tan <lftan@altera.com>

Maybe I'm misreading your code but where do you check for multiple
pending signals?
It looks like you're handling only exact one signal before retuning to
userspace.
This is a serious issue, if you post a SIGSEGV i.e. in
do_rt_sigreturn() you need to handle it later
instead of directly returning to userspace.

-- 
Thanks,
//richard
