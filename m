Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965388AbaD2WaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 18:30:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35451 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152AbaD2WaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 18:30:23 -0400
Date: Tue, 29 Apr 2014 15:30:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/1] Revert
 "affs: use ->kill_sb() to simplify ->put_super() and failure exits of ->mount()"
Message-Id: <20140429153022.d21bf4df16915a8b773d7651@linux-foundation.org>
In-Reply-To: <20140429213512.7b9a783a970a193728ab4335@skynet.be>
References: <20140429213512.7b9a783a970a193728ab4335@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2014 21:35:12 +0200 Fabian Frederick <fabf@skynet.be> wrote:

> This reverts commit 842a859db26b70 due to permanent crash issues.
> 
> Sample scenario:
> 
> dd if=/dev/zero of=f1 bs=1M count=1
> losetup -f f1
> mount -t affs -o unknownoption /dev/loop0 mnt1
> -> crash

Thanks for the bug report ;)

> With patch revert:
> "mount: wrong fs type, bad option, bad superblock on /dev/loop0"

But reverting is premature.  With this info Al will presumably fix this up.


