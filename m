Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636AbaGAOXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 10:23:17 -0400
Received: from mail.windriver.com ([147.11.1.11]:45515 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297AbaGAOXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 10:23:15 -0400
Message-ID: <53B2C419.4090706@windriver.com>
Date: Tue, 1 Jul 2014 09:22:17 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Daniel Thompson <daniel.thompson@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <patches@linaro.org>,
        <linaro-kernel@lists.linaro.org>, Mike Travis <travis@sgi.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>, <kgdb-bugreport@lists.sourceforge.net>
Subject: Re: [RFC PATCH] kgdb: Timeout if secondary CPUs ignore the roundup
References: <1404224174-25024-1-git-send-email-daniel.thompson@linaro.org>
In-Reply-To: <1404224174-25024-1-git-send-email-daniel.thompson@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2014 09:16 AM, Daniel Thompson wrote:
> Currently if an active CPU fails to respond to a roundup request the
> CPU that requested the roundup will become stuck. This needlessly
> reduces the robustness of the debugger.
>
> This patch introduces a timeout allowing the system state to be examined
> even when the system contains unresponsive processors. It also modifies
> kdb's cpu command to make it censor attempts to switch to unresponsive
> processors and to report their state as (D)ead.


It seems reasonable to allow entry on the master core because there certainly could be useful information to be had with respect to how you got there in the first place, but I wonder about the case for resuming the system.   In general if you couldn't sync in the the first place, the system is dead.  My opinion is that we probably should explicitly disallow a resume or single step at that point.

Jason.

