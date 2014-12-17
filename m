Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaLQMLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 07:11:36 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:47469 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaLQMLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 07:11:34 -0500
Message-ID: <549172F1.5050303@codeaurora.org>
Date: Wed, 17 Dec 2014 17:41:29 +0530
From: Chintan Pandya <cpandya@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: mhocko@suse.cz, linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: Provide knob for force OOM into the memcg
References: <1418736335-30915-1-git-send-email-cpandya@codeaurora.org> <20141216165922.GA30984@phnom.home.cmpxchg.org>
In-Reply-To: <20141216165922.GA30984@phnom.home.cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Why do you move tasks around during runtime?  Rather than scanning
> thousands or millions of page table entries to relocate a task and its
> private memory to another configuration domain, wouldn't it be easier to
> just keep the task in a dedicated cgroup and reconfigure that instead?

Your suggestion is good. But in specific cases, we may have no choice 
but to migrate.

Take a case of an Android system where a process/app will never gets 
killed until there is really no scope of holding it any longer in RAM. 
So, when that process was running as a foreground process, it has to 
belong to a group which has no memory limit and cannot be killed. Now, 
when the same process goes into background and sits idle, it can be 
compressed and cached into some space in RAM. These cached processes are 
ever growing list and can be capped with some limit. Naturally, these 
processes belongs to different category and hence different cgroup which 
just controls such cached processes.

>
> There doesn't seem to be a strong usecase for charge migration that
> couldn't be solved by doing things slightly differently from userspace.
> Certainly not something that justifies the complexity that it adds to
> memcg model and it's synchronization requirements from VM hotpaths.
> Hence, I'm inclined to not add charge moving to version 2 of memcg.

Do you say charge migration is discouraged at runtime ? Difficult to 
live with this limitation.

-- 
Chintan Pandya

QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a
member of the Code Aurora Forum, hosted by The Linux Foundation
