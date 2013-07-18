Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758966Ab3GRNiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 09:38:22 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:58072 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140Ab3GRNiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 09:38:19 -0400
Message-ID: <51E7EFC6.6070003@twiddle.net>
Date: Thu, 18 Jul 2013 06:38:14 -0700
From: Richard Henderson <rth@twiddle.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Michael Cree <cree@waikato.ac.nz>
CC: linux-kernel@vger.kernel.org, ink@jurassic.park.msu.ru, mattst88@gmail.com,
        linux-alpha@vger.kernel.org
Subject: Re: [RFC PATCH 00/10] Alpha support for QEMU
References: <1373996058-13399-1-git-send-email-rth@twiddle.net> <20130718011435.GA20007@stolen.phys.waikato.ac.nz>
In-Reply-To: <20130718011435.GA20007@stolen.phys.waikato.ac.nz>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2013 06:14 PM, Michael Cree wrote:
> Tested the patch series applied against 3.10.1 on a 3-CPU ES45.  System came
> up fine but I noticed date was wrong and had been reset back to the start
> of the epoch (Jan 1 1970).  Appears it is not reading hardware clock
> correctly on boot.

Please scan the dmesg for the "Using epoch 2000 for rtc year 13" line,
and compare vs a similar message on the previous kernel.

> I manually set the clock to the correct time but noticed it is running slow,
> indeed in a period of 60s the system clock incremented by 21s (+/-1s) so
> would appear clock is running slow by a factor given by the number of CPUs.

That's curious.  I wonder if somehow I botched the smp changes, and I'm
not getting the timer interrupt either (1) enabled or (2) registered on
the secondary cpus...

Perhaps /proc/interrupts will confirm or deny this?


r~

