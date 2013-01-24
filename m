Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab3AXIle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 03:41:34 -0500
Received: from mga03.intel.com ([143.182.124.21]:11430 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100Ab3AXIla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 03:41:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,528,1355126400"; 
   d="scan'208";a="194619425"
Message-ID: <1359017171.18561.29.camel@suxuemin.sh.intel.com>
Subject: Re: [PATCH V3] drm_crtc: check if fb_create return NULL
From: "Su, Xuemin" <xuemin.su@intel.com>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, yanmin_zhang@linux.intel.com,
        bo.he@intel.com
Date: Thu, 24 Jan 2013 16:46:11 +0800
In-Reply-To: <87bocfugln.fsf@intel.com>
References: <1358987804.18561.22.camel@suxuemin.sh.intel.com>
	 <87bocfugln.fsf@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-24 at 10:31 +0200, Jani Nikula wrote:
> >  	}
> > +	/* some buggy driver may return NULL here, which may cause panic */
> > +	BUG_ON(!fb);
> 
> I fail to see the benefit of this compared to just letting it oops...
> 
> >  	or->fb_id = fb->base.id;
> 
> ...right here.
> 
> 
For PATCH V3, I think a BUG_ON may give the user clearer information
about the reason of panic. Easier to debug.
I submitted a PATCH V2 yesterday which gives a warning and then return
-EVAL if fb==NULL, preventing the panic. Do you think this is
acceptable?

