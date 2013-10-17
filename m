Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab3JQMnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 08:43:17 -0400
Received: from server109-228-6-235.live-servers.net ([109.228.6.235]:60672
	"EHLO fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755050Ab3JQMnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 08:43:14 -0400
X-Greylist: delayed 978 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Oct 2013 08:43:13 EDT
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Thu, 17 Oct 2013 13:26:47 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Pavel Roskin <proski@gnu.org>
Cc: Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm: never write to the userspace more data than the
 caller wants
Message-ID: <20131017122647.GC6862@nuc-i3427.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Pavel Roskin <proski@gnu.org>, Dave Airlie <airlied@redhat.com>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <20131017001235.3077.92963.stgit@IRBT4585>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131017001235.3077.92963.stgit@IRBT4585>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 08:12:35PM -0400, Pavel Roskin wrote:
> The amount of data wanted by the userspace caller is encoded in the
> ioctl number.  Generic drm ioctls were ignoring it.
> 
> As a result, Intel Xorg driver didn't work for i386 userspace on x86_64
> kernel on some systems.  sizeof(struct drm_mode_get_connector) is 76
> bytes on i686 and 80 bytes on x86_64 due to the tail alignment (the data
> positions match).  The userspace was using the 4 bytes after the
> structure to hold the result of the ioctl.  Since drm_ioctl() was
> copying 80 bytes instead of 76, it was clobbering that data.
> 
> A workaround has been committed to xf86-video-intel.
> 
> Signed-off-by: Pavel Roskin <proski@gnu.org>
> Cc: stable@vger.kernel.org

Similar patch:
http://lists.freedesktop.org/archives/dri-devel/2013-October/047412.html
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
