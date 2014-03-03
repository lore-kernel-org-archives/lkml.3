Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760AbaCCTNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:13:10 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:33271 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324AbaCCTNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 14:13:06 -0500
Message-ID: <5314D43C.8030203@gmail.com>
Date: Mon, 03 Mar 2014 20:13:00 +0100
From: poma <pomidorabelisima@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>, Richard Weinberger <richard.weinberger@gmail.com>
CC: Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>,
        "Justin M. Forbes" <jforbes@redhat.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Dave Jones <davej@redhat.com>, Christoph Hellwig <hch@lst.de>,
        eparis@parisplace.org, Al Viro <viro@zeniv.linux.org.uk>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: BUG: unable to handle kernel paging request at 0000000100000003
 - Oops: 0000 [#1] SMP
References: <53073B1A.3040709@gmail.com> <CAFLxGvygOyXrMt=UBnMUziVFG40sEQvRquGKV8kyrhdp-_NrgQ@mail.gmail.com> <20140221154823.GA21405@quack.suse.cz>
In-Reply-To: <20140221154823.GA21405@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.02.2014 16:48, Jan Kara wrote:
> On Fri 21-02-14 14:08:03, Richard Weinberger wrote:
>> On Fri, Feb 21, 2014 at 12:40 PM, poma <pomidorabelisima@gmail.com> wrote:
>>>
>>> Affected kernels - 3.14.0-0.rc3*:
>>>
>>> - 3.14.0-0.rc3.git0.1
>>>   http://koji.fedoraproject.org/koji/buildinfo?buildID=498711
>>>
>>> - 3.14.0-0.rc3.git0.7 based on 3.14.0-0.rc3.git0.1
>>>
>>> - 3.14.0-0.rc3.git2.1
>>>   http://koji.fedoraproject.org/koji/buildinfo?buildID=499061
>>>
>>> - 3.14.0-0.rc3.git5.1
>>>   http://koji.fedoraproject.org/koji/buildinfo?buildID=499636
>>>
>>> Memtest86+ 4.20 - OK
>>> http://goo.gl/1nm1nV
>>>
>>> RHBZ
>>> https://bugzilla.redhat.com/show_bug.cgi?id=1067919
>>>
>>> messages-Oops-es-3.14.0-0.rc3
>>> https://bugzilla.redhat.com/attachment.cgi?id=865926
>>
>> Maybe commits 7053aee26a3548ebaba046ae2e52396ccf56ac6c (fsnotify: do
>> not share events between notification groups)
>> and 85816794240b9659e66e4d9b0df7c6e814e5f603 (fanotify: Fix use after
>> free for permission events) introduced this regression.
>   So the immediate problem seems to be that event->tgid is 0xffffffff
> instead of a pointer. I don't see how this could be use after free and we
> unconditionally initialize event->tgid to something sensible. Hum, but if
> it is an overflow event, we are in a trouble since that doesn't have ->tgid
> field at all so we read random crap that happens to be beyond the event
> structure. Actually there seem to be more problems in the handling of
> overflow event so I better add that to my testing (both for fanotify and
> inotify). I'll work on the fix. Thanks for report!
> 
> 								Honza
> 

The test was successfully completed with the '3.14-rc5'.
Thanks guys, Jan for the patchwork!


poma


