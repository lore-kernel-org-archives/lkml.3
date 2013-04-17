Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936259Ab3DQB7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 21:59:55 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:64296 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936163Ab3DQB7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 21:59:52 -0400
Date: Tue, 16 Apr 2013 18:55:49 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH V2 3/3] power: power_supply_core: Add support for
 supplied_from
Message-ID: <20130417015549.GA29100@lizard.mcd26095.sjc.wayport.net>
References: <1364852755-17425-1-git-send-email-rklein@nvidia.com>
 <1364852755-17425-4-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1364852755-17425-4-git-send-email-rklein@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 05:45:55PM -0400, Rhyland Klein wrote:
> Adding support for supplied_from char * array. This is meant to store the
> list of suppliers for a given supply, i.e. chargers for a battery. This
> list can be populated through devicetree readily as well as passed
> directly from the driver.

The subject doesn't quite reflect the content of the patch... but I fixed
it up.

> +int power_supply_populate_supplied_from(struct power_supply *psy)
> +{

This gives me:

  CHECK   drivers/power/power_supply_core.c
drivers/power/power_supply_core.c:119:5: warning: symbol 'power_supply_populate_supplied_from' was not declared. Should it be static?
drivers/power/power_supply_core.c:144:5: warning: symbol 'power_supply_find_supply_from_node' was not declared. Should it be static?
drivers/power/power_supply_core.c:173:5: warning: symbol 'power_supply_check_supplies' was not declared. Should it be static?

I fixed it up by making the functions static. Once you need the functions
outside of _core.c, feel free to export them.

Thanks,

Anton
