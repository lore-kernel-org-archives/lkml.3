Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbaAMRDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:03:47 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:54630 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533AbaAMRDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 12:03:43 -0500
Message-ID: <52D41C6C.9060500@wwwdotorg.org>
Date: Mon, 13 Jan 2014 10:03:40 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        Andrew Bresticker <abrestic@chromium.org>
CC: Linus Walleij <linus.walleij@linaro.org>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl: tegra1x4: initialize at arch_initcall time
References: <1389401416-29892-1-git-send-email-abrestic@chromium.org> <20140113090223.GA16296@ulmo.nvidia.com>
In-Reply-To: <20140113090223.GA16296@ulmo.nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2014 02:02 AM, Thierry Reding wrote:
> On Fri, Jan 10, 2014 at 04:50:16PM -0800, Andrew Bresticker wrote:
>> Many devices rely on pinctrl/pinmux settings being applied
>> before probing and some of these may probe before device_initcall
>> time (e.g. i2c at subsys_initcall).  Move Tegra1x4 pinctrl driver
>> registration to arch_initcall time so that proper pin settings
>> can be applied earlier.
>>
>> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
>> ---
>>  drivers/pinctrl/pinctrl-tegra114.c | 13 ++++++++++++-
>>  drivers/pinctrl/pinctrl-tegra124.c | 13 ++++++++++++-
>>  2 files changed, 24 insertions(+), 2 deletions(-)
> 
> I wonder if a better approach would be to add pin control and pin mux
> settings for devices that explicitly need them to the device tree nodes
> of the devices themselves.

We can't do that; the entire pinctrl state needs to be programmed at
once to avoid the conflict of multiple pins/groups being muxed to the
same function. However, we can make this work with empty states I believe.
