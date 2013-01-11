Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab3AKJLJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 04:11:09 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:46386 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580Ab3AKJLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 04:11:07 -0500
Message-ID: <50EFD728.8090204@ti.com>
Date: Fri, 11 Jan 2013 10:11:04 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH resend 2/2] Input: twl6040-vibra: Code cleanup in probe
 with devm_* conversion
References: <1357824965-30614-1-git-send-email-peter.ujfalusi@ti.com> <1357824965-30614-3-git-send-email-peter.ujfalusi@ti.com> <20130110175421.GC2797@core.coreip.homeip.net>
In-Reply-To: <20130110175421.GC2797@core.coreip.homeip.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On 01/10/2013 06:54 PM, Dmitry Torokhov wrote:
> Hi Peter,
> 
> On Thu, Jan 10, 2013 at 02:36:05PM +0100, Peter Ujfalusi wrote:
>> Convert the probe to use devm_*. At the same time reorder the calls
>> so we will register the input device as the last step when the driver
>> is loaded.
> 
> If you are doing this please also use devm_input_allocate_device() and
> devm_regulator_bulk_get().

Now I remember: I can not switch to devm_regulator_bulk_get() unfortunately
since when we boot with DT the code needs to reach up for the parent's dev to
get the needed regulator. If I use devm_regulator_bulk_get() the resource will
be bind to the parent dev and not to the vibra driver.

> I also think it is high time to get rid of
> dedicated work queue - cwq hasn't actually given you a separate therad
> for a while now and if you get rid of workqueue you can get ridof entire
> twl6040_vibra_remove().

I agree with the rest. I'll move both twl4030/6040 vibra to use
devm_input_allocate_device() and also I will move them to use system wide
workqueue.

I'm going to resend the series soon with the suggested changes.

Thanks,
Péter
