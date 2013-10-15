Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070Ab3JOJOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 05:14:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36703 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993Ab3JOJOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 05:14:18 -0400
Date: Tue, 15 Oct 2013 11:14:01 +0200
From: Borislav Petkov <bp@suse.de>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Linux PM <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        LKML <linux-kernel@vger.kernel.org>, acme@redhat.com,
        dhowells@redhat.com, bp@suse.de, gthelen@google.com,
        Rafael Wysocki <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH v1] tools/thermal: Introduce tmon, a tool for thermal
 subsystem
Message-ID: <20131015091401.GA8013@pd.tnic>
References: <1381791747-7458-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1381791747-7458-2-git-send-email-jacob.jun.pan@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1381791747-7458-2-git-send-email-jacob.jun.pan@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 04:02:27PM -0700, Jacob Pan wrote:
> Increasingly, Linux is running on thermally constrained devices. The simple
> thermal relationship between processor and fan has become past for modern
> computers.
> 
> As hardware vendors cope with the thermal constraints on their products,
> more sensors are added, new cooling capabilities are introduced. The
> complexity of the thermal relationship can grow exponentially among cooling
> devices, zones, sensors, and trip points. They can also change dynamically.
> 
> To expose such relationship to the userspace, Linux generic thermal layer
> introduced sysfs entry at /sys/class/thermal with a matrix of symbolic
> links, trip point bindings, and device instances. To traverse such
> matrix by hand is not a trivial task. Testing is also difficult in that
> thermal conditions are often exception cases that hard to reach in
> normal operations.
> 
> TMON is conceived as a tool to help visualize, tune, and test the
> complex thermal subsystem.
> 
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
>  tools/Makefile              |   15 +-
>  tools/thermal/tmon/Makefile |   47 ++++
>  tools/thermal/tmon/README   |   50 ++++
>  tools/thermal/tmon/pid.c    |  131 +++++++++
>  tools/thermal/tmon/sysfs.c  |  596 ++++++++++++++++++++++++++++++++++++++++
>  tools/thermal/tmon/tmon.8   |  142 ++++++++++
>  tools/thermal/tmon/tmon.c   |  352 ++++++++++++++++++++++++
>  tools/thermal/tmon/tmon.h   |  204 ++++++++++++++
>  tools/thermal/tmon/tui.c    |  638 +++++++++++++++++++++++++++++++++++++++++++
>  9 files changed, 2173 insertions(+), 2 deletions(-)
>  create mode 100644 tools/thermal/tmon/Makefile
>  create mode 100644 tools/thermal/tmon/README
>  create mode 100644 tools/thermal/tmon/pid.c
>  create mode 100644 tools/thermal/tmon/sysfs.c
>  create mode 100644 tools/thermal/tmon/tmon.8
>  create mode 100644 tools/thermal/tmon/tmon.c
>  create mode 100644 tools/thermal/tmon/tmon.h
>  create mode 100644 tools/thermal/tmon/tui.c

Just a couple of notes/questions:

* Why does this have to be in the kernel src repo? I mean, it only
needs stable sysfs interface but other than that, it can very well be a
separate project on github or so. Or am I missing something?

* So I tried it and I can control the brightness and the target CPU
temperature, cool! :) The question is: can I cook my box with it or
there are protections like filtering values which might be detrimental
to the system? After all, I'm running it as root.

* Also, please run this through checkpatch first:

  total: 1 errors, 0 warnings, 91 checks, 2202 lines checked

  Also, the manpage should be checked for typos and excessive spaces.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
