Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021Ab3KHUAH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 15:00:07 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51328 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757668Ab3KHUAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 15:00:04 -0500
Date: Fri, 8 Nov 2013 12:00:01 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, Joel Becker <jlbec@evilplan.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] DT: proc: Add runtime overlay interface in /proc
Message-ID: <20131108200001.GA26694@roeck-us.net>
References: <1383923170-24914-1-git-send-email-panto@antoniou-consulting.com>
 <1383923170-24914-4-git-send-email-panto@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383923170-24914-4-git-send-email-panto@antoniou-consulting.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 05:06:10PM +0200, Pantelis Antoniou wrote:
> Add a runtime interface to /proc to enable generic device tree overlay
> usage.
> 

Hi Pantelis,

> ---
>  fs/proc/proc_devtree.c | 278 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 278 insertions(+)
> 
[ ... ]

> +
> +		/* start at 256K at first */
> +		if (od->alloc == 0)
> +			od->alloc = SZ_256K / 2;
> +

I have to include <linux/sizes.h> to get this to build.

Also, even though /proc/device-tree-overlay is supposed to be write only, I get
this:

# cat /proc/device-tree-overlay
cat: [  651.973568] overlay_proc_release: failed to unflatten tree
/proc/device-tree-overlay: Input/output error

which seems to be a bit odd. I did not spend any time to track it down, though.

Otherwise, the code seems to be working well.

Thanks,
Guenter
