Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758535Ab3BGNhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 08:37:05 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:57804 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab3BGNhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 08:37:02 -0500
MIME-Version: 1.0
In-Reply-To: <20130207015259.GA760@wolff.to>
References: <20130201201332.GA2965@wolff.to>
	<20130207015259.GA760@wolff.to>
Date: Thu, 7 Feb 2013 08:37:01 -0500
Message-ID: <CA+5PVA5H0merTWq=wAe38m2WPg1_A06saHcST+VUfgkk9OuSOA@mail.gmail.com>
Subject: Re: Problems with late 3.8-rc5 and 3.8-rc6 on i686
From: Josh Boyer <jwboyer@gmail.com>
To: Bruno Wolff III <bruno@wolff.to>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 8:52 PM, Bruno Wolff III <bruno@wolff.to> wrote:
> On Fri, Feb 01, 2013 at 14:13:32 -0600,
>   Bruno Wolff III <bruno@wolff.to> wrote:
>>
>> I have been testing 3.8 kernels on Fedora. The last good kernel was
>> 3.8.0-0.rc5.git1.1.fc19.i686.PAE. I tested 3.8.0-0.rc5.git2.1.fc19.i686.PAE,
>> 3.8.0-0.rc5.git3.1.fc19.i686 and 3.8.0-0.rc6.git0.1.fc19.i686.PAE and found
>> these all had two odd effects.
>
>
> This turned out to be due Fedora changing some config options to turn off
> namespaces for i686 when it was thought by some people that they had been
> off previously. (And so this wasn't thought to be a change.) This broke the
> private network feature of systemd, used by rtkit-daemon.

Yeah, the Kconfig entry for NAMESPACES is... misleading.  It seems it
should depend on CONFIG_EXPERT, but if you have one of the _NS options
set in the config it gets flipped on regardless.  It's either that or
the weird "default !EXPERT" causing it to be enabled even when the
CONFIG_EXPERT option is not set.

Anyway, still seems to me that systemd/rtkit-daemon should be _checking_
to see if that feature is present instead of assuming it is and failing
in weird ways when it isn't.

josh
