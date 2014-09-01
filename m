Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbaIAUT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 16:19:58 -0400
Received: from mout.gmx.net ([212.227.17.20]:55330 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233AbaIAUT5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 16:19:57 -0400
MIME-Version: 1.0
Message-ID: <trinity-c4c16d70-6e35-4a53-b0ce-663da28bc5ef-1409602778203@3capp-mailcom-bs16>
From: "Tibor Billes" <tbilles@gmx.com>
To: ville.syrjala@linux.intel.com
Cc: intel-gfx@lists.freedesktop.org, "David Airlie" <airlied@linux.ie>,
        "Daniel Vetter" <daniel.vetter@ffwll.ch>,
        "Jani Nikula" <jani.nikula@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        "Chris Wilson" <chris@chris-wilson.co.uk>
Subject: Re: [PATCH v2] drm/i915: Fix lock dropping in intel_tv_detect()
Content-Type: text/plain; charset=UTF-8
Date: Mon, 1 Sep 2014 22:19:38 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <1409566060-21337-1-git-send-email-ville.syrjala@linux.intel.com>
References: <20140901085022.GB11648@nuc-i3427.alporthouse.com>,
 <1409566060-21337-1-git-send-email-ville.syrjala@linux.intel.com>
Content-Transfer-Encoding: 8BIT
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K0:rVjo0J+SF6YsNYKgbTFWlf2BJWEXsUrSVHZgFb9WEPz
 u7Rd6erwHLRfrxyrd02Bc68QecpIcyBOJC07KWmAmiLYDGwyc6
 sOe2Dd5PxgvhhCCXrg719PKAgIDuzXCf/PqCCM0jHvEyLybX+6
 +fH3Sl8zOxDJ4JrrbkOdce/tEU8uQuMexUcQheXotF/2Ny0esV
 P6YuFerUl8vI+bi6uFzWF2mTiTpaIszWTOGXHx/HghugRpf7L0
 ziRFRBAfI+H9917sJ+bl48q0P/3qi/Xq4ovFINz3ZwTNfca+PD
 OPyna7V8G9S2z7TZXn3ienidotW
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

From: ville.syrjala@linux.intel.com Sent: Monday, September 01, 2014 at 12:07 PM

> When intel_tv_detect() fails to do load detection it would forget to
> drop the locks and clean up the acquire context. Fix it up.
> 
> This is a regression from:
> commit 208bf9fdcd3575aa4a5d48b3e0295f7cdaf6fc44
> Author: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Date: Mon Aug 11 13:15:35 2014 +0300
> 
> drm/i915: Fix locking for intel_enable_pipe_a()
> 
> v2: Make the code more readable (Chris)
> 
> Cc: Tibor Billes <tbilles@gmx.com>
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

I tested the posted patch, applying it on top of 3.17-rc2 did solve my boot problems. Just to make sure I also tried a clean 3.17-rc3, which was unable to boot. With this patch applied, it again booted successfully.

I'm not quite sure how tags work, but you may add my following tags:
Reported-by: Tibor Billes <tbilles@gmx.com>
Tested-by: Tibor Billes <tbilles@gmx.com>

Thank you all for the quick responses and the patch, nice work! :)

Tibor
