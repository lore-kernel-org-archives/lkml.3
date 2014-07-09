Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbaGIXFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 19:05:45 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:61094 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756880AbaGIXFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 19:05:42 -0400
MIME-Version: 1.0
In-Reply-To: <201407092300.25224.marex@denx.de>
References: <cover.1404475462.git.d.kasatkin@samsung.com>
	<1404750875.3029.79.camel@dhcp-9-2-203-236.watson.ibm.com>
	<53BBA6B4.7030705@samsung.com>
	<201407092300.25224.marex@denx.de>
Date: Thu, 10 Jul 2014 02:05:39 +0300
Message-ID: <CACE9dm87U+Cc=jmbFiC=TuZ4D2mDNMUhbwVW64k14stXybZdHw@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] ima: use ahash API for file hash calculation
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
To: Marek Vasut <marex@denx.de>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-crypto <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 July 2014 00:00, Marek Vasut <marex@denx.de> wrote:
> On Tuesday, July 08, 2014 at 10:07:16 AM, Dmitry Kasatkin wrote:
> [...]
>> > Right, but my concern is not about unloading the kernel module, but
>> > about the IMA module parameters left initialized.  The existing code
>> > will continue using ahash (software version), even though the kernel
>> > module was unloaded, not shash.  My question is about the software
>> > implementations of ahash vs. shash performance.
>> >
>> > Mimi
>>
>> If HW driver will not be available, ahash loads generic driver which is
>> using shash.
>> Performance of that will be the same as for using shash directly.
>
> Hi Dmitry, I think Mimi is concerned about the crypto accelerator dying mid-
> flight.
>
> Imagine a situation where you have a hardware crypto accelerator connected via
> USB. You happily use IMA with this setup for days and then someone comes around
> and pulls the USB cable out. Will this be able to cope with such situation, for
> example by switching to software operations or such in some sane way ?
>
> I presume that's the concern here.
>
> Best regards,
> Marek Vasut

Hi Marek,

Nice to here from you. How was your rest stay at Japan?

I have not seen any expression of such concern.
But as we fallback to early allocated shash, which is not USB yet,
then there is no problem.
ahash itself does not bring any other additional problem than shash itself.
They are compiled builtin together.

Thanks,
Dmitry
