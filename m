Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108AbaHEI0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 04:26:09 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35761 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbaHEI0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 04:26:05 -0400
MIME-Version: 1.0
Reply-To: kerolasa@gmail.com
In-Reply-To: <20140805081238.GA3700@gmail.com>
References: <1406675682-8402-1-git-send-email-kerolasa@iki.fi>
	<20140805020024.GB27993@bbox>
	<20140805070716.GB12104@x2.net.home>
	<20140805081238.GA3700@gmail.com>
Date: Tue, 5 Aug 2014 09:26:04 +0100
X-Google-Sender-Auth: TrTb_akc-o4CVQBP4yr3C0wnkBI
Message-ID: <CAG27Bk1CHT-0FdPpFok=k4OWZyo8F2ZdmkA7BhE5+3=WWQZtSw@mail.gmail.com>
Subject: Re: zram: device management utility needed
From: Sami Kerola <kerolasa@iki.fi>
To: Minchan Kim <minchan@kernel.org>
Cc: Karel Zak <kzak@redhat.com>, util-linux <util-linux@vger.kernel.org>,
        Timofey Titovets <nefelim4ag@gmail.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 August 2014 09:12, Minchan Kim <minchan@kernel.org> wrote:
> On Tue, Aug 05, 2014 at 09:07:16AM +0200, Karel Zak wrote:
>> On Tue, Aug 05, 2014 at 11:00:24AM +0900, Minchan Kim wrote:
>> > On Wed, Jul 30, 2014 at 12:14:42AM +0100, Sami Kerola wrote:
>> > > The zram devices are not created by any sort of equipment appearing in a
>> > > bus so an method of creating new or removing existing devices will be
>> > > needed.  When the zram module is loaded it should create
>> > > /dev/zram-control device, that responds to ioctl() calls[4].  The calls
>> > > could be similar with /dev/loop-control[5], that allow adding or removing
>> > > specified device, and discover adding a free device.
>> >
>> > Normally, dynamic management is good to have, I think but I didn't hear
>> > strong requirement for that until now.
>>
>> I guess that number of zram devices will be always relatively small
>> compare to /dev/loopN devices. It is not unusual that people use
>> systems with more than 256 loop devs, so /dev/loop-control makes a lot
>> of sense to keep the device management effective and simple.
>>
>> > Why don't you change num_device param at module loading time?
>>
>> If you have really many loopN devices than create all the nodes at
>> boot time means extra overhead (allocate nodes in kernel, events to
>> udev, create /dev files etc.).  The ioctl LOOP_CTL_* API also provides
>> LOOP_CTL_GET_FREE that returns unused device, so you don't have to
>> scan all the /dev/loopN devices to detect a free device.
>
> Thanks for the info!
>
>>
>> > I'd like to hear real scenario from whom are about to using that faeture
>> > right now and what's the problem with num_device param.
>>
>> Again, I don't think it's so important for zram as for loop devices.
>> All depends how people will use zram devices. We will see...
>
> Yeb and we can do it when we see.

Hi all,

Good to hear, and I am glad coding time was not wasted propose the
dynamic zram devices in form of patches.  And as it was said before who
knows how the user kind will end up using these devices, which may mean
in future reconsideration, but for now number of devices will only
follow module load time instruction.

I think the reasonable thing to do is to adjust documentation a little
bit.  Users should load number of devices they  need plus few spares to
avoid getting corner by inability to foresee future device needs.

-- 
Sami Kerola
http://www.iki.fi/kerolasa/
