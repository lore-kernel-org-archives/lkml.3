Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab3AXJDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 04:03:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:18866 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507Ab3AXJD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 04:03:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,528,1355126400"; 
   d="scan'208";a="251644590"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: "Su\, Xuemin" <xuemin.su@intel.com>
Cc: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, yanmin_zhang@linux.intel.com,
        bo.he@intel.com
Subject: Re: [PATCH V3] drm_crtc: check if fb_create return NULL
In-Reply-To: <1359017171.18561.29.camel@suxuemin.sh.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <1358987804.18561.22.camel@suxuemin.sh.intel.com> <87bocfugln.fsf@intel.com> <1359017171.18561.29.camel@suxuemin.sh.intel.com>
User-Agent: Notmuch/0.14+267~g79b3518 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 24 Jan 2013 11:04:40 +0200
Message-ID: <878v7juf2v.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jan 2013, "Su, Xuemin" <xuemin.su@intel.com> wrote:
> On Thu, 2013-01-24 at 10:31 +0200, Jani Nikula wrote:
>> >  	}
>> > +	/* some buggy driver may return NULL here, which may cause panic */
>> > +	BUG_ON(!fb);
>> 
>> I fail to see the benefit of this compared to just letting it oops...
>> 
>> >  	or->fb_id = fb->base.id;
>> 
>> ...right here.
>> 
>> 
> For PATCH V3, I think a BUG_ON may give the user clearer information
> about the reason of panic. Easier to debug.

Ah, sorry, never mind, I missed Daniel's comment. The benefit of the
BUG_ON() is making it clear what's expected of the drivers.

Reviewed-by: Jani Nikula <jani.nikula@intel.com>
