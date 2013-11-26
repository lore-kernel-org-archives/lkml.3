Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669Ab3KZVEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 16:04:44 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:52629 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382Ab3KZVEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 16:04:41 -0500
Date: Tue, 26 Nov 2013 23:04:34 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Chris Ball <cjb@laptop.org>, Laxman Dewangan <ldewangan@nvidia.com>,
        Mark Brown <broonie@linaro.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 3.13-rc1: MMC & fixed regulator regression
Message-ID: <20131126210433.GG24645@blackmetal.musicnaut.iki.fi>
References: <20131126180325.GF24645@blackmetal.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131126180325.GF24645@blackmetal.musicnaut.iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Nov 26, 2013 at 08:03:26PM +0200, Aaro Koskinen wrote:
> On N950 with fixed vmmc regulator, MMC probe started to fail with
> 3.13-rc1:
> 
> [    2.497406] mmc0: host doesn't support card's voltages
> [    2.502899] mmc0: error -22 whilst initialising MMC card
> 
> I bisected this to c368e5fc2a190923b786f2de3e79430ea3566a25
> (regulator: fixed: get rid of {get|list}_voltage()). With this commit
> regulator_list_voltage() does not work anymore for a fixed regulator. MMC
> code is using this in mmc_regulator_get_ocrmask().

This seems to be now fixed with f446043f1aa74c2d699db48ba4a7a075b88dc14d
(regulator: fixed: fix regulator_list_voltage() for regression). For
some reason, my searches missed this commit & reports on the list.

Sorry for the noise,

A.
