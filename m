Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbaA2J0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 04:26:50 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:48603 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaA2J0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 04:26:44 -0500
MIME-Version: 1.0
In-Reply-To: <20140128225229.GH25989@kernel.dk>
References: <20140128224336.GF25989@kernel.dk>
	<20140128225229.GH25989@kernel.dk>
Date: Wed, 29 Jan 2014 10:26:43 +0100
X-Google-Sender-Auth: vXVZDbQsUBcvL13PaIP0g13-DjA
Message-ID: <CAMuHMdUseSC+Roa5sTYfXtBxGn2OOCQpLAtdRgeoVAVdBrotWw@mail.gmail.com>
Subject: Re: [GIT PULL] Core block IO changes for 3.14
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 11:52 PM, Jens Axboe <axboe@kernel.dk> wrote:
>> - Finally the immutable biovec changes from Kent Overstreet. This
>>   enables some nice future work on making arbitrarily sized bios
>>   possible, and splitting more efficient. Related fixes to immutable
>>   bio_vecs:
>>
>>         - dm-cache immutable fixup from Mike Snitzer.
>>         - btrfs immutable fixup from Muthu Kumar.
>>
>> - bio-integrity fix from Nic Bellinger, which is also going to stable.
>>
>>
>> Please pull! There will be a bit of merge work for you, but it should be
>> fairly straight forward. It's mostly related to changin:
>>
>> bio->bi_sector  -> bio->bi_iter.bi_sector
>> bio->bi_size    -> bio->bi_iter.bi_size
>>
>>
>> git://git.kernel.dk/linux-block.git for-3.14/core
>
> BTW, let me know if you want me to merge this. The above has been in
> for-next since forever, and Stephen has carried a fix or two for new
> merges.

arch/xtensa/platforms/iss/simdisk.c:108:23: error: 'struct bio' has no
member named 'bi_sector'

http://kisskb.ellerman.id.au/kisskb/buildresult/10542666/

Reported before at:
http://www.spinics.net/lists/dm-devel/msg20937.html

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
