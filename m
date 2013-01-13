Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab3AMOlk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 09:41:40 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:58203 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989Ab3AMOlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 09:41:37 -0500
Message-ID: <50F2C79E.5000302@linaro.org>
Date: Sun, 13 Jan 2013 15:41:34 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thomas Schlichter <thomas.schlichter@web.de>
CC: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        =?UTF-8?B?QW5kcmVhcyBNw7xs?= =?UTF-8?B?bGVy?= 
	<goo@stapelspeicher.org>,
        Julius Werner <jwerner@chromium.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuidle: fix new C-states not functional after AC disconnect
References: <2099093.cPXO6Nhn9v@netbook>
In-Reply-To: <2099093.cPXO6Nhn9v@netbook>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2013 01:34 PM, Thomas Schlichter wrote:
> Hi,
> 
> there is a long-standing regression about new C-states not working after 
> disconnecting AC power from a laptop if the cpuidle driver "acpi-idle" is 
> used. It was reported here:
> 
> [1] https://bugzilla.kernel.org/show_bug.cgi?id=42870  (March 5th 2012)
> [2] https://bugzilla.kernel.org/show_bug.cgi?id=43349  (June 7th 2012)
> [3] https://lkml.org/lkml/2012/10/16/518   (October 19th 2012)
> 
> In [1] Andreas proposed a patch that initialized the missing power_usage 
> values from within acpi_idle in the same way as cpuidle does.
> In [2] I proposed a patch to use the power values provided by ACPI to 
> initialize the power_usage variables.
> In [3] Julius proposed a patch to call the initialization function 
> set_power_states()  not only once, but always when the C-states change.
> 
> Currently, Daniel Lezcano seems to be working on an intrusive change of not 
> using the power_usage value at all for choosing a C-state:
> 
> [4] https://lkml.org/lkml/2012/12/14/155
> 
> As I could not find any of these patches in any git trees to be merged for 
> 3.8, I propose an other, least intrusive patch for the time being. It is 
> attached an initializes _all_ power_usage values in the first place.
> 
> As this is a real power consumption regression since 3.2, I really ask you to 
> apply anything and push it to stable, too!

Rafael, is possible to apply the patch [1/2] I previously sent ?

https://patchwork.kernel.org/patch/1878691/

So we get this bug fixed.

I will resend the patch [2/2] as soon as possible.

  -- Daniel


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

