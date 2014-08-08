Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030AbaHHTCY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 15:02:24 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:47918 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbaHHTCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 15:02:18 -0400
MIME-Version: 1.0
In-Reply-To: <53E4CF4E.6010500@nvidia.com>
References: <1407452515-2390-1-git-send-email-ttynkkynen@nvidia.com>
 <1407452515-2390-2-git-send-email-ttynkkynen@nvidia.com> <20140808094123.GC5387@ulmo>
 <53E4CF4E.6010500@nvidia.com>
From: Rob Herring <robherring2@gmail.com>
Date: Fri, 8 Aug 2014 14:01:57 -0500
Message-ID: <CAL_JsqLFkTGCn-n6+Z644-2iAZ=6PcFD6ox=63pR-eb1s6tNGw@mail.gmail.com>
Subject: Re: [PATCH 1/3] of: Add of_match_machine helper
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 8, 2014 at 8:23 AM, Tuomas Tynkkynen <ttynkkynen@nvidia.com> wrote:
>
>
> On 08/08/14 12:41, Thierry Reding wrote:
>>
>>> +const struct of_device_id *of_match_machine(const struct of_device_id *matches)
>>> +{
>>> +    const struct of_device_id *match;
>>> +    struct device_node *root;
>>> +
>>> +    root = of_find_node_by_path("/");
>>> +    if (!root)
>>> +            return NULL;
>>> +
>>> +    match = of_match_node(matches, root);
>>> +    of_node_put(root);
>>> +    return match;
>>> +}
>>> +EXPORT_SYMBOL(of_match_machine);
>>
>> I wonder if of_find_node_by_path("/") is somewhat overkill here. Perhaps
>> simply of_node_get(of_allnodes) would be more appropriate here since the
>> function is implemented in the core?
>
> of_machine_is_compatible() uses of_find_node_by_path("/") as well, of_allnodes
> seems to be only used when during iterating. So I'd prefer to have them
> consistent.

Agreed.

For the series:

Acked-by: Rob Herring <robh@kernel.org>

Rob
