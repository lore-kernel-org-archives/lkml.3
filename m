Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab3AKVwO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 16:52:14 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:47292 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050Ab3AKVwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 16:52:12 -0500
Message-ID: <50F0897E.6080607@oracle.com>
Date: Fri, 11 Jan 2013 15:51:58 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130109 Thunderbird/17.0.2
MIME-Version: 1.0
To: sedat.dilek@gmail.com
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>
Subject: Re: [PATCH V5 00/30] loop: Issue O_DIRECT aio using bio_vec
References: <1357761525-22718-1-git-send-email-dave.kleikamp@oracle.com> <CA+icZUWkUrFSMzB1p+6KgVkbxn9NtpfZUHgn6wUs4r3zkrpmjA@mail.gmail.com>
In-Reply-To: <CA+icZUWkUrFSMzB1p+6KgVkbxn9NtpfZUHgn6wUs4r3zkrpmjA@mail.gmail.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2013 09:46 AM, Sedat Dilek wrote:

> Hi Dave,
> 
> I am using here Ubuntu/precise AMD64 as a WUBI-installed system.
> 
> Not sure if WUBI [1] is a good test-candidate.
> 
> [ /boot/grub/grub.cfg ]
> ...
>         set root=(loop0)
>         linux   /boot/vmlinuz-3.8.0-rc2-9-iniza-generic
> root=UUID=001AADA61AAD9964 loop=/ubuntu/disks/root.disk ro
> ...
> 
> Poops, I did it (not again) but for the first time to test your
> loop-patchset on top of Linux v3.8-rc2 plus some important other stuff
> (see patches/ dir in attached tarball).
> 
> As I did not know how to test it in a meaningful way I just run the
> "lite" test-script from LTP [2].
> Please, have a look at the ERRORs and failures.

I'd really like to know if these same testcases fail without my
patchset. I'm going to play with ltp on loop-mounted filesystems, but I
don't intend to play with WUBI at all.

I'd be interested if my patchset introduces regressions, but not so much
if the same testcases fail previously.

> $ egrep -i 'error|fail'
> for-dkleikamp/tests/runltplite-results_loop-experimental.txt | grep -v
> -i expected | wc -l
> 210
> 
> In good old German tradition I have collected some interesting stuff
> in the attached tarball ;-).
> If something is missing - blame me.
> Don't hesitate to ask (I have your patchset for a while on my radar).
> 
> Thanks!
> 
> Regards,
> - Sedat -
> 
> [1] https://wiki.ubuntu.com/WubiGuide
> [2] http://sourceforge.net/projects/ltp/
