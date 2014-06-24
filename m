Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327AbaFXHk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 03:40:57 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:63123 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbaFXHk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 03:40:56 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Patrick Palka <patrick@parcs.ath.cx>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Jiri Olsa <jolsa@kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH -tip ] [BUGFIX]: Fix to add a missing pair of braces for error path.
References: <53A78F14.8070705@hitachi.com>
	<20140623031712.6541.39111.stgit@kbuild-fedora.novalocal>
Date: Tue, 24 Jun 2014 16:40:53 +0900
In-Reply-To: <20140623031712.6541.39111.stgit@kbuild-fedora.novalocal> (Masami
	Hiramatsu's message of "Mon, 23 Jun 2014 03:17:12 +0000")
Message-ID: <87simu69h6.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

On Mon, 23 Jun 2014 03:17:12 +0000, Masami Hiramatsu wrote:
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
>
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Reported-by: Patrick Palka <patrick@parcs.ath.cx>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Jiri Olsa <jolsa@kernel.org>

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
