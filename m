Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbaKRSbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 13:31:38 -0500
Received: from mga14.intel.com ([192.55.52.115]:33091 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753542AbaKRSbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 13:31:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,411,1413270000"; 
   d="scan'208";a="624386726"
From: "Luck, Tony" <tony.luck@intel.com>
To: Andy Lutomirski <luto@amacapital.net>
CC: Borislav Petkov <bp@alien8.de>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: RE: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from
 userspace
Thread-Topic: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from
 userspace
Thread-Index: AQHP/fIL6Pup6CZwB0y4k4v+dv83WpxceVOAgAAKAgCAAAXbAIAAAfAAgAAIKwCAAAM7AP//iBaggACOCID//33YEIAAoQn1gADe14CAAAmMgIABruEAgAFGphCABQ+BAIAAEq4AgAAB1ACAAACVgP//kExAABLiaAAAD6th0P//ng0AgACB8wD//4wmgP//ZAXA
Date: Tue, 18 Nov 2014 18:30:55 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F3293FFBA@ORSMSX114.amr.corp.intel.com>
References: <CALCETrUU3vSLBVMpsma=8OqOZLRKUYBM19_94tkeZ7aWCEyhog@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292A157@ORSMSX114.amr.corp.intel.com>
 <CA+8MBbJy3QziFGDzOxMrweWEe_yneETuo4O8bTPZg=2y15qdkQ@mail.gmail.com>
 <20141112103011.GA16807@pd.tnic>
 <CALCETrWsWGf+WRf7gUWs5x=6Ts5KwqWpecrp-Q61jL7usTOvAQ@mail.gmail.com>
 <20141112162225.GF16807@pd.tnic> <20141113180436.GG14070@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F3293BEAE@ORSMSX114.amr.corp.intel.com>
 <20141117185030.GA25157@pd.tnic>
 <CALCETrXOPc3j8dC3rMS1jbcAofZkXDhFupbtHZgYw1JpmZasOQ@mail.gmail.com>
 <20141117200354.GB25157@pd.tnic>
 <CALCETrW75rES4=c1AYFXO0pobTZVjb6gYzpgWb0f9jAjYYduPQ@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3293F5DA@ORSMSX114.amr.corp.intel.com>
 <CALCETrU6x4yVQy57KGm-Rk==ZYNqHorytAs6WvgKNVoT+Dk9Uw@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3293F64E@ORSMSX114.amr.corp.intel.com>
 <CALCETrWPzO1vz+Rcjs78B+wWWi4eu_g__-k9iCHH1G1Mc6af+A@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3293F681@ORSMSX114.amr.corp.intel.com>
 <CALCETrXsxJ6eotRJG1tjPD8dkpAd6P2roDm+fj+Yqi36uh3WHA@mail.gmail.com>
In-Reply-To: <CALCETrXsxJ6eotRJG1tjPD8dkpAd6P2roDm+fj+Yqi36uh3WHA@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAIIVnEL025146

>> The lost cpu is *really* lost.  Warm reset doesn't fix the machine, I usually
>> have to do a full power cycle.

> How is it even possible that I did that with a few lines of asm?

Probably not your directly your fault - some cascade of errors may have occurred.

> Could this be a hardware bug?  Is there some condition that causes #MC
> delivery to wedge hard enough that even INIT/RESET stops working?  Or
> possibly some CPU got stuck in SMM -- I have no idea what warm reset
> does these days.

I'm not even sure what kind of reset the remote management i/f I used
actually applied.

> Here's the patch to improve the timeout messages, but given the degree
> of wedgedness, I can guess what it'll say:
>
> https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/commit/?h=x86/paranoid&id=e5cbd9d141bde651ecb20f0b65ad13bcef2468d0

Heh - I'd already put in some hacky printk()s to do similar. Mine aren't upstream quality, but do print the value of mce_callin/mce_executing
as appropriate.  But I got some confusing results - reporter complained that only 142 of 144 had shown up. So two threads missing,
maybe means one core went into h/w shutdown.  Need to dig further to see if the missing duo really are from the same core.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
