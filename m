Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbaHRKKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 06:10:22 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:11421 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbaHRKKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 06:10:18 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 18 Aug 2014 03:00:46 -0700
Message-ID: <53F1D105.1070107@nvidia.com>
Date: Mon, 18 Aug 2014 13:10:13 +0300
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>
CC: Rob Herring <robh+dt@kernel.org>, Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>, <linux-pm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [PATCH 1/3] of: Add of_match_machine helper
References: <1407452515-2390-1-git-send-email-ttynkkynen@nvidia.com>	<1407452515-2390-2-git-send-email-ttynkkynen@nvidia.com> <20140817152854.5406BC40ADD@trevor.secretlab.ca>
In-Reply-To: <20140817152854.5406BC40ADD@trevor.secretlab.ca>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/08/14 18:28, Grant Likely wrote:
> On Fri, 8 Aug 2014 02:01:53 +0300, Tuomas Tynkkynen <ttynkkynen@nvidia.com> wrote:
[...]
>> +EXPORT_SYMBOL(of_match_machine);
> 
> Too wordy...
> 
> 	return of_match_node(matches, of_allnodes);
> 
> :-)
> 
> It could be a static inline, but I don't think it's even worth having a
> helper. The callers could just open code the above.
> 

Do you mean all the drivers should be referring to of_allnodes directly?
I see that it's indeed exported, but to me that sounds like relying too
much on an implementation detail. In fact, Documentation/devicetree/todo.txt
even seems to have a TODO entry for its removal ("Remove of_allnodes list
and iterate using list of child nodes alone").

-- 
nvpublic
