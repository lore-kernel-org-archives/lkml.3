Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbaHVPlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 11:41:37 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:51847 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaHVPlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 11:41:36 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Kbuild: x86: Eliminate duplicate command line options
Organization: D03
References: <1407255411-30404-1-git-send-email-linux@rasmusvillemoes.dk>
X-Hashcash: 1:20:140822:tglx@linutronix.de::BiOSJGFF3NQtOMms:00000000000000000000000000000000000000000000q+r
X-Hashcash: 1:20:140822:mingo@redhat.com::OHagXSoRrepSeaHo:01GBi
X-Hashcash: 1:20:140822:x86@kernel.org::T5Qs9ocnWXlodbRG:0002dTC
X-Hashcash: 1:20:140822:hpa@zytor.com::xNFWBfXruHtgKbRW:00005b+t
X-Hashcash: 1:20:140822:linux-kernel@vger.kernel.org::kzSRKFjO0MdNsoye:0000000000000000000000000000000006X+n
Date: Fri, 22 Aug 2014 17:41:33 +0200
In-Reply-To: <1407255411-30404-1-git-send-email-linux@rasmusvillemoes.dk>
	(Rasmus Villemoes's message of "Tue, 5 Aug 2014 18:16:51 +0200")
Message-ID: <871ts8sf9u.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rasmus Villemoes <linux@rasmusvillemoes.dk> writes:

> The options -mno-mmx and -mno-sse are unconditionally added to
> KBUILD_CFLAGS in both branches of an ifeq and through a $(cc-option)
> further down. We can safely remove the first instances.
>
> In fact, since the -mno-mmx and -mno-sse options were introduced
> simultaneous with the other two options in the $(cc-option) [according
> to http://www.gnu.org/software/gcc/gcc-3.1/changes.html], and since
> the former were unconditionally used, one can deduce that only gcc
> versions knowing about all four are supported. So also eliminate the
> $(cc-option) wrap.
>
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Ping.
