Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbaD3FK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 01:10:56 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:6435 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756545AbaD3FKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 01:10:47 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AocVAIqEYFNXQytg/2dsb2JhbABZgwaCQHyoTgEBAQEBBAGZcwICgSEXdIIlAQEEAScTHCMFCwgDDgojCzkeBhOIOQwByhQXhVWIegeEOQEDjwCKDwGKeIdrgXKBQTs
Date: Wed, 30 Apr 2014 07:12:49 +0200
From: Fabian Frederick <fabf@skynet.be>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/1] Revert
 "affs: use ->kill_sb() to simplify ->put_super() and failure exits of ->mount()"
Message-Id: <20140430071249.5adde9ed67f6b8ad38b19547@skynet.be>
In-Reply-To: <20140429153022.d21bf4df16915a8b773d7651@linux-foundation.org>
References: <20140429213512.7b9a783a970a193728ab4335@skynet.be>
	<20140429153022.d21bf4df16915a8b773d7651@linux-foundation.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2014 15:30:22 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 29 Apr 2014 21:35:12 +0200 Fabian Frederick <fabf@skynet.be> wrote:
> 
> > This reverts commit 842a859db26b70 due to permanent crash issues.
> > 
> > Sample scenario:
> > 
> > dd if=/dev/zero of=f1 bs=1M count=1
> > losetup -f f1
> > mount -t affs -o unknownoption /dev/loop0 mnt1
> > -> crash
> 
> Thanks for the bug report ;)
Sorry, it was only tested under X window and box was completely frozen.
I guess Al can test with the simple steps above or I can make a complete console report.

> 
> > With patch revert:
> > "mount: wrong fs type, bad option, bad superblock on /dev/loop0"
> 
> But reverting is premature.  With this info Al will presumably fix this up.
Of course :)
