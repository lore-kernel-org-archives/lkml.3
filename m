Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab3FLJb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 05:31:26 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:49208 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab3FLJbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 05:31:23 -0400
MIME-Version: 1.0
In-Reply-To: <1371028189-15758-1-git-send-email-chenxg@marvell.com>
References: <1371028189-15758-1-git-send-email-chenxg@marvell.com>
Date: Wed, 12 Jun 2013 15:01:23 +0530
Message-ID: <CAKohponeWuaXPah4s9GjO-fLwQNuyKidUFosN1iE+e7bngDPdQ@mail.gmail.com>
Subject: Re: [PATCH v4] cpufreq: fix governor start/stop race condition
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Xiaoguang Chen <chenxg@marvell.com>
Cc: rjw@sisk.pl, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, njiang1@marvell.com, zjwu@marvell.com,
        ylmao@marvell.com, chenxg.marvell@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 June 2013 14:39, Xiaoguang Chen <chenxg@marvell.com> wrote:

>         ret = policy->governor->governor(policy, event);

We again reached to the same problem. We shouldn't call
this between taking locks, otherwise recursive locks problems
would be seen again.
