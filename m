Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133AbaCNFoH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 01:44:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:46412 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503AbaCNFoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 01:44:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,652,1389772800"; 
   d="scan'208";a="499657851"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Krzysztof Mazur <krzysiek@podlesie.net>,
        Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [Intel-gfx] i915: black screen after boot on 915GM (Linux >= 3.4-rc1)
In-Reply-To: <20140313083839.GA2396@shrek.podlesie.net>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20140313083839.GA2396@shrek.podlesie.net>
User-Agent: Notmuch/0.17+142~gb08654f2ff14 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 14 Mar 2014 07:42:54 +0200
Message-ID: <87ob195o9t.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2014, Krzysztof Mazur <krzysiek@podlesie.net> wrote:
> Hi,
>
> The commit 3f2dc5ac05714711fc14f2bf0ee5e42d5c08c581 (drm/i915: Fix 915GM
> self-refresh enable/disable) causes strange regression on the HP Compaq
> nc6120. During and after boot to framebuffer console with just LVDS
> the screen is black (backlight on, but black). Starting a X server fixes
> the problem. Connecting an external VGA monitor also fixes the problem.
>
> Reverting this commit fixes the problem at least up to Linux 3.14.0-rc6.
>
> I'm still using ACPI video problem workaround that effectively does:
>
>  static int acpi_video_bus_start_devices(struct acpi_video_bus *video)
>  {
> - return acpi_video_bus_DOS(video, 0,
> + return acpi_video_bus_DOS(video, 3,
>                             acpi_osi_is_win8() ? 1 : 0);
>  }
>
> in drivers/acpi/video.c.
>
> I've added dmesgs from the last good commit and the bad commit at:
> https://bugs.freedesktop.org/show_bug.cgi?id=76103

We track this on the bugzilla. Please add any new information (such as
the other patches you have) there. Thanks.

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Technology Center
