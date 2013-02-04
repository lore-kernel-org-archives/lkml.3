Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab3BDIyH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 03:54:07 -0500
Received: from smtp4.epfl.ch ([128.178.224.219]:60665 "HELO smtp4.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753961Ab3BDIyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 03:54:05 -0500
Message-ID: <510F7727.1010307@epfl.ch>
Date: Mon, 04 Feb 2013 09:53:59 +0100
From: Florian Vaussard <florian.vaussard@epfl.ch>
Reply-To: florian.vaussard@epfl.ch
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>,
        Bryan Wu <cooloney@gmail.com>
CC: Richard Purdie <rpurdie@rpsys.net>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        linux-leds@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] leds: leds-pwm: Defer led_pwm_set() if PWM can
 sleep
References: <1359381659-24454-1-git-send-email-florian.vaussard@epfl.ch> <1359381659-24454-4-git-send-email-florian.vaussard@epfl.ch> <20130130081728.GC13568@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20130130081728.GC13568@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2013 09:17 AM, Thierry Reding wrote:
> On Mon, Jan 28, 2013 at 03:00:59PM +0100, Florian Vaussard wrote:
>> Call to led_pwm_set() can happen inside atomic context, like triggers.
>> If the PWM call can sleep, defer using a worker.
>>
>> Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
>> Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
>> ---
>>   drivers/leds/leds-pwm.c |   50 +++++++++++++++++++++++++++++++++++++++-------
>>   1 files changed, 42 insertions(+), 8 deletions(-)
>
> Bryan, I assume that you'll be taking this? It doesn't apply cleanly to
> my tree, probably because of Peter's recent changes that you took
> through your tree and Florian based his patches on top of that. The
> conflict resolution should be trivial, though.
>

Thank you Thierry. Indeed, this patchset was based on linux-leds due to the
dependancy with Peter's patches.

Bryan, can you take this patch?

Regards,

Florian

