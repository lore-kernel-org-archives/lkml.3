Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab3AaThr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 14:37:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42664 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690Ab3AaTho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 14:37:44 -0500
Message-ID: <510AC79F.4030300@zytor.com>
Date: Thu, 31 Jan 2013 11:35:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Shuah Khan <shuahkhan@gmail.com>
CC: Yinghai Lu <yinghai@kernel.org>, Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v7u1 26/31] x86: Don't enable swiotlb if there is not
 enough ram for it
References: <20130109132409.GB18395@phenom.dumpdata.com> <87d2xeul5v.fsf@xmission.com> <CAE9FiQX-OxTzt3BPh3nSLQxDUBGR=eKob5AqXYzy=Lw9NYTaGw@mail.gmail.com> <CAE9FiQVsbDfLOyv=D4_BLtrKpp+Ydj7pren8Cu3rNGztbj=w=w@mail.gmail.com> <20130111163548.GB25620@phenom.dumpdata.com> <CAE9FiQVts6aTaRFM3aKWj46RCRiheM5gS55h=LVveaGXk_kR8g@mail.gmail.com> <CAE9FiQVTfTisOrrQhv0vmsgA8Asaj5EUE5s93OFyTHfA+dWdfQ@mail.gmail.com> <CAE9FiQWU6mnWxnzDtaR51H7GTbYmKgb0zy6xRCGYO4+oyc82Gg@mail.gmail.com> <20130118155535.GJ9973@phenom.dumpdata.com> <20130124153924.GA5943@konrad-lan.dumpdata.com> <CAKocOONcM4HK1ZtUJb7C1xVCEWcz_pG2UZ0hzxGpxSmBSYa1Ww@mail.gmail.com> <CAKocOOPvK5S92ESU12yN5U=8fjSDFtDMrjJAmqxkqqTrzFzVCA@mail.gmail.com> <CAE9FiQVvO+mgZxKmA4aGS0ujngux97kK7F0JkA4oYVhVEi_bGw@mail.gmail.com> <CAKocOONhdcDG65MF9jaiM0Pi4RsXq1MaLtRfhqR7831K6QgC-w@mail.gmail.com> <CAE9FiQWYHDYmNYO=Jx3e+m1+rq1vRHuOWPvOO8At2LL=Qsj6KA@mail.gmail.com> <CAKocOON15jVO0GuPGC30AwBfQ3VvfGw=_SyG0ZskFy_uzAPMrQ@mail.gmail.com>
In-Reply-To: <CAKocOON15jVO0GuPGC30AwBfQ3VvfGw=_SyG0ZskFy_uzAPMrQ@mail.gmail.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2013 11:28 AM, Shuah Khan wrote:
> On Mon, Jan 28, 2013 at 8:44 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Mon, Jan 28, 2013 at 6:27 PM, Shuah Khan <shuahkhan@gmail.com> wrote:
>>> On Thu, Jan 24, 2013 at 2:50 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>>
>>> Your for-x86-boot git boots on AMD system I have. However, with
>>> memmap=4095$1M option, it panics very early in boot. I don't have
>>> physical access to the console and I will try to get you the panic
>>> information tomorrow.
>>
>> panic is good, but it is supposed some kind of late..
>>
> 
> It is a very early panic, however it is not specific to your git. It
> happens on 3.4, 3.8-rc4. You can disregard the early panic for your
> git.
> 

Knocking out 4095 bytes is kind of an unusual action, however, assuming
the kernel is running at 16 MiB as normal then it should just work...

memmap=4095M$1M as was shown later is another matter... there the kernel
will be living inside the reserved region, and yes, at that point it is
panic time since there is nothing the kernel can do about it.

	-hpa


