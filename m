Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab3FJUMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 16:12:44 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57636 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab3FJUMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 16:12:42 -0400
Message-ID: <51B63336.6000007@wwwdotorg.org>
Date: Mon, 10 Jun 2013 14:12:38 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Marc Dietrich <marvin24@gmx.de>
CC: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH] mfd: tps6586x: correct device name of the regulator cell
References: <89e4451e14f324d8bd480f843fa5960b481e3188.1370894247.git.marvin24@gmx.de>
In-Reply-To: <89e4451e14f324d8bd480f843fa5960b481e3188.1370894247.git.marvin24@gmx.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2013 02:06 PM, Marc Dietrich wrote:
> Change the device name of the regulator function to the one chosed for

nit: s/chosed/chosen/

> MODULE_ALIAS. This fixes kernel module loading for the regulator function.

Not "loading" but "auto-loading" (based on a match of the MODULE_ALIAS
name).

> Also change the name of the platform driver to make everything consistent.

In this case, not really for consistency; if you didn't do that, it
simply wouldn't match the entry in tps6586x_cell[], so even with the
module loaded, the driver wouldn't get probed.
