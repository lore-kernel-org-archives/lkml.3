Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773AbaHOTYa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 15:24:30 -0400
Received: from ozlabs.org ([103.22.144.67]:60281 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbaHOTY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 15:24:28 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>, stable@vger.kernel.org
Subject: Re: [PATCH] module: Clean up ro/nx after early module load failures
In-Reply-To: <8c275067bad7333e82cb80c993ce23216f41002e.1408065737.git.luto@amacapital.net>
References: <8c275067bad7333e82cb80c993ce23216f41002e.1408065737.git.luto@amacapital.net>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Sat, 16 Aug 2014 04:19:19 +0930
Message-ID: <87ha1d8u6o.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:
> The commit
>
>     4982223e51e8 module: set nx before marking module MODULE_STATE_COMING.
>
> introduced a regression: if a module fails to parse its arguments or
> if mod_sysfs_setup fails, then the module's memory will be freed
> while still read-only.  Anything that reuses that memory will crash
> as soon as it tries to write to it.

Thanks, good catch.

Applied,
Rusty.
