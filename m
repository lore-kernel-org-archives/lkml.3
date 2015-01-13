Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbbAMTOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 14:14:38 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:40500 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbbAMTOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 14:14:34 -0500
MIME-Version: 1.0
In-Reply-To: <20150113084126.GE20387@casper.infradead.org>
References: <20150110194803.GA9033@wfg-t540p.sh.intel.com>
	<54B3259B.7080601@windriver.com>
	<20150112124216.GA26570@casper.infradead.org>
	<54B4CE3E.8020009@windriver.com>
	<20150113084126.GE20387@casper.infradead.org>
Date: Tue, 13 Jan 2015 11:14:33 -0800
Message-ID: <CAHA+R7M1ZSCF+FwKVtZUbsJ05zesNg-WVTqH13=oFe5gM--3gw@mail.gmail.com>
Subject: Re: Fwd: [rhashtable] WARNING: CPU: 0 PID: 10 at kernel/locking/mutex.c:570
 mutex_lock_nested()
From: Cong Wang <cwang@twopensource.com>
To: Thomas Graf <tgraf@suug.ch>
Cc: Ying Xue <ying.xue@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lkp@01.org, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 12:41 AM, Thomas Graf <tgraf@suug.ch> wrote:
> On 01/13/15 at 03:50pm, Ying Xue wrote:
>> On 01/12/2015 08:42 PM, Thomas Graf wrote:
>> > On 01/12/15 at 09:38am, Ying Xue wrote:
>> >> Hi Thomas,
>> >>
>> >> I am really unable to see where is wrong leading to below warning
>> >> complaints. Can you please help me check it?
>> >
>> > Not sure yet. It's not your patch that introduced the issue though.
>> > It merely exposed the affected code path.
>> >
>> > Just wondering, did you test with CONFIG_DEBUG_MUTEXES enabled?
>> >
>> >
>>
>> After I enable above option, I don't find similar complaints during my
>> testing.
>
> I can't reproduce it in my KVM box either so far. It looks like a
> mutex_lock() on an uninitialized mutex or use after free but I can't
> find such a code path so far.

Couldn't that be the delayed work is still running after rhashtable
is destroyed by its caller? I mean, cancel_delayed_work_sync()
should be called in rhashtable_destroy()?

Of course, it may be caller's responsibility to ensure that, I haven't
looked into it that much.
