Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbaFXJJA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 05:09:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbaFXJI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 05:08:58 -0400
Date: Tue, 24 Jun 2014 11:08:42 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Patrick Palka <patrick@parcs.ath.cx>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH -tip ] [BUGFIX]: Fix to add a missing pair of braces for
 error path.
Message-ID: <20140624090842.GA4091@krava.redhat.com>
References: <53A78F14.8070705@hitachi.com>
 <20140623031712.6541.39111.stgit@kbuild-fedora.novalocal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140623031712.6541.39111.stgit@kbuild-fedora.novalocal>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 03:17:12AM +0000, Masami Hiramatsu wrote:
> Fix to add a missing pair of braces for error path.
> Commit 36d789a4d75f (perf probe: Improve error message for
> unknown member of data structure) introduced this bug.
> 
> Without this fix, defining an event with global variables
> is always failed, because it always returns -ENOENT if
> the argument is not a local variable.
> 
>   ----
>   # perf probe -na "vfs_read smp_found_config"
>     Error: Failed to add events.
>   ----
> 
> With this fix, you can set a global variable for the
> argument of new event.
> 
>   ----
>   # perf probe -na "vfs_read smp_found_config"
>   Added new event:
>     probe:vfs_read       (on vfs_read with smp_found_config)
> 
>   You can now use it in all perf tools, such as:
> 
>           perf record -e probe:vfs_read -aR sleep 1
>   ----

queued for perf/urgent

thanks,
jirka
