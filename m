Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395AbaKFSC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 13:02:56 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:50438 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaKFSCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 13:02:55 -0500
MIME-Version: 1.0
In-Reply-To: <20141106170818.GA30177@roeck-us.net>
References: <1415292213-28652-1-git-send-email-linux@roeck-us.net>
	<20141106170818.GA30177@roeck-us.net>
Date: Thu, 6 Nov 2014 10:02:54 -0800
X-Google-Sender-Auth: jv5mcFQ9hVvpB5nsysjfuik_Zjc
Message-ID: <CA+55aFxMu_MTfXd-EFG=QJ6aCWpb+OX5tyM-XWZC=WHJ=pFiTA@mail.gmail.com>
Subject: Re: [PATCH v5 00/48] kernel: Add support for power-off handler call chain
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Alexander Graf <agraf@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Heiko Stuebner <heiko@sntech.de>, Lee Jones <lee.jones@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Romain Perier <romain.perier@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 6, 2014 at 9:08 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> Merge plan is to send the entire series directly to Linus during the next commit
>> window, except for the last patch. The last patch would then be part of another
>> pull request after -rc1, which would include any changes necessary due to newly
>> merged power-off handling code.
>
> I should have added that I plan to have the series (except for the last patch)
> added to -next shortly.
>
> Linus,
>
> are you ok with this plan ?

Do people actually agree that the code makes sense at all?

Because quite frankly, every time somebody adds this kind of "register
callback" stuff, the end result tends to end up being an unmitigated
disaster. People care about ordering etc, and there seems to be no
sane support for that. Then people do random ugly hacks for their
insane platforms. You already did that by having the "priority" thing,
but that just makes me think that people will pick random priorities.
TYou seem to even *encourage* that random behavior by spreading out
the "named" priorities, so that people can randomly say "I'm one
higher than LOW".

What kind of games are the actual new users already doing wrt this? I
have a bad feeling about it all.

                        Linus
