Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604AbaEQVVO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 17:21:14 -0400
Received: from mail-yk0-f173.google.com ([209.85.160.173]:64521 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbaEQVVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 17:21:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140517193927.GD15585@mwanda>
References: <1400344254-13007-1-git-send-email-massa.nomura@gmail.com>
	<1400344254-13007-4-git-send-email-massa.nomura@gmail.com>
	<20140517193927.GD15585@mwanda>
Date: Sat, 17 May 2014 22:14:52 +0100
Message-ID: <CAAvxhqB0ACdZy3q6zbAd-JAtxSSojPYyQq3ZKTfdyisN+e5HjA@mail.gmail.com>
Subject: Re: [PATCH 3/4] staging: dgnc: dgnc_neo: Fix conditional part of if statement
From: Masaru Nomura <massa.nomura@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Lidza Louina <lidza.louina@gmail.com>, markh@compro.net,
        devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

Thank you for your detailed explanation!

> This isn't the right way.  Write it like this:
>
>         if ((ch->ch_digi.digi_flags & CTSPACE) ||
>             (ch->ch_digi.digi_flags & RTSPACE) ||
>             (ch->ch_c_cflag & CRTSCTS) ||
>             !(ch->ch_digi.digi_flags & DIGI_FORCEDCD) ||
>             !(ch->ch_c_cflag & CLOCAL)) {
>                 ier |= UART_IER_MSI;
>         else
>                 ier &= ~UART_IER_MSI;
>
> 1) The "||" operation goes at the end of the line.
> 2) The conditions are all in a line.  The indenting is
>
> [tab][space][space][space][space](ch->ch_digi.digi_f...

Sure, I'll modify this.

> Also just fold this patch and [patch 2/4] together into one patch.  We
> don't need two patches to fix one if statement.
>
> The one thing per patch rule is a bit tricky.  It means that you have to
> say which one thing you are fixing.  Don't say "I am fixing three
> things."  Say "I am fixing one if statement".

So in this case, do you think I could fold all four patches into one?
As I just worked on the 'same' if statements and divided them into
four patches, this could be the case. (but I'm not sure yet...)

Also, should I put v[number] for the modified patches?
Say [PATCH v2] staging: ...

Thank you,
Masaru
