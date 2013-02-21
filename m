Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab3BUQ0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 11:26:37 -0500
Received: from mail-vb0-f51.google.com ([209.85.212.51]:45243 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab3BUQ0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 11:26:34 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1302220058500.18199@tundra.namei.org>
References: <alpine.LRH.2.02.1302220058500.18199@tundra.namei.org>
Date: Thu, 21 Feb 2013 08:26:32 -0800
X-Google-Sender-Auth: Sy0wPf417eAuSCHH91PuQUK94EM
Message-ID: <CA+55aFzkBA6bdLe73PKBaQNfV1m-JqSddF24-F-s1rX3oRE2Lg@mail.gmail.com>
Subject: Re: [GIT] Security subsystem updates for 3.9
From: Linus Torvalds <torvalds@linux-foundation.org>
To: James Morris <jmorris@namei.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 6:03 AM, James Morris <jmorris@namei.org> wrote:
> This is basically a maintenance update for the TPM driver and EVM/IMA.

Hmm. There were conflicts in lib/digsig.c and ima_main.c. The digsig
one was pretty trivial, but I'd like people to take a look at the IMA
one.

And that's not because the conflict itself was all that complex - I'm
pretty sure I resolved it correctly. But I do want to make sure that
everybody agrees on the whole module integrity checking thing. I
resolved it to be like the semantics in Mimi's commit a7f2a366f623,
which means that for non-file modules, IMA does:

Only fail the non-file module if
   (a) IMA_APPRAISE_MODULES was set
*and*
   (b) CONFIG_MODULE_SIG_FORCE is not set.

If CONFIG_MODULE_SIG_FORCE it ignores IMA_APPRAISE_MODULES entirely,
and the module signature checking overrides everything. And if
IMA_APPRAISE_MODULES is not set, we say "whatever". So it makes sense,
but I wanted people to just be aware of it and agree on it, since the
security tree modified this part without apparently being aware of the
changed semantics.

            Linus
