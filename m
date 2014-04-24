Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbaDXTkl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 15:40:41 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34681 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbaDXTkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 15:40:39 -0400
Date: Thu, 24 Apr 2014 21:40:38 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jikos@jikos.cz>
Subject: [bisect result] Re: 3.15-rc2: i915 regression: only top 20% of
 screen works in X
Message-ID: <20140424194037.GB30333@amd.pavel.ucw.cz>
References: <20140423202248.GA3621@amd.pavel.ucw.cz>
 <CAKMK7uFT5eW8Y8kKvWO1P_aN=SHgP+bZWB8fO2mATKaO=_DNjA@mail.gmail.com>
 <20140423220952.GA3627@amd.pavel.ucw.cz>
 <20140424055023.GA31221@nuc-i3427.alporthouse.com>
 <CAKMK7uFAgHJ-kYJEcDCvNm3B4ELKC8CFK8iP+-SL7bdT5-VQHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uFAgHJ-kYJEcDCvNm3B4ELKC8CFK8iP+-SL7bdT5-VQHA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> And if you can indeed reliably reproduce this a bisect could be really useful.

And we have a winner here :-)

Ok, it was not as painfull as I feared.

It does not revert cleanly, but doing it by hand was not that bad.

Best regards,
   	    	   	    	      	    	     	 Pavel

a51435a3137ad8ae75c288c39bd2d8b2696bae8f is the first bad commit
commit a51435a3137ad8ae75c288c39bd2d8b2696bae8f
Author: Naresh Kumar Kachhi <naresh.kumar.kachhi@intel.com>
Date:   Wed Mar 12 16:39:40 2014 +0530

    drm/i915: disable rings before HW status page setup
    
    Rings should be idle before issuing sync_flush
    (in intel_ring_setup_status_page). This patch moves the ring
    disabling before doing the HW status page setup.
    
    Signed-off-by: Naresh Kumar Kachhi <naresh.kumar.kachhi@intel.com>
    Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>

:040000 040000 23f2763fe684882008ca395f38d0da1cf197a85e
f1052c959b35a99ceae9886603086c09edee5df8 M	drivers
pavel@amd:/data/l/linux-good$ 


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
