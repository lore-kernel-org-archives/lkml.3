Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbaFWPgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 11:36:13 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:54043 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbaFWPgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 11:36:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, wim@iguana.be,
        dbaryshkov@gmail.com, dwmw2@infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 1/6] wdt: sunxi: Move restart code to the watchdog driver
Date: Mon, 23 Jun 2014 17:35 +0200
Message-ID: <4880375.uMKpQASVMt@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53A844C2.7070804@roeck-us.net>
References: <1399430664-29091-1-git-send-email-maxime.ripard@free-electrons.com> <19870078.UBj78UMBrO@wuerfel> <53A844C2.7070804@roeck-us.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:vBRPsknEdT7RtoGXVqgFBy/WQjGyU6TdofcaUYxFfnQ
 CTdmnNaJ7wMYpnalRPJdQktyVYgVwziXU7BgwpWgT7Rqfj38TM
 ncqVH1PRyYanMVThz4Bm6xezxv4txh2Ni3ACtUsWN1w7NQP849
 /xmLqF+XV1DxXiTQApLT/eZmNKopD50X4++LxYroAiDXE/UpX9
 Ze+pdtD+08f4rITbuuIItlkFPbJ2blFL8WMY8kZlZzWdPdsjXk
 ekNE5aVfphkvkqBGroXm61aB6pVuvQtuTOC03B/tCILlnM8Jmh
 34pEn3vaq2ZG0553q0lJScUAGSZrMhAIUdtNc1bJRJg5+VoUe4
 zNtnVBiAhN8i9D7ghPps=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 June 2014 08:16:18 Guenter Roeck wrote:
> > Moved to where?
> >
> > I certainly don't want it in the platform directories, and for arm64 we
> > intentionally don't have a place to put this stuff.
> >
> 
> I have no idea, but setting the arm reset function pointer from a watchdog
> driver doesn't seem like a good idea either. The arm code _does_ provide
> and expect platform code to set the reset function, so having it in the arm
> code would at least make more sense than expecting some unrelated driver
> code to set it - especially since it is inherently racy [1].

I don't think the race is inherent. We could solve the multiple registration
problem and the unload problem using a notifier chain. If there are actually
cases where we expect to see multiple reboot functions to be present in the
system, we could go one step further and have a priority associated with
it, so we try the best function first and fall back to soft_restart()
if everything else fails.

	Arnd
