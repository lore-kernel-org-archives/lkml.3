Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbaAGKqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 05:46:04 -0500
Received: from mail.fireflyinternet.com ([87.106.93.118]:63418 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751546AbaAGKqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 05:46:00 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Tue, 7 Jan 2014 10:45:53 +0000
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andreas Heider <andreas@meetr.de>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [PATCH 4/4] drm/i915: check LVDS for EDID on GPU switches
Message-ID: <20140107104553.GC8991@nuc-i3427.alporthouse.com>
References: <1389088723-30959-1-git-send-email-artagnon@gmail.com>
 <1389088723-30959-5-git-send-email-artagnon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389088723-30959-5-git-send-email-artagnon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 03:28:43PM +0530, Ramkumar Ramachandra wrote:
> If the LVDS panel wasn't connected at boot then we won't have an EDID
> for it. To fix this, call intel_lvds_get_edid() from the vga_switcheroo
> reprobe callback.

I would rather have an iterator over all our connectors (or perhaps
encoders would be the right semantic, except we have
connectors==encoders) and a reprobe callback. Saves exporting private
functions and prevent me asking silly questions like what about eDP?
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
