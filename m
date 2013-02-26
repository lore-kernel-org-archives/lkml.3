Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab3BZW0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 17:26:20 -0500
Received: from longford.logfs.org ([213.229.74.203]:58513 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab3BZW0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 17:26:19 -0500
Date: Tue, 26 Feb 2013 16:02:32 -0500
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Zach Brown <zab@redhat.com>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Ric Wheeler <rwheeler@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <aviro@redhat.com>, "Martin K. Petersen" <mkp@mkp.net>,
        Hannes Reinecke <hare@suse.de>, Joel Becker <jlbec@evilplan.org>
Subject: Re: New copyfile system call - discuss before LSF?
Message-ID: <20130226210232.GA19510@logfs.org>
References: <512606DF.5050706@redhat.com>
 <4FA345DA4F4AE44899BD2B03EEEC2FA9235D998C@SACEXCMBX04-PRD.hq.netapp.com>
 <512635D2.4090207@redhat.com>
 <51267CEB.8070805@redhat.com>
 <4FA345DA4F4AE44899BD2B03EEEC2FA9235DAA99@SACEXCMBX04-PRD.hq.netapp.com>
 <20130221222449.GY22221@lenny.home.zabbo.net>
 <512BD44C.40907@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <512BD44C.40907@amacapital.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 February 2013 13:14:52 -0800, Andy Lutomirski wrote:
> 
> I thought the first thing people would ask for is to atomically create a
> new file and copy the old file into it (at least on local file systems).
>  The idea is that nothing should see an empty destination file, either
> by race or by crash.  (This feature would perhaps be described as a
> pony, but it should be implementable.)

Having already wasted many week trying to implement your pony, I would
consider it about as possible as winning the lottery three times in a
row.  It clearly is in theory and yet,...

If you take a filesystem like ext[34] you are out of luck.  In those
filesystems it may not even be theoretically possible to get the
cleanup right for pathological cases.  And if you ignore pathological
cases and depend on userspace to do the cleanup for you, you have to
do ABI extentions that I don't want to mention with Al on Cc:.  My
personal notebook ran such a kernel for several years until hardware
improved to a point that I no longer wanted to forward-port the
patches.  It worked but it was far from pretty.

If you have a filesystem where you can simply bumb a reference count
to copy the file content, implementation is fairly straightforward.
But having a system call that is effectively limited to btrfs means
pretty much noone will use it - beside the people looking for
potential kernel exploits.

So my vote clearly goes to some variant of sendfile or splice.

Jörn

--
Man darf nicht das, was uns unwahrscheinlich und unnatürlich erscheint,
mit dem verwechseln, was absolut unmöglich ist.
-- Carl Friedrich Gauß
