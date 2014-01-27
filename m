Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbaA0FYE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 00:24:04 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:61991 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbaA0FYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 00:24:02 -0500
X-AuditID: 9c93017e-b7b63ae000000e6a-40-52e5ed6f1a22
From: Namhyung Kim <namhyung@kernel.org>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Fix traceevent plugin path definitions
References: <20140122150147.GK16455@hansolo.jdub.homelinux.org>
Date: Mon, 27 Jan 2014 14:23:58 +0900
In-Reply-To: <20140122150147.GK16455@hansolo.jdub.homelinux.org> (Josh Boyer's
	message of "Wed, 22 Jan 2014 10:01:48 -0500")
Message-ID: <877g9m6lqp.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jan 2014 10:01:48 -0500, Josh Boyer wrote:
> The plugindir_SQ definition contains $(prefix) which is not needed
> as the $(libdir) definition already contains prefix in it.  This
> leads to the path including an extra prefix in it, e.g. /usr/usr/lib64.
>
> The -DPLUGIN_DIR defintion includes DESTDIR.  This is incorrect, as it
> sets the plugin search path to include the value of DESTDIR.  DESTDIR
> is a mechanism to install in a non-standard location such as a chroot
> or an RPM build root.  In the RPM case, this leads to the search path
> being incorrect after the resulting RPM is installed (or in some cases
> an RPM build failure).
>
> Remove both of these unnecessary inclusions.

Oops, I replied before reading this and previous discussion.. :-/ 

Anyway it looks good to me too.

Thanks,
Namhyung
