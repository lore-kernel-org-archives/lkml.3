Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab3KKKXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 05:23:24 -0500
Received: from demumfd002.nsn-inter.net ([93.183.12.31]:11591 "EHLO
	demumfd002.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022Ab3KKKXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 05:23:17 -0500
Message-ID: <5280AFCF.8050208@nsn.com>
Date: Mon, 11 Nov 2013 11:22:07 +0100
From: Ionut Nicu <ioan.nicu.ext@nsn.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: ext Pantelis Antoniou <panto@antoniou-consulting.com>,
        Grant Likely <grant.likely@secretlab.ca>
CC: Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, Joel Becker <jlbec@evilplan.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] DT: proc: Add runtime overlay interface in /proc
References: <1383923170-24914-1-git-send-email-panto@antoniou-consulting.com> <1383923170-24914-4-git-send-email-panto@antoniou-consulting.com>
In-Reply-To: <1383923170-24914-4-git-send-email-panto@antoniou-consulting.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 681
X-purgate-ID: 151667::1384165338-00005753-54CF30AB/0-0/0-0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08.11.2013 16:06, ext Pantelis Antoniou wrote:
> Add a runtime interface to /proc to enable generic device tree overlay
> usage.
> 

> +
> +		/* start at 256K at first */
> +		if (od->alloc == 0)
> +			od->alloc = SZ_256K / 2;
> +

Same problem as Guenter reported. I have to include <linux/sizes.h> or otherwise
the code will not build.

> +	rcu_read_lock();
> +	idr_for_each_entry(&overlay_idr, od, id) {
> +		seq_printf(m, "%d: %d bytes", id, od->size);

For od->size we should use "%zu", otherwise there will be a compilation warning.
At least I get one on mips64...

Otherwise, I've tested this and it works fine for me also.

Thanks,
Ionut
