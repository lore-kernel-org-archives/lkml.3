Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab3C3WlT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 18:41:19 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:48420 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334Ab3C3WlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 18:41:16 -0400
MIME-Version: 1.0
In-Reply-To: <20130330194933.GB1005@amd.pavel.ucw.cz>
References: <512606DF.5050706@redhat.com> <4FA345DA4F4AE44899BD2B03EEEC2FA9235D998C@SACEXCMBX04-PRD.hq.netapp.com>
 <512635D2.4090207@redhat.com> <51267CEB.8070805@redhat.com>
 <4FA345DA4F4AE44899BD2B03EEEC2FA9235DAA99@SACEXCMBX04-PRD.hq.netapp.com>
 <20130221222449.GY22221@lenny.home.zabbo.net> <512BD44C.40907@amacapital.net>
 <20130226210232.GA19510@logfs.org> <20130330194933.GB1005@amd.pavel.ucw.cz>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 30 Mar 2013 15:40:55 -0700
Message-ID: <CALCETrVB_6V8nqKJ_moRN4VnV=pHRJen2iSLybAc39XbjyBFdg@mail.gmail.com>
Subject: Re: New copyfile system call - discuss before LSF?
To: Pavel Machek <pavel@ucw.cz>
Cc: =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>,
        Zach Brown <zab@redhat.com>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Ric Wheeler <rwheeler@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <aviro@redhat.com>, "Martin K. Petersen" <mkp@mkp.net>,
        Hannes Reinecke <hare@suse.de>, Joel Becker <jlbec@evilplan.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 30, 2013 at 12:49 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> > I thought the first thing people would ask for is to atomically create a
>> > new file and copy the old file into it (at least on local file systems).
>> >  The idea is that nothing should see an empty destination file, either
>> > by race or by crash.  (This feature would perhaps be described as a
>> > pony, but it should be implementable.)
>>
>> Having already wasted many week trying to implement your pony, I would
>> consider it about as possible as winning the lottery three times in a
>> row.  It clearly is in theory and yet,...
>
> Hmm, really? AFAICT it would be simple to provide open_deleted_file("directory")
> syscall. You'd open_deleted_file(), copy source file into it, then
> fsync(), then link it into filesystem.

Isn't linking a deleted file back into the filesystem explicitly
forbidden?  I'm pretty sure that linking from /proc/fd/whatever
doesn't work.  (I've often wanted a flink system call that takes a
file descriptor and links it somewhere.  If it came with an option to
control whether it would overwrite an existing file, even better.)

--Andy
