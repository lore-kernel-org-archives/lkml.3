Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934478Ab3GRWEd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 18:04:33 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:41300 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759449Ab3GRWEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 18:04:31 -0400
Message-ID: <51E86669.5040608@twiddle.net>
Date: Thu, 18 Jul 2013 15:04:25 -0700
From: Richard Henderson <rth@twiddle.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Michael Cree <cree@waikato.ac.nz>
CC: linux-kernel@vger.kernel.org, ink@jurassic.park.msu.ru, mattst88@gmail.com,
        linux-alpha@vger.kernel.org
Subject: Re: [RFC PATCH 00/10] Alpha support for QEMU
References: <1373996058-13399-1-git-send-email-rth@twiddle.net> <20130718011435.GA20007@stolen.phys.waikato.ac.nz> <51E7EFC6.6070003@twiddle.net> <20130718212815.GA32459@stolen.phys.waikato.ac.nz>
In-Reply-To: <20130718212815.GA32459@stolen.phys.waikato.ac.nz>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 02:28 PM, Michael Cree wrote:
> The kernel without the patch set has the "Using epoch 2000" line and
> the kernel with the patch set is missing the "Using epoch 2000" line.

Ah hah.  You appear to be missing CONFIG_RTC_DRV_ALPHA in the new kernel, so
you have no support for the RTC at all.  Please re-try.

> On the kernel without the patch set the dummy-RTC timer interrupt received
> 30876 interrupts in a 30s period which is within measurement uncertainty of
> the expected 30*1024 = 30720 interrupts.
> 
> On the kernel with the patch set the dummy-RTC timer interrupt received 14419 
> interrupts on CPU-1, 13935 interrupts on CPU-2 and 2619 interrupts on CPU-3
> over a 30s period.

Grr.  Naturally, the old kernel obfuscates which timers are being delivered
where.  So a direct comparison doesn't appear possible.  But those separated
numbers seem uncomfortably low.

I've just pushed a new branch to

  git://github.com/rth7680/linux.git axp-qemu-7

Please try that with CONFIG_ALPHA_WTINT disabled.  I'd like to eliminate that
as a source of uncertainty for your system.


r~
