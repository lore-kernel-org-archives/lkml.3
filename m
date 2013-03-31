Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab3CaX3o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 19:29:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755985Ab3CaX3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 19:29:43 -0400
Message-ID: <5158C6A8.9020505@redhat.com>
Date: Sun, 31 Mar 2013 19:28:40 -0400
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
References: <20130330194933.GB1005@amd.pavel.ucw.cz> <08D26E22-3856-43A4-8835-48C86CC5F71C@dilger.ca> <20130330214509.GB4322@amd.pavel.ucw.cz> <925D663D-D8F8-4297-A642-33C732354701@netapp.com> <20130331073604.GA13159@amd.pavel.ucw.cz> <1364754452.4771.10.camel@leira.trondhjem.org> <20130331183238.GA25751@amd.pavel.ucw.cz> <1364755493.4771.14.camel@leira.trondhjem.org> <20130331225022.GA31552@amd.pavel.ucw.cz> <5158C347.3090400@redhat.com> <20130331231854.GA32174@amd.pavel.ucw.cz>
In-Reply-To: <20130331231854.GA32174@amd.pavel.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2013 07:18 PM, Pavel Machek wrote:
> Hi!
>
>>>>>> Take a look at how many actively used filesystems out there that have
>>>>>> some variant of sillyrename(), and explain what you want to do in those
>>>>>> cases.
>>>>> Well. Yes, there are non-unix filesystems around. You have to deal
>>>>> with silly files on them, and this will not be different.
>>>> So this would be a local POSIX filesystem only solution to a problem
>>>> that has yet to be formulated?
>>> Problem is "clasical create temp file then delete it" is racy. See the
>>> archives. That is useful & common operation.
>> Which race are you concerned with exactly?
>>
>> User wants to test for a file with name "foo.txt"
>>
>> * create "foo.txt~" (or whatever)
>> * write contents into "foo.txt~"
>> * rename "foo.txt~" to "foo.txt"
>>
>> Until rename is done, the file does not exists and is not complete.
>> You will potentially have a garbage file to clean up if the program
>> (or system) crashes, but that is not racy in a classic sense, right?
> Well. If people rsync from you, they will start fetching incomplete
> foo.txt~. Plus the garbage issue.

That is not racy, just garbage (not trying to be pedantic, just trying to 
understand). I can see that the "~" file is annoying, but we have dealt with it 
for a *long* time :)

Until it has the right name (on either the source or target system for rsync), 
it is not the file you are looking for.
>
>> This is more of a garbage clean up issue?
> Also. Plus sometimes you want temporary "file" that is
> deleted. Terminals use it for history, etc...

There you would have a race, you can create a file and unlink it of course and 
still write to it, but you would have a potential empty file issue?

Ric


