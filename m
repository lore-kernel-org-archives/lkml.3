Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449AbaDNUY6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 16:24:58 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58547 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbaDNUY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 16:24:57 -0400
Date: Mon, 14 Apr 2014 16:24:52 -0400 (EDT)
Message-Id: <20140414.162452.1169041476405438694.davem@davemloft.net>
To: luto@amacapital.net
Cc: dborkman@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, ast@plumgrid.com, eparis@redhat.com,
        james.l.morris@oracle.com, keescook@chromium.org
Subject: Re: [PATCH] seccomp: fix populating a0-a5 syscall args in 32-bit
 x86 BPF
From: David Miller <davem@davemloft.net>
In-Reply-To: <534C4179.7070704@amacapital.net>
References: <1397502179-15029-1-git-send-email-dborkman@redhat.com>
	<534C4179.7070704@amacapital.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 14 Apr 2014 13:24:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 14 Apr 2014 13:13:45 -0700

> I think this description is wrong.  (unsigned long *) &sd->args[1] is
> the right location, at least on 32-bit little-endian architectures.

It absolutely is not.

The thing is a u64, and we must respect that type in a completely
portable way.

Daniel's change is %100 correct, portable, and doesn't have any
ugly ifdef crap.

If you want to optimize this, and potentially break it again, do
it in the next merge window not now.

I'm going to apply Daniel's patch.
