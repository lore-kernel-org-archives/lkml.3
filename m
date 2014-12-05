Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbaLEMR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 07:17:28 -0500
Received: from mga01.intel.com ([192.55.52.88]:34247 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191AbaLEMR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 07:17:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,522,1413270000"; 
   d="scan'208";a="642917080"
From: Jani Nikula <jani.nikula@intel.com>
To: intel-gfx@lists.freedesktop.org, Jeremiah Mahler <jmmahler@gmail.com>,
        weiyj_lk@163.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: drm/i915: Fix missing unlock on error in i915_gem_init_hw()
Date: Fri,  5 Dec 2014 14:17:41 +0200
Message-Id: <1417781862-23368-1-git-send-email-jani.nikula@intel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205013911.GA1510@hudson.localdomain>
References: <20141205013911.GA1510@hudson.localdomain>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Dec 2014, Jeremiah Mahler <jmmahler@gmail.com> wrote:
> There are other places in i915_gem_init_hw() where it returns without
> unlocking the mutex.  Why is it only necessary here and not any of the
> other places?

There's probably some rebase/merge confusion going on. The following
patch is against drm-intel-next-queued where the problem is
present. Thanks for reporting this.

BR,
Jani.


Jani Nikula (1):
  drm/i915: release struct_mutex on the i915_gem_init_hw fail path

 drivers/gpu/drm/i915/i915_gem.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

-- 
2.1.3

