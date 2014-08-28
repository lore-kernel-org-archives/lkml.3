Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbaH1Pny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 11:43:54 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:48045 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbaH1Pnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 11:43:53 -0400
Message-ID: <53FF4E34.5010709@plexistor.com>
Date: Thu, 28 Aug 2014 18:43:48 +0300
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Matthew Wilcox <willy@linux.intel.com>
CC: Jens Axboe <axboe@fb.com>, Dmitry Monakhov <dmonakhov@openvz.org>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 3/5] brd: Add getgeo to block ops
References: <53FDF7AD.5000709@plexistor.com> <53FDF919.6020006@plexistor.com> <20140827175327.GF3285@linux.intel.com> <53FED9A7.3020608@plexistor.com> <20140828151126.GI3285@linux.intel.com>
In-Reply-To: <20140828151126.GI3285@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2014 06:11 PM, Matthew Wilcox wrote:
> On Thu, Aug 28, 2014 at 10:26:31AM +0300, Boaz Harrosh wrote:
<>
>> No with patch 5/5 the 4k stuff is good.
>>
>> What I'm saying is that with (64, 32, x) fdisk offers a very high first
>> sector and with all 1(s) it will allow a low value like 4k
>>
>> For example with (64, 32, x) + the 4k patch in 5/5 with a 4M brd disk it
>> will offer 40 (20K) as first possible sector.
>>
>> With this patch applied it will offer 8 (4K) as first sector, which is what
>> I want
> 
> That makes for a much better changelog entry than what you wrote above :-)
> 

OK Will do thanks

>> But is it wrong? why?
>>
>> I guess that until now no one cared about wasted space at the beginning
>> but with brd I do. Your words this is all "fake" then why at all.
>> With all 1(s) the CHS convoluted math just disappears and gets out of the
>> way.
> 
> It is all fake.  Nobody's reported their real CHS geometry in twenty
> years.  A drive's geometry has been more complex than a fixed number
> of sectors per track, and anyway the hd_geometry struct tops out at
> describing a 500GB drive (with 63 heads and 255 sectors).
> 

Right?

> My concern is that clearly (64, 32, x) works since other drivers are
> doing it.  (1, 1, 1) is stepping into the unknown, and we don't know
> what applications are going to make of this value.
> 

But you are ignoring my "it does not work" complain above?

I have tested with fdisk cfdisk gparted (and parted) and they all do
the same as before or better in the case of fdisk. I have reviewed the
source code to fdisk, and was satisfied that 1,1,1 is actually good and
fixes my problem above.

Why can't we put this in Linux-next for a while and let imaginary
"applications are going to make of this value" complain in do time.

Does anyone know of any application other then above list that I should test
with?

Let me remind you that partitions was completely broken on brd since its
inception, and no one knew about it until I started testing, so its not
like we can do *any kind* of harm with this.

> This really needs to be something that's handled by the block midlayer.
> Forcing drivers to make this stuff up is only leading to pain and
> suffering.  Drivers that don't have a getgeo method should be given a
> default geometry that makes all known users of getgeo do the right thing.
> 

Fine, I promise to do this once this test driver is to run for a cycle or
two I will do it. I will clean the all stack and have two defaults for
faking drivers and let be those old drivers that actually go to hardware
to read it. Let us have this brd driver as a test bed and I promise to
do this.

This is regular Kernel procedure. I have audited and tested to the best of
my, or ML readers ability, and we have in place a staging procedure that should
catch any problems soon enough.

Since when have we become so defensive on ZERO risk code in the Kernel. We are
changing core and revolutionary systems every day for breakfast? With far more
out reaching implications. And problems come up and we fix them.

Can we move forward please
Boaz

