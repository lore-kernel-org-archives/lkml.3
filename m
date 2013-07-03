Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab3GCBQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 21:16:04 -0400
Received: from ozlabs.org ([203.10.76.45]:45465 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279Ab3GCBQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 21:16:03 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: James Hogan <james.hogan@imgtec.com>, linux-kernel@vger.kernel.org
Cc: James Hogan <james.hogan@imgtec.com>
Subject: Re: [PATCH] metag: move EXPORT_SYMBOLs in libs to metag_ksyms.c
In-Reply-To: <1372774074-18553-1-git-send-email-james.hogan@imgtec.com>
References: <1372774074-18553-1-git-send-email-james.hogan@imgtec.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 03 Jul 2013 10:15:53 +0930
Message-ID: <87bo6kfp32.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Hogan <james.hogan@imgtec.com> writes:
> Move all EXPORT_SYMBOLs in libs-y directories (arch/metag/{lib,tbx})
> into metag_ksyms.c so that they don't get omitted by the static linker
> if they're not used by any other statically linked code, which can
> result in undefined symbols when building modules.
>
> For example a randconfig caused the following error:
> ERROR: "csum_partial" [fs/reiserfs/reiserfs.ko] undefined!
>
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> ---
> Unless there are any objections I'll apply this patch for v3.11. I'm
> assuming *_ksyms.c is the way that this problem is normally worked
> around.

Actually, normally those files are obj-y not lib-y.  See the top-level
lib/.

Subtle, I know.

Cheers,
Rusty.
