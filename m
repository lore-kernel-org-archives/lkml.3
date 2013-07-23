Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934126Ab3GWT3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 15:29:47 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:37560 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933691Ab3GWT3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 15:29:46 -0400
Date: Tue, 23 Jul 2013 23:29:49 +0400
From: Artem Savkov <artem.savkov@gmail.com>
To: dchinner@redhat.com, glommer@openvz.org
Cc: daniel.vetter@ffwll.ch, airlied@linux.ie, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm: i915_gem_inactive_scan: insufficient nr_to_scan size
Message-ID: <20130723192949.GA3786@thinkpad.lan>
Mail-Followup-To: dchinner@redhat.com, glommer@openvz.org,
	daniel.vetter@ffwll.ch, airlied@linux.ie,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
References: <1374607086-6761-1-git-send-email-artem.savkov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1374607086-6761-1-git-send-email-artem.savkov@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 11:18:06PM +0400, Artem Savkov wrote:
> nr_to_scan needs to be (unsigned) long, not int, otherwise we get negative
> values on 32bit systems during shrink resulting in lots of messages like one
> below.
> 
> [ 4078.989603] shrink_slab: i915_gem_inactive_scan+0x0/0xc0 negative objects to delete nr=-289580136
> 
> Introduced in "drivers: convert shrinkers to new count/scan API"
> (383e4f4a4cdeb2dd552e90811089bcb4d41eb32e in linux-next.git)

Sorry, looks like my analysis was wrong, I can still see the issue with this
patch.

-- 
Regards,
Artem
