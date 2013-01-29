Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab3A2C1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 21:27:18 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:58098 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab3A2C1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 21:27:16 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVvO+mgZxKmA4aGS0ujngux97kK7F0JkA4oYVhVEi_bGw@mail.gmail.com>
References: <20130109132409.GB18395@phenom.dumpdata.com>
	<CAE9FiQUznCR6i56AW6jhiCCK-pQxnAquzxUoWWQamoSC8YAZKA@mail.gmail.com>
	<87d2xeul5v.fsf@xmission.com>
	<CAE9FiQX-OxTzt3BPh3nSLQxDUBGR=eKob5AqXYzy=Lw9NYTaGw@mail.gmail.com>
	<CAE9FiQVsbDfLOyv=D4_BLtrKpp+Ydj7pren8Cu3rNGztbj=w=w@mail.gmail.com>
	<20130111163548.GB25620@phenom.dumpdata.com>
	<CAE9FiQVts6aTaRFM3aKWj46RCRiheM5gS55h=LVveaGXk_kR8g@mail.gmail.com>
	<CAE9FiQVTfTisOrrQhv0vmsgA8Asaj5EUE5s93OFyTHfA+dWdfQ@mail.gmail.com>
	<CAE9FiQWU6mnWxnzDtaR51H7GTbYmKgb0zy6xRCGYO4+oyc82Gg@mail.gmail.com>
	<20130118155535.GJ9973@phenom.dumpdata.com>
	<20130124153924.GA5943@konrad-lan.dumpdata.com>
	<CAKocOONcM4HK1ZtUJb7C1xVCEWcz_pG2UZ0hzxGpxSmBSYa1Ww@mail.gmail.com>
	<CAKocOOPvK5S92ESU12yN5U=8fjSDFtDMrjJAmqxkqqTrzFzVCA@mail.gmail.com>
	<CAE9FiQVvO+mgZxKmA4aGS0ujngux97kK7F0JkA4oYVhVEi_bGw@mail.gmail.com>
Date: Mon, 28 Jan 2013 19:27:14 -0700
Message-ID: <CAKocOONhdcDG65MF9jaiM0Pi4RsXq1MaLtRfhqR7831K6QgC-w@mail.gmail.com>
Subject: Re: [PATCH v7u1 26/31] x86: Don't enable swiotlb if there is not
 enough ram for it
From: Shuah Khan <shuahkhan@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 2:50 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Thu, Jan 24, 2013 at 11:22 AM, Shuah Khan <shuahkhan@gmail.com> wrote:
>>>
>>> I still have the AMD system I tested earlier versions of this work. I
>>> started compiles with these patches on 3.7 and will let you know the
>>> status.
>>
>> Tested 3.8-rc4 with the patches on AMD system with IOMMU on. Looks
>> good. I can't test low memory paths on this system very easily without
>> mucking with the code and force it treat it as low memory. So I just
>> tested the normal path. My main goal was to make sure AMD iommu driver
>> can still enable switolb and it does.
>
> good.
>
>>
>> If you would like to me test the error cases, please let me know.
>
> please check
> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
> for-x86-boot
>
> and boot your test setups with memmap=4095$1M
>
> Thanks
>
> Yinghai

Yinghai,

Your for-x86-boot git boots on AMD system I have. However, with
memmap=4095$1M option, it panics very early in boot. I don't have
physical access to the console and I will try to get you the panic
information tomorrow.

-- Shuah
