Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466Ab3BVUJp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 15:09:45 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:60112 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205Ab3BVUJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 15:09:43 -0500
Message-ID: <5127D083.6020308@wwwdotorg.org>
Date: Fri, 22 Feb 2013 13:09:39 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rhyland Klein <rklein@nvidia.com>
CC: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-tegra@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC v2 2/3] power: power_supply: Add core support for supplied_nodes
References: <1361488272-21010-1-git-send-email-rklein@nvidia.com> <1361488272-21010-3-git-send-email-rklein@nvidia.com>
In-Reply-To: <1361488272-21010-3-git-send-email-rklein@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2013 04:11 PM, Rhyland Klein wrote:
> With the growing support for dt, it make sense to try to make use of
> dt features to make the general code cleaner. This patch is an
> attempt to commonize how chargers and their supplies are linked.
> 
> Following common dt convention, the "supplied-to" char** list is
> replaced with phandle lists defined in the supplies which contain
> phandles of their suppliers.
> 
> This has the effect however of introducing an inversion in the internal
> mechanics of how this information is stored. In the case of non-dt,
> the char** list of supplies is stored in the charger. In the dt case,
> a device_node * list is stored in the supplies of their chargers,
> however this seems to be the only way to support this.

grep over the whole kernel tree for supplied_to doesn't yield /too/ many
hits, although I didn't look at the complexity of most of them. Would it
be possible to invert all the current in-kernel uses to represent a
supplied_from/by model instead? That would mean the proposed DT binding
would then represent the same relationship ordering as the kernel code,
which would be easier to handle.
