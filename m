Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab3C3XWh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 19:22:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754993Ab3C3XWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 19:22:23 -0400
Message-ID: <51577363.9060201@redhat.com>
Date: Sat, 30 Mar 2013 19:21:07 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
CC: Pavel Machek <pavel@ucw.cz>, Andreas Dilger <adilger@dilger.ca>,
        =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>,
        Andy Lutomirski <luto@amacapital.net>, Zach Brown <zab@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <aviro@redhat.com>, "Martin K. Petersen" <mkp@mkp.net>,
        Hannes Reinecke <hare@suse.de>, Joel Becker <jlbec@evilplan.org>
Subject: Re: New copyfile system call - discuss before LSF?
References: <512606DF.5050706@redhat.com> <4FA345DA4F4AE44899BD2B03EEEC2FA9235D998C@SACEXCMBX04-PRD.hq.netapp.com> <512635D2.4090207@redhat.com> <51267CEB.8070805@redhat.com> <4FA345DA4F4AE44899BD2B03EEEC2FA9235DAA99@SACEXCMBX04-PRD.hq.netapp.com> <20130221222449.GY22221@lenny.home.zabbo.net> <512BD44C.40907@amacapital.net> <20130226210232.GA19510@logfs.org> <20130330194933.GB1005@amd.pavel.ucw.cz> <08D26E22-3856-43A4-8835-48C86CC5F71C@dilger.ca> <20130330214509.GB4322@amd.pavel.ucw.cz> <925D663D-D8F8-4297-A642-33C732354701@netapp.com>
In-Reply-To: <925D663D-D8F8-4297-A642-33C732354701@netapp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2013 05:57 PM, Myklebust, Trond wrote:
> On Mar 30, 2013, at 5:45 PM, Pavel Machek <pavel@ucw.cz>
>   wrote:
>
>> On Sat 2013-03-30 13:08:39, Andreas Dilger wrote:
>>> On 2013-03-30, at 12:49 PM, Pavel Machek wrote:
>>>> Hmm, really? AFAICT it would be simple to provide an
>>>> open_deleted_file("directory") syscall. You'd open_deleted_file(),
>>>> copy source file into it, then fsync(), then link it into filesystem.
>>>>
>>>> That should have atomicity properties reflected.
>>> Actually, the open_deleted_file() syscall is quite useful for many
>>> different things all by itself.  Lots of applications need to create
>>> temporary files that are unlinked at application failure (without a
>>> race if app crashes after creating the file, but before unlinking).
>>> It also avoids exposing temporary files into the namespace if other
>>> applications are accessing the directory.
>> Hmm. open_deleted_file() will still need to get a directory... so it
>> will still need a path. Perhaps open("/foo/bar/mnt", O_DELETED) would
>> be acceptable interface?
>> 									Pavel
> ...and what's the big plan to make this work on anything other than ext4 and btrfs?
>
> Cheers,
>    Trond

I know that change can be a good thing, but are we really solving a pressing 
problem given that application developers have dealt with open/rename as the way 
to get "atomic" file creation for several decades now ?

Regards,

Ric

