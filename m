Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbaGaCxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 22:53:17 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:33165 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270AbaGaCxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 22:53:16 -0400
MIME-Version: 1.0
In-Reply-To: <20140731024014.GA10184@localhost>
References: <20140730035541.GD16537@localhost>
	<20140730111521.GB759@infradead.org>
	<alpine.DEB.2.02.1407301550140.26018@chino.kir.corp.google.com>
	<CAADnVQ+OwgG-RJQ7QwfW2qrvpV9XYySckTbNmcacW7K0KxQqvA@mail.gmail.com>
	<20140731024014.GA10184@localhost>
Date: Wed, 30 Jul 2014 19:53:15 -0700
Message-ID: <CAADnVQL+O0ZFmF99+Ba4Ua2bwLnaO2KDJM1o86aUvG24xS08gg@mail.gmail.com>
Subject: Re: [delayed_fput] BUG: unable to handle kernel paging request at ffff8800122a0ad0
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: David Rientjes <rientjes@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        linux-fsdevel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 7:40 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> On Wed, Jul 30, 2014 at 04:00:58PM -0700, Alexei Starovoitov wrote:
>> On Wed, Jul 30, 2014 at 3:51 PM, David Rientjes <rientjes@google.com> wrote:
>> > On Wed, 30 Jul 2014, Christoph Hellwig wrote:
>> >
>> >> On Wed, Jul 30, 2014 at 11:55:41AM +0800, Fengguang Wu wrote:
>> >> > Greetings,
>> >> >
>> >> > 0day kernel testing robot got the below dmesg and the first bad commit is
>> >>
>> >> How does this manage to trip over a 2 year old commit now?
>>
>> may be because all kernels are built with gcc 4.8.2 ?
>> Fengguang, did you recently switch to new compiler?
>> I think all older builds were with 4.6.3
>
> Alexei, I've been using gcc 4.8.2 for 4 months.
>
> Maybe it's because I test new randconfigs every day. And the problem
> may only show up with very specific kernel config?

It seems a lot of odd crashes suddenly showed up and I'm guessing it
may be related to compiler...
See commit 2062afb4f8 ("Fix gcc-4.9.0 miscompilation of load_balance()
 in scheduler")
it's a nasty gcc bug that affects 4.9 and 4.8.
I think it makes sense to apply that workaround before debugging much with 4.8
just to eliminate the possibility of miscompiled code.
