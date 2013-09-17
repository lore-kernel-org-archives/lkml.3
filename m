Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab3IQUCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 16:02:44 -0400
Received: from server19320154104.serverpool.info ([193.201.54.104]:41876 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921Ab3IQUCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 16:02:43 -0400
Message-ID: <5238B55A.5050002@hauke-m.de>
Date: Tue, 17 Sep 2013 22:02:34 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tom Gundersen <teg@jklm.no>
CC: Linux Wireless List <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION]: bcma: fix handling of big addrl
References: <CAG-2HqUUbmcEoYqV+qi8SWZXzSLd22WUO88Gry6Mc1GQJy-Ocg@mail.gmail.com>
In-Reply-To: <CAG-2HqUUbmcEoYqV+qi8SWZXzSLd22WUO88Gry6Mc1GQJy-Ocg@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2013 09:11 PM, Tom Gundersen wrote:
> The above commit causes a regression for me.
> 
> Booting with initcall_debug shows that bcma_modinit never returns:
> 
> calling  bcma_modinit+0x0/0x33 [bcma] @ 210
> bcma-pci-bridge 0000:02:00.0: enabling device (0000 -> 0002)
> bcma: bus0: Found chip with id 0xA8D8, rev 0x01 and package 0x08
> 
> Which means that (obviously) my wireless nic doesnot work (doe not
> show up in "ip addr"). Moreover, the kernel hangs during reboot and
> I'm forced to do a hard-reboot.
> 
> Reverting the offending commit on top of 3.12-rc1 fixes the problem.

Hi,

There is already a patch in wireless-testing on its way into linux tree:

https://git.kernel.org/cgit/linux/kernel/git/linville/wireless-testing.git/commit/?id=167fef2a4dce0fa9b9b847bac91cd06c191396d2

Hauke

