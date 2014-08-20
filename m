Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbaHTTmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 15:42:10 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39456 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaHTTmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 15:42:07 -0400
Message-ID: <53F4FA23.3000409@wwwdotorg.org>
Date: Wed, 20 Aug 2014 13:42:27 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mikko Perttunen <mperttunen@nvidia.com>, rui.zhang@intel.com,
        edubezval@gmail.com, thierry.reding@gmail.com
CC: linux-pm@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 2/4] ARM: tegra: Add soctherm and thermal zones to
 Tegra124 device tree
References: <1407320706-17440-1-git-send-email-mperttunen@nvidia.com> <1407320706-17440-3-git-send-email-mperttunen@nvidia.com>
In-Reply-To: <1407320706-17440-3-git-send-email-mperttunen@nvidia.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2014 04:25 AM, Mikko Perttunen wrote:
> This adds the soctherm thermal sensing and management unit to the
> Tegra124 device tree along with the four thermal zones corresponding
> to the four thermal sensors provided by soctherm.

> diff --git a/arch/arm/boot/dts/tegra124.dtsi b/arch/arm/boot/dts/tegra124.dtsi

> +	thermal-zones {

> +	soctherm: soctherm@0,700e2000 {

>   	cpus {

The sort order of these nodes is wrong; nodes with reg should be sorted 
according to the reg value. Nodes without reg should be sorted 
alpha-numerically. That would place soctherm after sdhci@0,700b0600, and 
thermal-zones before timer.

soctherm isn't a generic node name but sounds more like an identity; 
thermal-sensor sounds like a better node name (but the node label can 
still be soctherm if you want; label names don't show up in the DT ABI).

If these are the only issues, they can probably be fixed manually when 
applying the patches, assuming a Tegra maintainer does it - I wouldn't 
want to burden anyone else with that.
