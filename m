Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461AbaC1HRW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 03:17:22 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:57345 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbaC1HRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 03:17:21 -0400
Date: Fri, 28 Mar 2014 08:17:16 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Feng Tang <feng.tang@intel.com>
Cc: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v2] x86: hpet: Don't default CONFIG_HPET_TIMER to be y
 for X86_64
Message-ID: <20140328071716.GC30107@gmail.com>
References: <1395975316-4795-1-git-send-email-feng.tang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395975316-4795-1-git-send-email-feng.tang@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Feng Tang <feng.tang@intel.com> wrote:

> On many new phone/tablet platforms like Baytrail/Merrifield etc, the 
> HPET are either defeatured or has some problem to be used as a 
> reliable timer. As these platforms also have X86_64, we should not 
> make HPET_TIMER default y for all X86_64.

NAK!

If the HPET is unreliable on a specific platform then any of the 
following solutions would address the problem (in order of 
preference):

 - the hardware should not expose it. Why waste silicon on something 
   that does not work?

 - or the firmware should not expose it. Why expose something that 
   does not work?

 - or the kernel should have a quirk to reliably disable it. Why 
   should we crash or misbehave if a driver is built into the
   kernel?

tweaking a default is _NOT_ a solution for an unreliable hpet.

Thanks,

	Ingo
