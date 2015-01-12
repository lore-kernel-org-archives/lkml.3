Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbbALSrI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:47:08 -0500
Received: from mail-yh0-f45.google.com ([209.85.213.45]:56396 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602AbbALSrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:47:05 -0500
Date: Mon, 12 Jan 2015 10:47:01 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Daniel Vetter <daniel.vetter@intel.com>, David Airlie <airlied@linux.ie>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915: fix inconsistent brightness after resume
Message-ID: <20150112184701.GA23217@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Daniel Vetter <daniel.vetter@intel.com>,
	David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <87fvbkz7nd.fsf@intel.com>
 <1420925135-1589-1-git-send-email-jmmahler@gmail.com>
 <877fwsxpci.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877fwsxpci.fsf@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jani,

On Mon, Jan 12, 2015 at 12:31:09PM +0200, Jani Nikula wrote:
> On Sat, 10 Jan 2015, Jeremiah Mahler <jmmahler@gmail.com> wrote:
[...]
> 
> I think part of the problem is that the userspace sets brightness to
> minimum before suspend, but apparently does not restore it after
> resume. The dmesg would confirm this. But I guess it doesn't matter,
> since we're pretty much stuck with having to do this anyway.
> 

I did notice it doing this.  There were several calls to *_update_status
as it was entering suspend which set it to the minimum.

I am not familiar with the intricate details of this system but it seems
like there must be a way to fix this.  If the backlight can be powered
off and back on with the correct level it seems like it should be
possible when a suspend/resume is involved.

[...]
> > -	if (panel->backlight.level == 0) {
> > +	if (panel->backlight.level == panel->backlight.min) {
> 
> Perhaps <= instead of == would be safest?
> 
We could do that too in case that corner case ever arises.

[...]

I will fix it up in v2.

-- 
- Jeremiah Mahler
