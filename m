Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab3ISMzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 08:55:13 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:56192 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab3ISMzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 08:55:11 -0400
MIME-Version: 1.0
In-Reply-To: <523AF22F.1010909@linux.vnet.ibm.com>
References: <CACRpkdYo24DO7ra7cgc54BUN-1SGfmbdhacOT41n2=KknyEtLw@mail.gmail.com>
	<45987104.t6r4hvPgQn@vostro.rjw.lan>
	<523AF22F.1010909@linux.vnet.ibm.com>
Date: Thu, 19 Sep 2013 14:55:10 +0200
Message-ID: <CACRpkdYxiDA25Yb+csWWgXMmJuKMMTNVbdF+2JUnsSrXQpYysQ@mail.gmail.com>
Subject: Re: Regression on cpufreq in v3.12-rc1
From: Linus Walleij <linus.walleij@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 2:46 PM, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:

>>> I don't really know if this is the right solution at all, so please
>>> help me out here... if you want that patch I can send it once
>>> I understand this properly.
>
> IIRC, recent kernels didn't return 0 or any error code when the !policy
> condition was matched. So can you check whether this problem occurs with
> 3.11 or 3.10 as well?

v3.11 works fine.

The problem is not what it returns, the system seems to survive no matter
whether it returns 0 or 17 or whatever.

The problem is that sometimes in the v3.12 kernel cycle we got a
BUG() crash instead of some random value back for calling early.

> So I think we should first identify (bisect?) and understand what caused that
> particular change and then we will be in a position to evaluate whether the
> patch you proposed would be the right fix or not.

I'll see if I can get a bisect going, the problem is that I upload the
kernel over the serial port so this isn't a very quick procedure :-(

Yours,
Linus Walleij
