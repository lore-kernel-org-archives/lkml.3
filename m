Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984Ab3LERKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:10:24 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:35524 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab3LERKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:10:23 -0500
Message-ID: <52A0B37A.2020900@wwwdotorg.org>
Date: Thu, 05 Dec 2013 10:10:18 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Stefan Agner <stefan@agner.ch>, thierry.reding@gmail.com, dev@lynxeye.de,
        lee.jones@linaro.org, lgirdwood@gmail.com, broonie@kernel.org
CC: kai.poggensee@avionic-design.de, sameo@linux.intel.com,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/3] regulator: tps6586x: add and use correct voltage
 table
References: <cover.1386108712.git.stefan@agner.ch> <127fe07e18665f93aa8d7c03e03164f1a049ddb6.1386108712.git.stefan@agner.ch>
In-Reply-To: <127fe07e18665f93aa8d7c03e03164f1a049ddb6.1386108712.git.stefan@agner.ch>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2013 03:18 PM, Stefan Agner wrote:
> Depending on the regulator version, the voltage table might be 
> different. Use version specific regulator tables in order to
> select correct voltage table. For the following regulator versions
> different voltage tables are now used:
> 
> * TPS658623: Use correct voltage table for SM2 * TPS658643: New
> voltage table for SM2
> 
> Both versions are in use on the Colibri T20 module. Make use of
> the correct tables by requesting the correct SM2 voltage of 1.8V.
> 
> This change is not backward compatible since an old driver is not
> able to correctly set that value. The value 1.8V is out of range
> for the old driver and will refuse to probe the device. The
> regulator starts with default settings and the driver shows
> appropriate error messages.
> 
> On Colibri T20, the old value used to work with TPS658623 since
> the driver applied a wrong voltage table too. However, the
> TPS658643 used on V1.2 devices uses yet another voltage table and
> those broke that pseudo-compatibility. The regulator driver now has
> the correct voltage table for both regulator versions and those the
> correct voltage can be used in the device tree.

Acked-by: Stephen Warren <swarren@nvidia.com>
(yes, taking this through the MFD tree with patch 1/3 makes sense)
