Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344Ab3DTPq6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 11:46:58 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:33619 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440Ab3DTPq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 11:46:57 -0400
Message-ID: <5172B86C.5030606@suse.cz>
Date: Sat, 20 Apr 2013 17:46:52 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Resume does not work after timekeeping change
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

my machine does not wake from suspend to RAM on my box running the -next
kernel. The last thing I see is "Disabling non-boot CPUs ...". I
bisected it to this commit:

commit 7ec98e15aa049b7a2ca73485f31cf4f90c34e2dd
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Thu Feb 21 22:51:39 2013 +0000

    timekeeping: Delay update of clock->cycle_last


Reverting that one on the top of -next-20130419 makes it work again.


I also tried it inside a VM using suspend to disk. There, it behaves
like it takes a minute or so to wake up. So I tried to wait on the real
HW too, but it never resumes there.

regards,
-- 
js
suse labs
