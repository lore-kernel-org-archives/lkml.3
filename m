Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584AbaHHLXl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 07:23:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51168 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755194AbaHHLXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 07:23:39 -0400
Message-ID: <53E4B338.3040904@suse.com>
Date: Fri, 08 Aug 2014 13:23:36 +0200
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: benjamin.widawsky@intel.com
CC: daniel.vetter@ffwll.ch, linux-kernel@vger.kernel.org
Subject: Usage of _PAGE_PCD et al in i915 driver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm just about to create a patch for full PAT support in the Linux
kernel, including Xen. For this purpose I introduce a translation
between cache modes and pte bits.

Scanning the kernel sources for usage of the cache mode bits in the
pte I discovered  drivers/gpu/drm/i915/i915_gem_gtt.h is using
_PAGE_PCD, _PAGE_PWT and _PAGE_PAT. I think those defines are used
to create ptes not for usage by the main processor, but for the
graphics processor. Is this true? In this case I'd suggest to define
i915-specific macros instead of using the x86 ones.

Juergen
