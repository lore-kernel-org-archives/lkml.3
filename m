Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab3F1INT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 04:13:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971Ab3F1IMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 04:12:45 -0400
Message-ID: <51CD46B5.6090101@redhat.com>
Date: Fri, 28 Jun 2013 10:17:57 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Siarhei Siamashka <siarhei.siamashka@gmail.com>
CC: linux-sunxi@googlegroups.com, maxime.ripard@free-electrons.com,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com
Subject: Re: [linux-sunxi] [PATCH 0/8] clocksource: sunxi: Timer fixes and
 cleanup
References: <1372281421-2099-1-git-send-email-maxime.ripard@free-electrons.com> <51CC0566.8010302@redhat.com> <20130627094307.GC8437@lukather> <51CC0BC3.5090309@redhat.com> <20130627165436.GB4319@lukather> <20130627232608.1174558b@i7>
In-Reply-To: <20130627232608.1174558b@i7>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 06/27/2013 10:26 PM, Siarhei Siamashka wrote:
> On Thu, 27 Jun 2013 18:54:36 +0200
> Maxime Ripard <maxime.ripard@free-electrons.com> wrote:
>
>> On Thu, Jun 27, 2013 at 11:54:11AM +0200, Hans de Goede wrote:
>>> I notice that unlike the sunxi-3.4 code you don't do any locking,
>>> so how do you stop 2 clocksource calls from racing (and thus
>>> getting a possible wrong value because of things not
>>> being properly latched) ?
>>
>> Hmm, right. I'll add a spinlock.
>
> I think the best would be to ask the Allwinner people (it's good to
> have them in CC, right?) whether anything wrong can happen because of
> "things not being properly latched".
>
> The A10 manual from http://free-electrons.com/~maxime/pub/datasheet/
> does not seem to contain any details about what bad things may happen
> if we try to read CNT64_LO_REG while latching is still in progress and
> CNT64_RL_EN bit in CNT64_CTRL_REG has not changed to zero yet.
> I can imagine the following possible scenarios:
>    1. We read either the old stale CNT64_LO_REG value or the new
>       correct value.
>    2. We read either the old stale CNT64_LO_REG value or the new
>       correct value, or some random garbage.
>    3. The processor may deadlock, eat your dog, or do some other
>       nasty thing.
>
> In the case of 1, we probably can get away without using any spinlocks?

No, because if ie CNT64_LO_REG old is 0xffffffff and CNT64_LO_REG new is
say 0x00000001, and we do get the new CNT64_HI_REG things will break.

Regards,

Hans
