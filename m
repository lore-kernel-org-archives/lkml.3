Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab3JDIhh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 04:37:37 -0400
Received: from verein.lst.de ([213.95.11.211]:48599 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436Ab3JDIhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 04:37:33 -0400
Date: Fri, 4 Oct 2013 10:37:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 17/17] RCU'd vfsmounts
Message-ID: <20131004083729.GA23116@lst.de>
References: <20131003105130.GE13318@ZenIV.linux.org.uk> <CA+55aFzh+n_2fs=aWcT_5gnLC_pWSHqQPJeQ+fg=+Xw7ib9=dQ@mail.gmail.com> <20131003174439.GG13318@ZenIV.linux.org.uk> <CA+55aFy5kA7ubyetouWsB0OnB5mMRAoyQ-4kbQsCVWARFaf9MA@mail.gmail.com> <20131003194351.GK13318@ZenIV.linux.org.uk> <CA+55aFw-Yp7xEG3cnU1hcVXAHNGkCoomm0NsUt_Adf=mrauSHw@mail.gmail.com> <20131003204142.GL13318@ZenIV.linux.org.uk> <CA+55aFybjMDwdfV2uoGL=8U4c1tytjMwk4sU187e6ha2xQ=3+Q@mail.gmail.com> <20131003211448.GN13318@ZenIV.linux.org.uk> <20131004025351.GO13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004025351.GO13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 03:53:51AM +0100, Al Viro wrote:
> Speaking of those two - I really want to see file_table.c one killed.
> Christoph, do you have anything along the lines of getting rid of the
> mark_files_ro() nonsense?  After all, a combination of r/w vfsmount
> and a superblock with MS_RDONLY in flags should do about the right thing
> these days...  I can probably knock something together tomorrow, but
> you've brought that thing up quite a few times, so if you happen to have
> a patch more or less ready...

I used to have a patch for it that was also sent to the list long ago,
but it got rid of the sysrq emergency remount r/o, which people didn't like.
