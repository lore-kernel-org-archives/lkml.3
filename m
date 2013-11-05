Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab3KEV1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 16:27:46 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:49134 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635Ab3KEV1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 16:27:43 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <20131105205623.3802.5166@localhost.localdomain>
References: <CAHbNUh1Cw3bc4WR0VcD1H_eKYqGBtv_215_euh6mwTbZ41ejUw@mail.gmail.com>
	<52794823.7080503@kernel.dk>
	<CAOesGMj1xXXM-gNgWQwBKOczpJtM7CobYy4h7Fe=4W3U43EJGQ@mail.gmail.com>
	<20131105203308.3802.45122@localhost.localdomain>
	<CAOesGMirg=ex9hLCjGBpj0cMhLeQ5cJQoRv72tgg7PoSKWUDhA@mail.gmail.com>
	<20131105205623.3802.5166@localhost.localdomain>
Date: Tue, 5 Nov 2013 13:27:42 -0800
Message-ID: <CAOesGMhTu_bifFUNDGPsd9Hmn50W_OHF_+LgscF4WLyNY-bHQg@mail.gmail.com>
Subject: Re: Boot failure on Arndale with next-20131105
From: Olof Johansson <olof@lixom.net>
To: Chris Mason <chris.mason@fusionio.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tushar Behera <tushar.behera@linaro.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Kent Overstreet <kmo@daterainc.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 5, 2013 at 12:56 PM, Chris Mason <chris.mason@fusionio.com> wrote:
> Quoting Olof Johansson (2013-11-05 15:38:33)
>> On Tue, Nov 5, 2013 at 12:33 PM, Chris Mason <chris.mason@fusionio.com> wrote:
>> > Quoting Olof Johansson (2013-11-05 15:23:51)
>> >> On Tue, Nov 5, 2013 at 11:33 AM, Jens Axboe <axboe@kernel.dk> wrote:
>> >
>> > [ horrible crashes fixed by removing my patch ]
>> >
>> >> > Very weird! What file system is being used?
>> >>
>> >> Most of my failures have happened on regular MMC cards with ext4
>> >> filesystems on them.
>> >>
>> >> Note that the panic happens during device probe / partition table
>> >> scanning, not after mounting the filesystem.
>> >>
>> >> Giving your patch a go now across the board. I'm very concerned about
>> >> the reports of bisectability, build failures and heaps of warnings
>> >> though. Did the 0-day builder pick up any of those? :-/
>> >>
>> >
>> > Hmmm, is bcache in your config?
>>
>> Doesn't look that way -- no ARM defconfigs enable it (it's what I
>> build and boot), and the option defaults to off and nothing selects
>> it.
>
> Ok, I think I see it.  My guess is that you're hitting bounce buffers.
> __blk_queue_bounce is the only caller of the bio splitting code I can
> see that you might be hitting.
>
> My first patch exposed a lurking bug in bio_clone_biovec.  Basically
> bio->bi_vcnt is being doubled instead of initialized.
>
> This patch is only compile tested, but I think it'll fix it.

Thanks, giving it a go now (will have results in 30+ minutes). Jens'
patch didn't make a difference, which makes sense given lack of dm
usage.


-Olof
