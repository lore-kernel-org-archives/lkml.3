Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499Ab3BKAnJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 19:43:09 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13052 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab3BKAnI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 19:43:08 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sun, 10 Feb 2013 16:40:29 -0800
Message-ID: <51183E8D.1090607@nvidia.com>
Date: Sun, 10 Feb 2013 16:42:53 -0800
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Arto Merilainen <amerilainen@nvidia.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5,RESEND 8/8] drm: tegra: Add gr2d device
References: <1358250244-9678-1-git-send-email-tbergstrom@nvidia.com> <1358250244-9678-9-git-send-email-tbergstrom@nvidia.com> <20130204125618.GD595@avionic-0098.mockup.avionic-design.de> <511095F9.6040607@nvidia.com> <20130205095403.GF20437@avionic-0098.mockup.avionic-design.de> <5112C9C5.8080205@nvidia.com> <20130208070734.GB15429@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20130208070734.GB15429@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.02.2013 23:07, Thierry Reding wrote:
> On Wed, Feb 06, 2013 at 01:23:17PM -0800, Terje Bergström wrote:
>>>> That's the security firewall. It walks through each submit, and ensures
>>>> that each register write that writes an address, goes through the host1x
>>>> reloc mechanism. This way user space cannot ask 2D to write to arbitrary
>>>> memory locations.
>>> I see. Can this be made more generic? Perhaps adding a table of valid
>>> registers to the device and use a generic function to iterate over that
>>> instead of having to provide the same function for each client.
>> For which one does gcc generate more efficient code? I've thought a
>> switch-case statement might get compiled into something more efficient
>> than a table lookup.
>> But the rest of the code is generic - just the one function which
>> compares against known address registers is specific to 2D.
> Table lookup should be pretty fast. I wouldn't worry too much about
> performance at this stage, though. Readability is more important in my
> opinion. A lookup table is a lot more readable and reusable I think. If
> it turns out that using a function is actually faster we can always
> optimize later.

You're right about performance. We already saw quite a bad performance
hit with the current firewall, so we'll need to worry about performance
later.

I'll take a look at converting the register list to a table. Instead of
always doing a linear search of a table, a bitfield might be more
appropriate.

Terje
