Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760878Ab3GaWOF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 18:14:05 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58193 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757714Ab3GaWOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 18:14:02 -0400
Message-ID: <51F98C27.40904@wwwdotorg.org>
Date: Wed, 31 Jul 2013 16:13:59 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
CC: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: DTS: tegra: Add USB entries for Tegra30
References: <1375292543-7896-1-git-send-email-ttynkkynen@nvidia.com> <1375292543-7896-2-git-send-email-ttynkkynen@nvidia.com>
In-Reply-To: <1375292543-7896-2-git-send-email-ttynkkynen@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2013 11:42 AM, Tuomas Tynkkynen wrote:
> Add device tree entries for the 3 USB controllers and PHYs and
> enable the third controller on Cardhu and Beaver boards.
> 
> Fix VBUS regulator entries on Beaver. The GPIO pins were wrong.

That much is correct.

> Also, a third GPIO is required to power the pullup resistors that drive
> the VBUS voltage switches, so add an regulator entry for that.

That is not true. GMI_AD13 / PH5 / 61 is a signal that pulls up all of
USB1 VBUS, USB3 VBUS, and GMI_AD15, which as far as I can tell is
entirely unrelated to USB in any way.

This part of the change should be removed. I know you mentioned that
downstream does this, but that means very little; there are many
mistakes there.

Aside from that, this patch looks fine.
