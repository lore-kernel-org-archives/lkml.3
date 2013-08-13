Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab3HMBns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 21:43:48 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:44119 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756532Ab3HMBnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 21:43:47 -0400
Message-ID: <52098F4F.8070508@hurleysoftware.com>
Date: Mon, 12 Aug 2013 21:43:43 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        viro@zeniv.linux.org.uk
Subject: Re: pty FIONREAD returning zero breaks emacs in 3.11rc3
References: <20130809211126.GF19750@two.firstfloor.org>
In-Reply-To: <20130809211126.GF19750@two.firstfloor.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2013 05:11 PM, Andi Kleen wrote:
>
> When I run emacs over ssh terminal (no X) on 3.11-rc3 it often ignores key
> strokes.  I first thought the system was busy or so, but when
> stracing the emacs it was not blocked.

Andi,

More information might help me narrow this down since I can't
reproduce this.

Is the ssh session remote?
Can you reproduce this on a local ssh session?
What version of emacs is this? Is it the nox flavor?
What distribution/version?
What platform?

> Here's a typical sequence. select/SIGIO wakes it up, but then
> FIONREAD returns 0.
>
> I'm not fully sure when it started.

In the 3.11 cycle? or could have started back on 3.9 or earlier?

Could you try to reproduce this on linux-next?

> It does not happen all the time, but is quite frequent.
>
> ioctl(3, FIONREAD, [0])                 = 0
> pselect6(4, [3], [], NULL, {17, 952336932}, {NULL, 8}) = 1 (in [3], left
> {17, 504942810})
> --- SIGIO {si_signo=SIGIO, si_code=SI_KERNEL} ---
> rt_sigreturn()                          = 1
> ioctl(3, FIONREAD, [0])                 = 0
> ioctl(3, FIONREAD, [0])                 = 0
> pselect6(4, [3], [], NULL, {17, 504298807}, {NULL, 8}) = ?
> ERESTARTNOHAND (Interrupted by signal)
> --- SIGIO {si_signo=SIGIO, si_code=SI_KERNEL} ---
> rt_sigreturn()                          = -1 EINTR (Interrupted system
> call)
> ioctl(3, FIONREAD, [0])                 = 0
> pselect6(4, [3], [], NULL, {17, 103972440}, {NULL, 8}) = 1 (in [3], left
> {16, 864890560})
> --- SIGIO {si_signo=SIGIO, si_code=SI_KERNEL} ---
> rt_sigreturn()                          = 1

Would you please attach the full strace of emacs from this session?

Regards,
Peter Hurley
