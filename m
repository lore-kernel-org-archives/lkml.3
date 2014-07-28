Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbaG1Uin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 16:38:43 -0400
Received: from mail-yh0-f54.google.com ([209.85.213.54]:57655 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbaG1Uil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 16:38:41 -0400
MIME-Version: 1.0
In-Reply-To: <20140711175458.6793B2029@prod-mail-relay06.akamai.com>
References: <20140711175458.6793B2029@prod-mail-relay06.akamai.com>
Date: Mon, 28 Jul 2014 16:38:40 -0400
X-Google-Sender-Auth: 75XOMJ_N0wlOiNPub33L4mDQLp0
Message-ID: <CAJvTdKkZoo1yO0N4ra8SBh0XY4PiY+KWkVysGptfhVWYb8kO1g@mail.gmail.com>
Subject: Re: [PATCH] intel_idle: use static_key to optimize idle enter/exit paths
From: Len Brown <lenb@kernel.org>
To: Jason Baron <jbaron@akamai.com>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 1:54 PM, Jason Baron <jbaron@akamai.com> wrote:
> If 'arat' is set in the cpuflags, we can avoid the checks for entering/exiting
> the tick broadcast code entirely. It would seem that this is a hot enough code
> path to make this worthwhile. I ran a few hackbench runs, and consistenly see
> reduced branches and cycles.

Hi Jason,

Your logic looks right -- though I've never used this
static_key_slow_inc() stuff.
I'm impressed that something in user-space could detect this change.

Can you share how to run the workload where you detected a difference,
and describe the hardware you measured?

thanks,
-Len Brown, Intel Open Source Technology Center
