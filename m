Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbaHHNXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 09:23:33 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:16967 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbaHHNXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 09:23:30 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 08 Aug 2014 06:10:34 -0700
Message-ID: <53E4CF4E.6010500@nvidia.com>
Date: Fri, 8 Aug 2014 16:23:26 +0300
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [PATCH 1/3] of: Add of_match_machine helper
References: <1407452515-2390-1-git-send-email-ttynkkynen@nvidia.com> <1407452515-2390-2-git-send-email-ttynkkynen@nvidia.com> <20140808094123.GC5387@ulmo>
In-Reply-To: <20140808094123.GC5387@ulmo>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 08/08/14 12:41, Thierry Reding wrote:
> 
>> +const struct of_device_id *of_match_machine(const struct of_device_id *matches)
>> +{
>> +	const struct of_device_id *match;
>> +	struct device_node *root;
>> +
>> +	root = of_find_node_by_path("/");
>> +	if (!root)
>> +		return NULL;
>> +
>> +	match = of_match_node(matches, root);
>> +	of_node_put(root);
>> +	return match;
>> +}
>> +EXPORT_SYMBOL(of_match_machine);
> 
> I wonder if of_find_node_by_path("/") is somewhat overkill here. Perhaps
> simply of_node_get(of_allnodes) would be more appropriate here since the
> function is implemented in the core?

of_machine_is_compatible() uses of_find_node_by_path("/") as well, of_allnodes
seems to be only used when during iterating. So I'd prefer to have them
consistent.

-- 
nvpublic
