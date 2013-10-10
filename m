Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab3JJMk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 08:40:26 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:2554 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab3JJMkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 08:40:25 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 10 Oct 2013 05:36:12 -0700
Message-ID: <5256A626.4060107@nvidia.com>
Date: Thu, 10 Oct 2013 18:35:42 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@linaro.org>
CC: Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Issue seen with FET re-enable during auto discharge time
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,
In one of our system, we are using TPS65090 which has FET switches for  
power control. This has also the auto discharger resistance for turning 
-off.

We observed that when we disable the FET and re-enable before it 
completely off (during power discharge time), it does not get enabled. 
It enable only if wait for it to completely off.

Does this mean we should also provide the disable time for tuning off 
(optional) so that disable_regulator() should return after actually 
tuning off?
In downstream, we stressed this after putting delay and it worked fine.


Thanks,
Laxman

