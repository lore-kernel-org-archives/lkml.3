Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509Ab3CLTpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 15:45:21 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35540 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082Ab3CLTpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 15:45:18 -0400
Message-ID: <513F85CA.2000800@wwwdotorg.org>
Date: Tue, 12 Mar 2013 13:45:14 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Danny Huang <dahuang@nvidia.com>, linux@arm.linux.org.uk, hdoyu@nvidia.com,
        olof@lixom.net, gregkh@linuxfoundation.org, josephl@nvidia.com,
        pdeschrijver@nvidia.com, pgaikwad@nvidia.com,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: tegra: expose chip ID and revision
References: <1363089667-15737-1-git-send-email-dahuang@nvidia.com> <201303121259.18710.arnd@arndb.de> <513F6E2C.1000101@wwwdotorg.org> <201303121910.55141.arnd@arndb.de>
In-Reply-To: <201303121910.55141.arnd@arndb.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2013 01:10 PM, Arnd Bergmann wrote:
> On Tuesday 12 March 2013, Stephen Warren wrote:
>>> You are dropping the soc_dev on the floor here by just returning.
>>>
>>> The idea of the soc node is to have all on-soc components be children
>>> of that node, so you should instead pass it into of_platform_populate
>>> as the parent device.
>>
>> Tegra DTs don't have a separate node for on-soc vs. off-soc components.
>> Wouldn't passing soc_dev into of_platform_populate() make everything a
>> child of this soc_dev; is that what we want?
> 
> Yes, we had long discussions about this when the soc infrastructure was
> merged. Right now, everything is a child of /sys/devices/platform/,
> basically saying that all devices are random stuff that cannot be
> probed. Moving it to /sys/devices/soc0 would not make the hierarchy
> any deeper but show much clearer which devices are part of the
> soc, and which ones are added as anonymous platform devices by code
> that does not use DT based probing. Ideally the second category is
> empty.

OK, that makes sense.

Danny, in that case, the initialization of this SoC object should
definitely happen inside tegra_init_fuse(), which is called from
tegra_init_early(), so that mach-tegra/tegra.c:tegra_dt_init() can call
a function in fuse.c to retrieve that SoC object in order to pass it
into of_platform_populate().
