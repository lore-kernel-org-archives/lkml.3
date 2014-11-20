Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992AbaKTOgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 09:36:37 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:38829 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbaKTOgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 09:36:36 -0500
Date: Thu, 20 Nov 2014 15:36:32 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Don Zickus <dzickus@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141120143626.GA2542@lerouge>
References: <20141118020959.GA2091@redhat.com>
 <CA+55aFy65SmGXFeosNqvrgx+P6JQLrzpEYuwXdyeWtZwZsKxZg@mail.gmail.com>
 <20141118023930.GA2871@redhat.com>
 <CA+55aFyOTpVQiku0xn=UHnXdYweKHZ5AsEUN9wUvOqH9XX4ENg@mail.gmail.com>
 <20141118145234.GA7487@redhat.com>
 <alpine.DEB.2.11.1411181914020.3909@nanos>
 <20141118215540.GD35311@redhat.com>
 <20141119021902.GA14216@redhat.com>
 <CA+55aFw13opSu6ETXgVo1tjrP+1PLkbsiKewEqRgdBKyBKALWA@mail.gmail.com>
 <20141119051524.GA18547@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141119051524.GA18547@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 12:15:24AM -0500, Dave Jones wrote:
> On Tue, Nov 18, 2014 at 08:40:55PM -0800, Linus Torvalds wrote:
> 
>  > Hmm, if we are getting soft-lockups here, maybe it suggest too much exit-work.
>  > 
>  > Some TIF_NOHZ loop, perhaps? You have nohz on, don't you?
>  > 
>  > That makes me wonder: does the problem go away if you disable NOHZ?
> 
> Does nohz=off do enough ? I couldn't convince myself after looking at
> dmesg, and still seeing dynticks stuff in there.
> 
> I'll do a rebuild with all the CONFIG_NO_HZ stuff off, though it also changes
> some other config stuff wrt timers.

You also need to disable context tracking. So you need to deactive also
CONFIG_RCU_USER_QS and CONFIG_CONTEXT_TRACKING_FORCE and eventually make sure
nothing else is turning on CONFIG_CONTEXT_TRACKING.

You can keep CONFIG_NO_HZ_IDLE though, just not CONFIG_NO_HZ_FULL.
