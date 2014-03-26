Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716AbaCZWlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 18:41:45 -0400
Received: from moutng.kundenserver.de ([212.227.17.13]:54563 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242AbaCZWln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 18:41:43 -0400
Message-ID: <533357A2.2020402@biereigel.de>
Date: Wed, 26 Mar 2014 23:41:38 +0100
From: Stefan Biereigel <stefan@biereigel.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Kieran Clancy <clancy.kieran@gmail.com>
CC: Juan Manuel Cabo <juanmanuel.cabo@gmail.com>,
        Stefan Biereigel <security@biereigel-wb.de>,
        Lan Tianyu <lantianyu1986@gmail.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger kernel org" <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        San Zamoyski <san@plusnet.pl>, "D. Jansen" <dennis.jansen@web.de>,
        "Maurizio D'Addona" <mauritiusdadd@gmail.com>
Subject: Re: [REGRESSION 3.14-rc6] Samsung N150 lid does not "open" after
 suspend to RAM.
References: <532FE3B2.9060808@biereigel-wb.de> <CAOLK0pxh4b3uzjD4jaPssD66K8g33uqahV1SzOAJAmQmnY4XqQ@mail.gmail.com> <533014B1.4030307@biereigel-wb.de> <CAOLK0pyOV50Vqt+bX_QpH_tjL=8eWwvu+O70EvTOZ+ixWZmr3Q@mail.gmail.com> <CAGf84Q+9RcQqi=YYvF8X8EJzbtk7dJYTxScaZN4347U+POQ4AQ@mail.gmail.com> <5331E5EB.5000304@biereigel-wb.de> <5331E9E4.4050201@gmail.com> <5332099B.8090305@gmail.com> <5332AF10.90109@biereigel.de> <CAGf84QJU+RKXV4AyQ7QBTKjpdPm3AYLtWTFio+-r3j8wyoEokA@mail.gmail.com> <533330D6.3070808@biereigel.de> <CAGf84Q+HG-DspQWnza+JQE-bEki0oaJMiHQR5Y-2V97KDShf2Q@mail.gmail.com>
In-Reply-To: <CAGf84Q+HG-DspQWnza+JQE-bEki0oaJMiHQR5Y-2V97KDShf2Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:eSj0JLEB8lSbHv5q2vHdWn0/wNgQkKADq5jK5K78ESW
 ZUC1FUJcMX/RyIqchmkf7TrS7IgoMpFBq0hAelSuvblSWFojRh
 s7lpys7ZF63IS1j4xczAQVbtWoG6IPxy0uYtuLPg/oOl441SR0
 nIWhntWVHVE9/dJhZ8j8QTMQS1Nvot0LtOqpeaQaZEQlnhXsiX
 pF3P247rOOSkyxJlB3x38zeHk9BIflga05Dwnu8kqa1q1NzMe/
 arLHqeWPscoudD3texWftW2JzKQliv+P185AR70SWUiFh8rfTa
 3w8mXBldkfsoj2KYVZjLldYBd+wxVS4z73/3Kq6WrfEXJ+XyoA
 d3dhxCTxq7eZoLHEKoJo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am 26.03.2014 23:36, schrieb Kieran Clancy:
> On Thu, Mar 27, 2014 at 6:26 AM, Stefan Biereigel <stefan@biereigel.de> wrote:
>> I tested both of your patches. The processing of events works well on my
>> N150, the lid is reported open correctly after resume.
>> For the second patch (the whitelisting-approach), I had to change the
>> Product Name to "N150/N210/N220" instead of "N150P", because that is
>> what dmidecode reports for my netbook.
> That was quick - thanks for testing!
>
> For the product name match then, it matches substrings not whole
> strings, so "N150" should be sufficient (my mistake putting P on the
> end).
Alright, so that was the problem why it did not work with your original 
patch, but I missed that it did substring matching, so "N150" should be 
ok there.
>
>> So, all three approaches work equally well for me (whitelisting my
>> broken N150, blacklisting the broken Series 5/7/9, processing all the
>> stale events). I personally would prefer a solution which needs to
>> handle (best case) no custom cases, because there are always n+1 of
>> them. But, as I don't know if there may be any problems with the
>> approach that needs no special handling (processing all stale events) in
>> the future, I'm not the one to decide the correct solution.
> I won't be able to test ec_clear_process patch until tomorrow because
> I have a full day today.
>
> On my machine, _QXX events are all something like:
>
> if (AC_PLUGGED_IN) {
>      do_something();
> }
>
> So if (for example) AC_PLUGGED_IN has changed since the event was
> produced (e.g. no longer plugged in), nothing bad should happen.
> That's not necessarily a guarantee that this wouldn't introduce new
> bugs on other machines though.
>
> I think the ideal fix would be to distinguish between events which are
> "jammed" and won't be processed (like on Series 5/7/9), and events
> which will be processed normally with GPEs (N150). I am not sure how
> to do this or if it's even possible.
>
> For example, on my machine, the EC status byte (EC_SC) seems to be
> 0x29 for jammed events, which means the SCI_EVT bit is set but we
> never got/get the interrupt. On your N150, your status byte was 0x09
> which means the SCI_EVT was not set - it was not yet asking for the OS
> to attend to this.
>
> I wonder if something as simple as this would work (in acpi_ec_clear):
>
>                  if (!(acpi_ec_read_status(ec) & ACPI_EC_FLAG_SCI))
>                          break;
>                  status = acpi_ec_query_unlocked(ec, &value);
>                  if (status || !value)
>                          break;
>
> This would make it only clear events while the SCI_EVT bit is set. I
> am not sure that it would entirely remove the race condition you are
> seeing, but it might be enough to fix it.
>
> If we cant come up with a generally applicable solution, whitelisting
> is the lesser of two evils when compared with blacklisting here. A
> jammed EC won't function _at all_, while losing one or two EC events
> on boot/resume doesn't prevent future events and is easier to work
> around (though still not ideal).
You are right there, of course. Sadly, I can find nobody near me who 
owns one of the newer Samsung machines, therefore I can only contribute 
with testing on my machine. If there is anything else I could try, let 
me know.

Best wishes,
Stefan

