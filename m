Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab3F0U0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 16:26:13 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:47068 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab3F0U0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 16:26:12 -0400
Date: Thu, 27 Jun 2013 23:26:08 +0300
From: Siarhei Siamashka <siarhei.siamashka@gmail.com>
To: linux-sunxi@googlegroups.com
Cc: maxime.ripard@free-electrons.com, Hans de Goede <hdegoede@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com
Subject: Re: [linux-sunxi] [PATCH 0/8] clocksource: sunxi: Timer fixes and
 cleanup
Message-ID: <20130627232608.1174558b@i7>
In-Reply-To: <20130627165436.GB4319@lukather>
References: <1372281421-2099-1-git-send-email-maxime.ripard@free-electrons.com>
	<51CC0566.8010302@redhat.com>
	<20130627094307.GC8437@lukather>
	<51CC0BC3.5090309@redhat.com>
	<20130627165436.GB4319@lukather>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jun 2013 18:54:36 +0200
Maxime Ripard <maxime.ripard@free-electrons.com> wrote:

> On Thu, Jun 27, 2013 at 11:54:11AM +0200, Hans de Goede wrote:
> > I notice that unlike the sunxi-3.4 code you don't do any locking,
> > so how do you stop 2 clocksource calls from racing (and thus
> > getting a possible wrong value because of things not
> > being properly latched) ?
> 
> Hmm, right. I'll add a spinlock.

I think the best would be to ask the Allwinner people (it's good to
have them in CC, right?) whether anything wrong can happen because of
"things not being properly latched".

The A10 manual from http://free-electrons.com/~maxime/pub/datasheet/
does not seem to contain any details about what bad things may happen
if we try to read CNT64_LO_REG while latching is still in progress and
CNT64_RL_EN bit in CNT64_CTRL_REG has not changed to zero yet.
I can imagine the following possible scenarios:
  1. We read either the old stale CNT64_LO_REG value or the new
     correct value.
  2. We read either the old stale CNT64_LO_REG value or the new
     correct value, or some random garbage.
  3. The processor may deadlock, eat your dog, or do some other
     nasty thing.

In the case of 1, we probably can get away without using any spinlocks?

-- 
Best regards,
Siarhei Siamashka
