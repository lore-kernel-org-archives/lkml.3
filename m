Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab3CaXPg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 19:15:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755895Ab3CaXPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 19:15:33 -0400
Message-ID: <5158C347.3090400@redhat.com>
Date: Sun, 31 Mar 2013 19:14:15 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Andreas Dilger <adilger@dilger.ca>,
        =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>,
        Andy Lutomirski <luto@amacapital.net>, Zach Brown <zab@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <aviro@redhat.com>, "Martin K. Petersen" <mkp@mkp.net>,
        Hannes Reinecke <hare@suse.de>, Joel Becker <jlbec@evilplan.org>
Subject: Re: openat(..., AT_UNLINKED) was Re: New copyfile system call - discuss
 before LSF?
References: <512BD44C.40907@amacapital.net> <20130226210232.GA19510@logfs.org> <20130330194933.GB1005@amd.pavel.ucw.cz> <08D26E22-3856-43A4-8835-48C86CC5F71C@dilger.ca> <20130330214509.GB4322@amd.pavel.ucw.cz> <925D663D-D8F8-4297-A642-33C732354701@netapp.com> <20130331073604.GA13159@amd.pavel.ucw.cz> <1364754452.4771.10.camel@leira.trondhjem.org> <20130331183238.GA25751@amd.pavel.ucw.cz> <1364755493.4771.14.camel@leira.trondhjem.org> <20130331225022.GA31552@amd.pavel.ucw.cz>
In-Reply-To: <20130331225022.GA31552@amd.pavel.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2013 06:50 PM, Pavel Machek wrote:
> On Sun 2013-03-31 18:44:53, Myklebust, Trond wrote:
>> On Sun, 2013-03-31 at 20:32 +0200, Pavel Machek wrote:
>>>>>>> Hmm. open_deleted_file() will still need to get a directory... so it
>>>>>>> will still need a path. Perhaps open("/foo/bar/mnt", O_DELETED) would
>>>>>>> be acceptable interface?
>>>>>> ...and what's the big plan to make this work on anything other than ext4 and btrfs?
>>>>> Deleted but open files are from original unix, so it should work on
>>>>> anything unixy (minix, ext, ext2, ...).
>>>> minix, ext, ext2... are not under active development and haven't been
>>>> for more than a decade.
>>>>
>>>> Take a look at how many actively used filesystems out there that have
>>>> some variant of sillyrename(), and explain what you want to do in those
>>>> cases.
>>> Well. Yes, there are non-unix filesystems around. You have to deal
>>> with silly files on them, and this will not be different.
>> So this would be a local POSIX filesystem only solution to a problem
>> that has yet to be formulated?
> Problem is "clasical create temp file then delete it" is racy. See the
> archives. That is useful & common operation.

Which race are you concerned with exactly?

User wants to test for a file with name "foo.txt"

* create "foo.txt~" (or whatever)
* write contents into "foo.txt~"
* rename "foo.txt~" to "foo.txt"

Until rename is done, the file does not exists and is not complete. You will 
potentially have a garbage file to clean up if the program (or system) crashes, 
but that is not racy in a classic sense, right?

This is more of a garbage clean up issue?

Regards,

Ric

>
> Problem is "atomicaly create file at target location with guaranteed
> right content". That's also in the archives. Looks useful if someone
> does rsync from your directory.
>
> Non-POSIX filesystems have problems handling deleted files, but that
> was always the case. That's one of the reasons they are seldomly used
> for root filesystems.
>
> 									Pavel

