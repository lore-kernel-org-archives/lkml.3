Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbaEZJ1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 05:27:16 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:56015 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaEZJ1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 05:27:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: minyard@acm.org, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, Corey Minyard <cminyard@mvista.com>
Subject: Re: [PATCH] arm: Set hardirq tracing to on when idling
Date: Mon, 26 May 2014 11:26:42 +0200
Message-ID: <4559339.apo3Fd10HK@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1401045323-7116-1-git-send-email-minyard@acm.org>
References: <1401045323-7116-1-git-send-email-minyard@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:QDXui5PdB9udEBpfwxGDNHonM+0L1lQDA7vGCl2YdcA
 MHb16WAT34/kSFDJ91lcuJtOSOE51eBR3j4ZJ/UCugcIulHP4n
 KQ+8KfHQeS6iXUmWZ1aI8bY9CYNRJseX5O2Y9mAUJY2JL3/if1
 ZW93H8Q3vX7Qc4AsaELBcxC8nHc6hotA7xtA6Ym+yF8gNLQOg4
 EE/Uf4CiSY8X37vKpNOhz3+KWr3OSEK4KljVM1E4qZp5PavRKr
 2KlBqXCpsWM2D8DGA1Yls8xBD5xPV19pBcP723xwwaVfsmdhrP
 qugMVjeWCG5jsDEdFq5j9NrtrIW/W/S73ak8PzrqKZ131hZRXb
 GB05lCy/MHbL+s3FDuA0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 25 May 2014 14:15:23 minyard@acm.org wrote:
> From: Corey Minyard <cminyard@mvista.com>
> 
> The CPU will go to idle with interrupts off, but the interrupts
> will wake up the idle.  This was causing very long irqsoff trace
> values because, basically, the whole idle time was traces with
> irqs off, even though they weren't really off.  Rework the idle
> code to turn hardirq tracing to on befor calling idle.
> 
> Signed-off-by: Corey Minyard <cminyard@mvista.com>
> ---
>  arch/arm/kernel/process.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> I'm not sure this is correct for all ARM boards, but it fixes the
> issue for the Vexpress board I have.  No more 4 second irqsoff
> times.

If this patch is correct for ARM, I wonder if it should be done
in architecture independent code instead. Do you see the same
thing on x86? If not, do you know what's different?

It seems like the right thing to do, I just don't understand
why nobody hit this before.

	Arnd
