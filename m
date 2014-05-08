Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbaEHUdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 16:33:45 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:38669 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754569AbaEHUdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 16:33:43 -0400
Date: Thu, 8 May 2014 14:33:39 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: robh+dt@kernel.org, grant.likely@linaro.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] of: Add of_device_destroy_children() function
Message-ID: <20140508203339.GA542@obsidianresearch.com>
References: <1399567069-3174-1-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399567069-3174-1-git-send-email-s.nawrocki@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 06:37:49PM +0200, Sylwester Nawrocki wrote:
> This patch adds a helper function to unregister devices which
> were created by an of_platform_populate() call. The pattern
> used here can already be found in multiple drivers. This helper
> can now be used instead of repeating similar code in drivers.

I have a driver that does this as well, and what I found is that the
remove must be in reverse order from the create or things explode, and
that assumes the DT is topologically sorted according to dependency
(so no deferred probe).

AFAIK, there is no analog to deferred probe for removal, and
attempting to remove, say, a GPIO driver while an I2C bit bang is using
it just fails.

Jason
