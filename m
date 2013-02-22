Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab3BVJxb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 04:53:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755256Ab3BVJx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 04:53:28 -0500
Message-ID: <51273FE3.8000306@redhat.com>
Date: Fri, 22 Feb 2013 10:52:35 +0100
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Zach Brown <zab@redhat.com>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <aviro@redhat.com>, "Martin K. Petersen" <mkp@mkp.net>,
        Hannes Reinecke <hare@suse.de>, Joel Becker <jlbec@evilplan.org>
Subject: Re: New copyfile system call - discuss before LSF?
References: <512606DF.5050706@redhat.com> <4FA345DA4F4AE44899BD2B03EEEC2FA9235D998C@SACEXCMBX04-PRD.hq.netapp.com> <512635D2.4090207@redhat.com> <51267CEB.8070805@redhat.com> <4FA345DA4F4AE44899BD2B03EEEC2FA9235DAA99@SACEXCMBX04-PRD.hq.netapp.com> <20130221222449.GY22221@lenny.home.zabbo.net> <51273EBB.1010305@redhat.com>
In-Reply-To: <51273EBB.1010305@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2013 10:47 AM, Paolo Bonzini wrote:
> Il 21/02/2013 23:24, Zach Brown ha scritto:
>> You could make it work with some locking and out_fd seeking to set the
>> write offset before calling sendfile64()+flags, but ugh.
>>
>>   ssize_t sendfile(int out_fd, int in_fd, off_t in_offset, off_t
>>                    out_offset, size_t count, int flags);
>>
>> That seems closer.
>>
>> We might also want to pre-emptively offer iovs instead of offsets,
>> because that's the very first thing that's going to be requested after
>> people prototype having to iterate calling sendfile() for each
>> contiguous copy region.
> Indeed, I was about to propose that exactly.  So that would be
> psendfilev.  I don't think psendfile is useful, and can be easily
> provided at the libc level.
>
> Paolo

This seems to be suspiciously close to a clear consensus on how to move forward 
after many years of spinning our wheels. Anyone want to promote an actual patch 
before we change our collective minds?

Ric

