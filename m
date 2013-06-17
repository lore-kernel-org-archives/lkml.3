Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab3FQQ7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 12:59:49 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:35473 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab3FQQ7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 12:59:48 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <EABCC4A72A203F4BA2E04297CF0282C427D1E1F8@hnombx01.corp.atmel.com>
References: <1371246138-22207-1-git-send-email-nicolas.ferre@atmel.com>
	<20130615023702.GA8635@quad.lixom.net>
	<EABCC4A72A203F4BA2E04297CF0282C427D1E1F8@hnombx01.corp.atmel.com>
Date: Mon, 17 Jun 2013 09:59:47 -0700
Message-ID: <CAOesGMixxxUg-9h9KFNxAvp8DSNJN-SEQxXnU51BQJ9cAxSGBw@mail.gmail.com>
Subject: Re: RE : [GIT PULL] at91: soc updates for 3.11 #1
From: Olof Johansson <olof@lixom.net>
To: "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "Yang, Wenyou" <Wenyou.Yang@atmel.com>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "Desroches, Ludovic" <Ludovic.Desroches@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 2:20 AM, Ferre, Nicolas <Nicolas.FERRE@atmel.com> wrote:
> From: Olof Johansson [olof@lixom.net]
>>Hi,
>>
>>On Fri, Jun 14, 2013 at 11:42:18PM +0200, Nicolas Ferre wrote:
>>> Arnd, Olof,
>>>
>>> A little AT91 pull-request for patches that are more targeted to SoC/boards
>>> modifications. It is prepared on top of the arm-soc/at91/cleanup branch.
>>>
>>> Thanks, best regards,
>>>
>>> The following changes since commit b3f442b0eedbc20b5ce3f4a96530588d14901199:
>>>
>>>   ARM: at91: udpate defconfigs (2013-05-17 15:05:08 +0200)
>>>
>>> are available in the git repository at:
>>>
>>>   git://github.com/at91linux/linux-at91.git tags/at91-soc
>>>
>>> for you to fetch changes up to 7e75545ea7fb972c3da759f92c3d0be84d1cee72:
>>>
>>>   ARM: at91: drop rm9200dk board support (2013-06-14 23:34:11 +0200)
>>>
>>> ----------------------------------------------------------------
>>> Two non critical fixes that can go in 3.11.
>>> An old board removed.
>>>
>>> ----------------------------------------------------------------
>>> Alexandre Belloni (1):
>>>       ARM: at91: Fix link breakage when !CONFIG_PHYLIB
>>
>>Fix
>>
>>> Jean-Christophe PLAGNIOL-VILLARD (1):
>>>       ARM: at91: drop rm9200dk board support
>>
>>Cleanup
>>
>>> Wenyou Yang (1):
>>>       ARM: at91: Change the internal SRAM memory type MT_MEMORY_NONCACHED
>>
>>Fix
>>
>>...assuming, of course, that none of the fixes are for errors introduced in
>>some branch we already pulled, since then they should go on top of that branch.
>
> I do agree with you but:
> 1/ the fixes are non-critical ones, so I do not see the need for another branch

We're happy to take branches with fixes that are not needed for
current release and queue them for the next one. We tend to merge
those into next/fixes-non-critical.

> 2/ I didn't feel like touching the "cleanup" branch because we want to base all our 3.11 material on top of it, without adding new patches on top.

Adding new patches on top of a branch that is a base for something
else is just fine, and is the way you're supposed to do things. You
don't have to rebase the dependent branches just because they're not
based on the tip of the cleanup tree any more. I.e. just send another
pull request for "cleanups2" or whatever, that's based on the old
cleanups branch/tag. After that, cleanups3 would be based on
cleanups2. Etc. Some platforms do this a lot.

Of course, that assumes that the additional cleanups don't conflict
heavy with the later dependent branches like I already said. I don't
think that was the case this time?


-Olof
