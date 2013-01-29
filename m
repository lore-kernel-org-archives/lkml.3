Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab3A2IRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 03:17:41 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:40603 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754446Ab3A2IRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 03:17:38 -0500
Message-ID: <51078580.2000808@ti.com>
Date: Tue, 29 Jan 2013 09:17:04 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130115 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH 1/4] pwm_backlight: Fix PWM levels support in non DT case
References: <1358861996-27194-1-git-send-email-peter.ujfalusi@ti.com> <1358861996-27194-2-git-send-email-peter.ujfalusi@ti.com> <20130128210123.GA24673@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20130128210123.GA24673@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2013 10:01 PM, Thierry Reding wrote:
> On Tue, Jan 22, 2013 at 02:39:53PM +0100, Peter Ujfalusi wrote:
>> It is expected that board files would have:
>> static unsigned int bl_levels[] = { 0, 50, 100, 150, 200, 250, };
>>
>> static struct platform_pwm_backlight_data bl_data = {
>> 	.levels = bl_levels,
>> 	.max_brightness = ARRAY_SIZE(bl_levels),
>> 	.dft_brightness = 4,
>> 	.pwm_period_ns = 7812500,
>> };
>>
>> In this case the max_brightness would be out of range in the levels array.
>> Decrement the received max_brightness in every case (DT or non DT) when the
>> levels has been provided.
> 
> What's wrong with specifying .max_brightness = ARRAY_SIZE(bl_levels) - 1
> instead?

There is nothing wrong with that either but IMHO it is more natural for board
files to use just ARRAY_SIZE(bl_levels). In this way the handling of
data->max_brightness among non DT and DT booted kernel is more uniform in the
driver itself.
Right now all board files are using only the .max_brightness to specify the
maximum value, I could not find any users of .levels in the kernel.

-- 
Péter
