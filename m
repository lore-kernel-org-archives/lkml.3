Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab3KUNxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 08:53:31 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:60187 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab3KUNx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 08:53:29 -0500
References: <87ppqk6qvx.fsf@redhat.com> <CAFLxGvz3pCevxE43zGnrbX4MxPmwyb=9MVNpzFRpELt1+AmtrA@mail.gmail.com> <CA+8MBbJefz7L-C-LnhAAXB5zf-8XoMPhESPU4yd0wnuZ_YqO1w@mail.gmail.com> <A5ED84D3BB3A384992CBB9C77DEDA4D47F9DD941@USINDEM103.corp.hds.com> <52740A3A.70202@nod.at> <87r4abmnfb.fsf@redhat.com> <A5ED84D3BB3A384992CBB9C77DEDA4D47FA0B6EF@USINDEM103.corp.hds.com>
User-agent: mu4e 0.9.9.6pre2; emacs 24.3.1
From: Madper Xie <bbboson@gmail.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Madper Xie <cxie@redhat.com>, Richard Weinberger <richard@nod.at>,
        Tony Luck <tony.luck@gmail.com>,
        "matt.fleming\@intel.com" <matt.fleming@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux EFI <linux-efi@vger.kernel.org>,
        =?utf-8?B?6LCi5oiQ6aqP?= <bbboson@gmail.com>
Subject: Re: [PATCH] Make efi-pstore return a unique id
In-reply-to: <A5ED84D3BB3A384992CBB9C77DEDA4D47FA0B6EF@USINDEM103.corp.hds.com>
Date: Thu, 21 Nov 2013 21:53:07 +0800
Message-ID: <87txf5n9oc.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


seiji.aguchi@hds.com writes:

>> Then will lost the sequence of our log. We will get lots of entries like
>> "dmesg-efi-`unique but meaningless number here`" in pstore fs. Who will
>> know which file is the latest record?
>
> Ah, that's good point.
>
>> And another side, the combin of timestamp, count and part is unique. Why
>> we generate a unique number from a unique number?
>> if you think "making a string from three ints and then a parse it to a
>> int again" is odd, i'd like to use ((timestamp * 100 + part) * 100 +
>> count.
>
> How about calculating the number of digit of part /count, instead of using fixed "100"?
> We can ensure the uniqueness of each id by doing it.
>
> digit_num = log2(part)/log2(10) + 1
> timestamp * 10^(digit_num + 1)
>
Then we must implement a log10 and a pow func...
And reverting id to timestamp, part and count will hard if we using
unfixed length of count and id.

So i'd like to using fixed length. My dell xps has 128kb nvram
space. and it at most store 126 pstore entries. So I think 1000 will be
a safe value for count. For part, 100 should be okay. I don't think
there will be a large kmsg and we must split it into more than 100 parts.

> Seiji

