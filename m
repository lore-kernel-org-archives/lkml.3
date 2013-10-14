Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab3JNI5h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 04:57:37 -0400
Received: from ozlabs.org ([203.10.76.45]:50738 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184Ab3JNI5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 04:57:36 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Krzysztof Mazur <krzysiek@podlesie.net>, linux-kernel@vger.kernel.org
Cc: Pawel Moll <pawel.moll@arm.com>, Andrew Morton <akpm@linux-foundation.org>,
        Krzysztof Mazur <krzysiek@podlesie.net>
Subject: Re: [PATCH] init: fix in-place parameter modification regression
In-Reply-To: <1381601100-5622-1-git-send-email-krzysiek@podlesie.net>
References: <1381601100-5622-1-git-send-email-krzysiek@podlesie.net>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 14 Oct 2013 18:06:23 +1030
Message-ID: <87eh7o8ft4.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Mazur <krzysiek@podlesie.net> writes:
> Before commit 026cee0086fe1df4cf74691cf273062cc769617d
> ("params: <level>_initcall-like kernel parameters") the __setup
> parameter parsing code could modify parameter in the
> static_command_line buffer and such modifications were kept. After
> that commit such modifications are destroyed during per-initcall level
> parameter parsing because the same static_command_line buffer is used
> and only parameters for appropriate initcall level are parsed.
>
> That change broke at least parsing "ubd" parameter in the ubd driver
> when the COW file is used.
>
> Now the separate buffer is used for per-initcall parameter parsing,
> like in parsing early params.

How about just removing "strcpy(static_command_line, saved_command_line);"
from do_initcall_level altogether?  We already initialize it in
setup_command_line().

Cheers,
Rusty.
