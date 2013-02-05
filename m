Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab3BENew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 08:34:52 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:36740 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab3BENev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 08:34:51 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 14/19] spi/atmel: remove incorrect __exit_p()
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@list.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        spi-devel-general@lists.sourceforge.net
In-Reply-To: <1359123276-15833-15-git-send-email-arnd@arndb.de>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de> <1359123276-15833-15-git-send-email-arnd@arndb.de>
Date: Tue, 05 Feb 2013 13:34:46 +0000
Message-Id: <20130205133446.4CFC33E0E27@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jan 2013 14:14:31 +0000, Arnd Bergmann <arnd@arndb.de> wrote:
> Since we no longer allow building without hotplug, the
> atmel_spi_remove function is always present and we should
> not use __exit_p() to refer to it.
> 
> Without this patch, building at91_dt_defconfig results in:
> 
> drivers/spi/spi-atmel.c:1006:12: warning: 'atmel_spi_remove' defined but not used [-Wunused-function]

Looks good, but I took a deeper look and it is incomplete. I found an
whole bunch more references. I've crafted a new patch to get rid of
them. I'll post and commit it to my tree.

g.

