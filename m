Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161288AbaDPN4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 09:56:32 -0400
Received: from 20.mo3.mail-out.ovh.net ([178.33.47.94]:59831 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161077AbaDPN4b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 09:56:31 -0400
X-Greylist: delayed 4644 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Apr 2014 09:56:31 EDT
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [PATCH] fbdev: fix possible NULL pointer derefernce
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
In-Reply-To: <20140416094034.GA18082@devel>
Date: Wed, 16 Apr 2014 20:38:51 +0800
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        tomi.valkeinen@ti.com, jg1.han@samsung.com,
        laurent.pinchart@ideasonboard.com, robdclark@gmail.com,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <6A3BE65E-93FD-4E22-A55E-49E54E435558@jcrosoft.com>
References: <20140416094034.GA18082@devel>
To: Daeseok Youn <daeseok.youn@gmail.com>
X-Mailer: Apple Mail (2.1874)
X-Ovh-Tracer-Id: 8774419450757425933
X-Ovh-Remote: 193.138.220.93 (93.220.138.193.client.dyn.strong-ba1.blackoakcomputers.com)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejvddrtdduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejvddrtdduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 16, 2014, at 5:40 PM, Daeseok Youn <daeseok.youn@gmail.com> wrote:

> 
> The spec->modedb can be NULL by fb_create_modedb().
> 
> And also smatch says:
> drivers/video/fbdev/core/fbmon.c:975 fb_edid_to_monspecs() error:
> potential null dereference 'specs->modedb'.
> (fb_create_modedb returns null)
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
> drivers/video/fbdev/core/fbmon.c |    3 +++
> 1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/video/fbdev/core/fbmon.c b/drivers/video/fbdev/core/fbmon.c
> index c204ebe..db274ca 100644
> --- a/drivers/video/fbdev/core/fbmon.c
> +++ b/drivers/video/fbdev/core/fbmon.c
> @@ -966,6 +966,9 @@ void fb_edid_to_monspecs(unsigned char *edid, struct fb_monspecs *specs)
> 
> 	specs->modedb = fb_create_modedb(edid, &specs->modedb_len);
> 
> +	if (!specs->modedb)
> +		return;
> +

we need to return an error and trace it

Best Regards,
J.
> 	/*
> 	 * Workaround for buggy EDIDs that sets that the first
> 	 * detailed timing is preferred but has not detailed
> -- 
> 1.7.4.4
> 

