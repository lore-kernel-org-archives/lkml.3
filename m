Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbaAVPe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 10:34:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755254AbaAVPez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 10:34:55 -0500
Date: Wed, 22 Jan 2014 16:34:43 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Fix traceevent plugin path definitions
Message-ID: <20140122153442.GD31858@krava.brq.redhat.com>
References: <20140122150147.GK16455@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140122150147.GK16455@hansolo.jdub.homelinux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 10:01:48AM -0500, Josh Boyer wrote:
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
> 
> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>

Acked-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka
