Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab3IQVux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 17:50:53 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:48739 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab3IQVuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 17:50:51 -0400
MIME-Version: 1.0
X-Originating-IP: [89.2.206.189]
In-Reply-To: <5238B55A.5050002@hauke-m.de>
References: <CAG-2HqUUbmcEoYqV+qi8SWZXzSLd22WUO88Gry6Mc1GQJy-Ocg@mail.gmail.com>
 <5238B55A.5050002@hauke-m.de>
From: Tom Gundersen <teg@jklm.no>
Date: Tue, 17 Sep 2013 23:50:29 +0200
Message-ID: <CAG-2HqVhRZYJjnk4pRbzEF4Uz0R-Aw3_RVTV+utru2nx7HqpnA@mail.gmail.com>
Subject: Re: [REGRESSION]: bcma: fix handling of big addrl
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 10:02 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> On 09/17/2013 09:11 PM, Tom Gundersen wrote:
>> The above commit causes a regression for me.
>>
>> Booting with initcall_debug shows that bcma_modinit never returns:
>>
>> calling  bcma_modinit+0x0/0x33 [bcma] @ 210
>> bcma-pci-bridge 0000:02:00.0: enabling device (0000 -> 0002)
>> bcma: bus0: Found chip with id 0xA8D8, rev 0x01 and package 0x08
>>
>> Which means that (obviously) my wireless nic doesnot work (doe not
>> show up in "ip addr"). Moreover, the kernel hangs during reboot and
>> I'm forced to do a hard-reboot.
>>
>> Reverting the offending commit on top of 3.12-rc1 fixes the problem.
>
> There is already a patch in wireless-testing on its way into linux tree:
>
> https://git.kernel.org/cgit/linux/kernel/git/linville/wireless-testing.git/commit/?id=167fef2a4dce0fa9b9b847bac91cd06c191396d2

Thanks for the reference, hadn't seen that. FWIW, it works for me.

Cheers,

Tom
