Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936329AbaH1H0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 03:26:36 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35615 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936214AbaH1H0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 03:26:34 -0400
Message-ID: <53FED9A7.3020608@plexistor.com>
Date: Thu, 28 Aug 2014 10:26:31 +0300
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Matthew Wilcox <willy@linux.intel.com>
CC: Jens Axboe <axboe@fb.com>, Dmitry Monakhov <dmonakhov@openvz.org>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 3/5] brd: Add getgeo to block ops
References: <53FDF7AD.5000709@plexistor.com> <53FDF919.6020006@plexistor.com> <20140827175327.GF3285@linux.intel.com>
In-Reply-To: <20140827175327.GF3285@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2014 08:53 PM, Matthew Wilcox wrote:
> On Wed, Aug 27, 2014 at 06:28:25PM +0300, Boaz Harrosh wrote:
>> We set all hd_geometry members to 1, because this way fdisk
>> math will not try its crazy geometry math and get stuff totally wrong.
>>
>> I was trying to get some values that will make fdisk Want to align
>> first sector on 4K (like 8, 16, 20, ... sectors) but nothing worked,
>> I searched the net the math is not your regular simple multiplication
>> at all.
>>
>> If you managed to get these please tell me. I would love to solve
>> this.
>>
>> But for now we use 4k physical sectors for fixing fdisk alignment
>> issues, and setting these here to something that will not make
>> fdisk serve us with crazy numbers.
> 
> Are you saying that fdisk ignores the 4k physical sectors (that you set up
> in patch 5/5) in favour of the geometry exposed here?  That doesn't make
> sense to me, since it would misalign 4k-physical ATA drives if it did.
> 

No with patch 5/5 the 4k stuff is good.

What I'm saying is that with (64, 32, x) fdisk offers a very high first
sector and with all 1(s) it will allow a low value like 4k

For example with (64, 32, x) + the 4k patch in 5/5 with a 4M brd disk it
will offer 40 (20K) as first possible sector.

With this patch applied it will offer 8 (4K) as first sector, which is what
I want

> I don't see anywhere else in the kernel reporting (1,1,1).  The most common
> form to fake a geometry uses (64, 32, x), including SCSI.
>

But is it wrong? why?

I guess that until now no one cared about wasted space at the beginning
but with brd I do. Your words this is all "fake" then why at all.
With all 1(s) the CHS convoluted math just disappears and gets out of the
way.

This is clearly the case of copy/paste so long in the history of the code
that no one knows why it was done originally, and it has become religion
that if you dare touch it ghost will come out of closets.

But I looked at the code's math and I found that this is better.

And why not let it be a flag to UM that this is RAM based? If legacy
code likes it just fine, why do we think otherwise?

Thanks
Boaz

