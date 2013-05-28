Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717Ab3E1KFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 06:05:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:55403 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689Ab3E1KF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 06:05:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,757,1363158000"; 
   d="scan'208";a="247581163"
Date: Tue, 28 May 2013 11:05:22 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: daniel.vetter@ffwll.ch, airlied@linux.ie, yongjun_wei@trendmicro.com.cn,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] drm/i915: fix error return code in
 init_pipe_control()
Message-ID: <20130528100522.GA11775@cantiga.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Wei Yongjun <weiyj.lk@gmail.com>, daniel.vetter@ffwll.ch,
	airlied@linux.ie, yongjun_wei@trendmicro.com.cn,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
References: <CAPgLHd_3SYA3UiZ0yAvNgAMv2jRiQXmEKibqTwJpsNF47EsX9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd_3SYA3UiZ0yAvNgAMv2jRiQXmEKibqTwJpsNF47EsX9g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 05:51:44PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return -ENOMEM in the kmap() error handling case
> instead of 0, as done elsewhere in this function.

kmap() can fail?

It is either translated to page_address() or kmap_high() (on x86),
neither of which may return NULL. However, only kmap_atomic() is
documented as being guaranteed to return a valid value. If we could
have a similar definitive statement for kmap(), we can then cleanup
quite a bit of redundant error handling.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
