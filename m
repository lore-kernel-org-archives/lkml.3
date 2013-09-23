Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab3IWSPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 14:15:34 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:48818 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab3IWSPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 14:15:14 -0400
Message-ID: <524082E3.8070801@wwwdotorg.org>
Date: Mon, 23 Sep 2013 12:05:23 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Joseph Lo <josephl@nvidia.com>, Paul Walmsley <pwalmsley@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 05/12] clk: tegra: add header for common tegra clock IDs
References: <1379515331-19427-1-git-send-email-pdeschrijver@nvidia.com> <1379515331-19427-6-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1379515331-19427-6-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2013 08:40 AM, Peter De Schrijver wrote:
> Many clocks are common between several Tegra SoCs. Define an enum to list
> them so we can move them to separate files which can be shared between
> SoCs. Each SoC specific file will provide an array with the common clocks
> which are present on the SoC and their DT binding ID.

So, this enum is purely something internal to the driver, and is in no
way related to the DT binding clock IDs, nor the HW peripheral clock
register bits, and finally is a union of all extant clocks across all chips?

If so, I suppose it's OK to make an enum for this. If not, the same
comments I had re: trying to unify the DT binding clock IDs would apply
here; if there's no architectural guarantee that the clock IDs will be
kept the same across all future chips, assuming they are the same seems
dangerous...
