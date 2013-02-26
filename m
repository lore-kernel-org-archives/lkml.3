Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab3BZWfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 17:35:37 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:44327 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265Ab3BZWff convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 17:35:35 -0500
MIME-Version: 1.0
In-Reply-To: <20130226210232.GA19510@logfs.org>
References: <512606DF.5050706@redhat.com> <4FA345DA4F4AE44899BD2B03EEEC2FA9235D998C@SACEXCMBX04-PRD.hq.netapp.com>
 <512635D2.4090207@redhat.com> <51267CEB.8070805@redhat.com>
 <4FA345DA4F4AE44899BD2B03EEEC2FA9235DAA99@SACEXCMBX04-PRD.hq.netapp.com>
 <20130221222449.GY22221@lenny.home.zabbo.net> <512BD44C.40907@amacapital.net> <20130226210232.GA19510@logfs.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 26 Feb 2013 14:35:14 -0800
Message-ID: <CALCETrWiEphKS71sKwukTjAg802sezQCZ4h2sT9JcJBJg5=gHA@mail.gmail.com>
Subject: Re: New copyfile system call - discuss before LSF?
To: =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>
Cc: Zach Brown <zab@redhat.com>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Ric Wheeler <rwheeler@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <aviro@redhat.com>, "Martin K. Petersen" <mkp@mkp.net>,
        Hannes Reinecke <hare@suse.de>, Joel Becker <jlbec@evilplan.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 1:02 PM, Jörn Engel <joern@logfs.org> wrote:
> On Mon, 25 February 2013 13:14:52 -0800, Andy Lutomirski wrote:
>>
>> I thought the first thing people would ask for is to atomically create a
>> new file and copy the old file into it (at least on local file systems).
>>  The idea is that nothing should see an empty destination file, either
>> by race or by crash.  (This feature would perhaps be described as a
>> pony, but it should be implementable.)
>
> Having already wasted many week trying to implement your pony, I would
> consider it about as possible as winning the lottery three times in a
> row.  It clearly is in theory and yet,...
>
> If you take a filesystem like ext[34] you are out of luck.  In those
> filesystems it may not even be theoretically possible to get the
> cleanup right for pathological cases.  And if you ignore pathological
> cases and depend on userspace to do the cleanup for you, you have to
> do ABI extentions that I don't want to mention with Al on Cc:.  My
> personal notebook ran such a kernel for several years until hardware
> improved to a point that I no longer wanted to forward-port the
> patches.  It worked but it was far from pretty.
>
> If you have a filesystem where you can simply bumb a reference count
> to copy the file content, implementation is fairly straightforward.
> But having a system call that is effectively limited to btrfs means
> pretty much noone will use it - beside the people looking for
> potential kernel exploits.

:)

>
> So my vote clearly goes to some variant of sendfile or splice.

Don't get me wrong -- the vpsendfile (or whatever it's called) idea
sounds extremely useful too.

--Andy
