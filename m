Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422708AbaKNV4l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 16:56:41 -0500
Received: from mga01.intel.com ([192.55.52.88]:53204 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754335AbaKNV4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 16:56:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,387,1413270000"; 
   d="scan'208";a="622594496"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@amacapital.net>
CC: Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: RE: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from
 userspace
Thread-Topic: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from
 userspace
Thread-Index: AQHP/fIL6Pup6CZwB0y4k4v+dv83WpxceVOAgAAKAgCAAAXbAIAAAfAAgAAIKwCAAAM7AP//iBaggACOCID//33YEIAAoQn1gADe14CAAAmMgIABruEAgAFGphA=
Date: Fri, 14 Nov 2014 21:56:38 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F3293BEAE@ORSMSX114.amr.corp.intel.com>
References: <CALCETrW0+5FkYn-5=WH1vGc-KnRaSj5w83Ds7R9ZTqFX3hQ+5g@mail.gmail.com>
 <20141111230926.GR31490@pd.tnic>
 <CALCETrU+Sq=rW-p2OnjLiaSLqu8rTgbC9uTcqZBJ+J8JhNxa7Q@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292A03B@ORSMSX114.amr.corp.intel.com>
 <CALCETrUU3vSLBVMpsma=8OqOZLRKUYBM19_94tkeZ7aWCEyhog@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292A157@ORSMSX114.amr.corp.intel.com>
 <CA+8MBbJy3QziFGDzOxMrweWEe_yneETuo4O8bTPZg=2y15qdkQ@mail.gmail.com>
 <20141112103011.GA16807@pd.tnic>
 <CALCETrWsWGf+WRf7gUWs5x=6Ts5KwqWpecrp-Q61jL7usTOvAQ@mail.gmail.com>
 <20141112162225.GF16807@pd.tnic> <20141113180436.GG14070@pd.tnic>
In-Reply-To: <20141113180436.GG14070@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAELuklO003913

>> Right, I can do it in the meantime and we can always experiment more
>> later. Getting rid of _TIF_MCE_NOTIFY is a good thing already.
>
> Yep, it looks pretty simple - not tested yet, it builds though.

It seems pretty solid under test so far.

Can we make it pass the address/flag to mce_notify_process() too? So
we can get rid of mce_save_info() and mce_find_info().

We'd need to wrap mce_task_work inside a bigger structure with fields
to have the address and flags - then use "container_of" inside mce_notify_process().

But I think that means we need more than one of these structures ... we may not
be done with one before a new machine check occurs. So we'd have to make an
NMI-safe allocator to grab one for use inside do_machine_check()

-Tony

General testing note - one thing I did see was that if inject 1000 errors at 0.3s interval from
my ssh'd login ... the serial console keeps streaming messages for about 40 seconds
after my test says it is all done. This might be a factor in the other tests I've been
running against the stack-switching code (especially with extra debug) ... at some
point __log_buf must get full - what happens then?
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
