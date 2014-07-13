Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbaGMUct (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 16:32:49 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:63785 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751563AbaGMUcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 16:32:43 -0400
Message-ID: <1405283561.2103.9.camel@x41>
Subject: Re: drm: i915: "plane B assertion failure, should be off on pipe B
 but is still active"
From: Paul Bolle <pebolle@tiscali.nl>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Date: Sun, 13 Jul 2014 22:32:41 +0200
In-Reply-To: <1404291203.12021.18.camel@x220>
References: <1404140703.2978.13.camel@x41> <87egy5h1yz.fsf@intel.com>
	 <1404291203.12021.18.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jul 2014 20:32:41.0453 (UTC) FILETIME=[982299D0:01CF9ED9]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle schreef op wo 02-07-2014 om 10:53 [+0200]:
> On Tue, 2014-07-01 at 12:17 +0300, Jani Nikula wrote:
> > This does not ring any bells to me (but that doesn't prove anything). A
> > bisect result would be awesome.

The bisect (which took me quite some time) points at commit 98ec77397a5c
("drm/i915: Make primary_enabled match the actual hardware state"). The
bisect log is pasted at the end of this message.

Commit 98ec77397a5c reverts cleanly on top of v3.16-rc4. Booting
v3.16-rc4 with that revert added makes the WARNING go away. But note
that I have no idea whether that revert actually is a proper fix here.

Feel free to prod me for further testing, etc.


Paul Bolle

# bad: [7171511eaec5bf23fb06078f59784a3a0626b38f] Linux 3.16-rc1
# good: [1860e379875dfe7271c649058aeddffe5afd9d0d] Linux 3.15
git bisect start 'v3.16-rc1' 'v3.15'
# good: [aaeb2554337217dfa4eac2fcc90da7be540b9a73] Merge branch 'v4l_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media into next
git bisect good aaeb2554337217dfa4eac2fcc90da7be540b9a73
# good: [16b9057804c02e2d351e9c8f606e909b43cbd9e7] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
git bisect good 16b9057804c02e2d351e9c8f606e909b43cbd9e7
# good: [249c8b8d7e2d1bf9505dc46458537e77326c24fd] i40evf: remove unnecessary log messages
git bisect good 249c8b8d7e2d1bf9505dc46458537e77326c24fd
# bad: [1ae5a62bb8b6b544bdfac7bdcb15c9eb22dd6620] drm/nouveau/disp/dp: fix tmds passthrough on dp connector
git bisect bad 1ae5a62bb8b6b544bdfac7bdcb15c9eb22dd6620
# bad: [cea165c34502052cb2aafc7e6bb36fe2036a19df] drm/i915: Wait for vblank in hsw_enable_ips()
git bisect bad cea165c34502052cb2aafc7e6bb36fe2036a19df
# good: [e6069ca84dfafbfdbd0d429445b5858ec5b090ac] drm/i915: sanitize enable_rc6 option
git bisect good e6069ca84dfafbfdbd0d429445b5858ec5b090ac
# bad: [aff10b30a1d3edd1e31f536648772da85e33f655] drm/i915: Don't drop pinned fences
git bisect bad aff10b30a1d3edd1e31f536648772da85e33f655
# bad: [3f1d896c61e889e5b1a0cc0c0211574fa76feefb] drm/i915/chv: Enable aliasing PPGTT for CHV
git bisect bad 3f1d896c61e889e5b1a0cc0c0211574fa76feefb
# good: [0d116a29a8f80260380f608c033dba42240e26a8] drm/i915: vlv: init only needed state during early power well enabling
git bisect good 0d116a29a8f80260380f608c033dba42240e26a8
# bad: [894ed1ec4818ad12e5254de33de2fe5cf2ab987b] drm/i915/crt: Remove ->mode_set callback
git bisect bad 894ed1ec4818ad12e5254de33de2fe5cf2ab987b
# bad: [912b0e2dc6779d70a549dc90b0884face3b2540a] drm/i915/dvo: Remove ->mode_set callback
git bisect bad 912b0e2dc6779d70a549dc90b0884face3b2540a
# good: [024a43e12cccd13b7336fc71ab2067a19ade1857] drm/i915: Move ring_begin to signal()
git bisect good 024a43e12cccd13b7336fc71ab2067a19ade1857
# bad: [0d56bf0b65e6930ea00060d4107414b8d74c9055] drm/i915: Make encoder->mode_set callbacks optional
git bisect bad 0d56bf0b65e6930ea00060d4107414b8d74c9055
# bad: [98ec77397a5c68ce753dc283aaa6f4742328bcdd] drm/i915: Make primary_enabled match the actual hardware state
git bisect bad 98ec77397a5c68ce753dc283aaa6f4742328bcdd
# first bad commit: [98ec77397a5c68ce753dc283aaa6f4742328bcdd] drm/i915: Make primary_enabled match the actual hardware state

