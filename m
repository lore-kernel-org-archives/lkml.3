Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbaLVMfP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 07:35:15 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:49657 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978AbaLVMfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 07:35:13 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: Alex Hung <alex.hung@canonical.com>
Cc: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Darren Hart <dvhart@infradead.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Dell Airplane Mode Switch driver
Date: Mon, 22 Dec 2014 13:35:09 +0100
Message-ID: <1681751.L1yPd56VCO@xps13>
User-Agent: KMail/4.14.2 (Linux/3.18.0+; KDE/4.14.2; x86_64; ; )
In-Reply-To: <CAJ=jqubEggcXs0kvegGUpVh8PNh-GmdcnXkXUjqv4fHD-zXdEA@mail.gmail.com>
References: <1416755361-17357-1-git-send-email-pali.rohar@gmail.com> <2697957.miSb4Rm7HK@xps13> <CAJ=jqubEggcXs0kvegGUpVh8PNh-GmdcnXkXUjqv4fHD-zXdEA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 December 2014 15:27:57 Alex Hung wrote:
> = Testing =
> 
> I tested six Dell systems for two sets of patches for dell radio
> button - two system with radio slider and four with radio hotkey.
> There are also two systems with working ARBT method.
> 
> == Basic Information ==
> Based OS: Ubuntu 14.10 (kernel 3.16 [1]) and kernel 3.18 [2]
> 
> Patches:
> 1. dell-wireless v3 = original v2 + Gabriele's suggestion [3]
> 2. dell-rbtn [4]
> 
> Method:
> 1. run "rfkill list" and press hotkey / toggle slider during runtime
> 2. run "rfkill list" and toggle slider during S3
> 
> == Results ==
> 
> I summarized the tests in Google sheet as below. Please advise if
> anyone has problem reading it.
> 
> https://docs.google.com/spreadsheets/d/1voffS6dNglwAExSGh3UmG__UAO2qfZ829CkJLPo06aI/edit?usp=sharing
> 
> PS. The document will stay as long as possible for future references.
> 
> == Summary ==
> 
> 1. I did not observed a duplicated event. However, keycode 240
> (unknown) is generated on many UUT. It is not issued by dell-laptop or
> del-wmi. I am suspecting it is the other event Pali observes but it
> can be the result of different distro.
> 
> 2. Some system issues scancode "0xe0 0x73 0xe0 0xf3". It can also be
> used toggle wireless state but this can also be distro-dependent. This
> scancode does nothing on Ubuntu 14.10.
> 
> 2. There are two systems with working ARBT (XPS 13 9333 and Inspiron
> 7447). Calling ARBT(1) changes BIOS behaviours, and this matches to
> Dell's document. We should include it in the patch for maximum
> capability.
> 
> 
> [1] dell-wireless is only tested 3.16.
> [2] dell-rbtn is tested on 3.16 and 3.18, but no differences are observed.
> [3] http://people.canonical.com/~alexhung/dell-wireless/
> [4] http://people.canonical.com/~alexhung/dell-rbtn/

Thanks for the detailed report.

Note that the results might be different for some laptops with 3.19. See
8f8d75ebf0 ("dell-wmi: Don't report keypresses for radio state changes")
for more details. Basically "238 (rfkill wlan)" should never be reported
with 3.19. Looking at the results of your tests I can see that key 238
is never necessary, confirming that not reporting it is the right thing
to do.

Gabriele
