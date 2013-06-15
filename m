Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab3FOF0e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 01:26:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34532 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab3FOF0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 01:26:32 -0400
Date: Sat, 15 Jun 2013 06:26:31 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Chiluk <chiluk@canonical.com>
Cc: Petr Vandrovec <petr@vandrovec.name>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ncpfs: fix rmdir returns Device or resource busy
Message-ID: <20130615052631.GP4165@ZenIV.linux.org.uk>
References: <51A918B8.20303@canonical.com>
 <CA+i2_De5HHw2H9SvZ=W+QAOcy0M7jFac88OK6aeYdJVCGL6b+A@mail.gmail.com>
 <51AF9D77.2000901@canonical.com>
 <CA+i2_DfEhn_CPRBmyy4scG7UEL5bGsjodcq00Nyx4JZjnuSBGQ@mail.gmail.com>
 <51B205A1.4040405@canonical.com>
 <20130607161452.GI13110@ZenIV.linux.org.uk>
 <20130613020122.GA20274@ZenIV.linux.org.uk>
 <20130613064235.GK4165@ZenIV.linux.org.uk>
 <51BA99CE.8000902@canonical.com>
 <20130615050939.GO4165@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130615050939.GO4165@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 15, 2013 at 06:09:39AM +0100, Al Viro wrote:

> BTW, in ncp_fill_cache() we have a provably pointless
>                 if (!ino)
>                         ino = find_inode_number(dentry, &qname);
> Check it out - any path that can lead there with ino == 0 will *not*
> have a positive dentry with such name, so this find_inode_number()
> call is just "waste some time and return 0".  Cargo-cult, plain and
> simple...

Incidentally, the only other caller of find_inode_number() is equally
pointless, so I'm very inclined to kill the damn function off.  Sure,
it's exported.  And I'm fairly sure that its out-of-tree users are
just as fishy (as in Innsmouth)...
