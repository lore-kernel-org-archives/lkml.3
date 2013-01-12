Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab3ALKwG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 05:52:06 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:36922 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab3ALKwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 05:52:04 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <50F0897E.6080607@oracle.com>
References: <1357761525-22718-1-git-send-email-dave.kleikamp@oracle.com>
	<CA+icZUWkUrFSMzB1p+6KgVkbxn9NtpfZUHgn6wUs4r3zkrpmjA@mail.gmail.com>
	<50F0897E.6080607@oracle.com>
Date: Sat, 12 Jan 2013 11:52:02 +0100
Message-ID: <CA+icZUXuUswsriQL_FEJC-r57WqOVVtDfhzfM9LB5kj=ZLWS8A@mail.gmail.com>
Subject: Re: [PATCH V5 00/30] loop: Issue O_DIRECT aio using bio_vec
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 10:51 PM, Dave Kleikamp
<dave.kleikamp@oracle.com> wrote:
> On 01/10/2013 09:46 AM, Sedat Dilek wrote:
>
>> Hi Dave,
>>
>> I am using here Ubuntu/precise AMD64 as a WUBI-installed system.
>>
>> Not sure if WUBI [1] is a good test-candidate.
>>
>> [ /boot/grub/grub.cfg ]
>> ...
>>         set root=(loop0)
>>         linux   /boot/vmlinuz-3.8.0-rc2-9-iniza-generic
>> root=UUID=001AADA61AAD9964 loop=/ubuntu/disks/root.disk ro
>> ...
>>
>> Poops, I did it (not again) but for the first time to test your
>> loop-patchset on top of Linux v3.8-rc2 plus some important other stuff
>> (see patches/ dir in attached tarball).
>>
>> As I did not know how to test it in a meaningful way I just run the
>> "lite" test-script from LTP [2].
>> Please, have a look at the ERRORs and failures.
>
> I'd really like to know if these same testcases fail without my
> patchset. I'm going to play with ltp on loop-mounted filesystems, but I
> don't intend to play with WUBI at all.
>

I am preparing now two kernels against Linux v3.8-rc3 (as your
patchset applies cleany) with 2 important patches which I need here
(1. mei: no proper reboot and 2. (S)ATA fix).

I will attach two tarballs for each kernel-setup and run LTP "lite"
again (tarballs will include the results).

> I'd be interested if my patchset introduces regressions, but not so much
> if the same testcases fail previously.
>

Hmm, regressions is always good to test.
As a "customer" aka tester I want to see any benefit means for most
power-users: Do I get some speedups?
That's the main background of my askings.

As said here I am running Ubuntu as a WUBI-installation.
This system is predestinated for testing loop improvements.
So again and no sorry: How can I test reliable speed improvements?
I remember linux-fs/linux-xfs folks have a tool could be named
"xfstests" (note2myself: more coffee!).
Any hints for testing appreciated!

- Sedat -

>> $ egrep -i 'error|fail'
>> for-dkleikamp/tests/runltplite-results_loop-experimental.txt | grep -v
>> -i expected | wc -l
>> 210
>>
>> In good old German tradition I have collected some interesting stuff
>> in the attached tarball ;-).
>> If something is missing - blame me.
>> Don't hesitate to ask (I have your patchset for a while on my radar).
>>
>> Thanks!
>>
>> Regards,
>> - Sedat -
>>
>> [1] https://wiki.ubuntu.com/WubiGuide
>> [2] http://sourceforge.net/projects/ltp/
