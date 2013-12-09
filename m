Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760818Ab3LIKXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:23:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753953Ab3LIKXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:23:33 -0500
Date: Mon, 9 Dec 2013 11:22:45 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>
Subject: Re: [PATCH 1/2] tools/: Convert to new topic libraries
Message-ID: <20131209102245.GC1242@krava.brq.redhat.com>
References: <1386260752-16436-1-git-send-email-bp@alien8.de>
 <1386260752-16436-2-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386260752-16436-2-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 05:25:51PM +0100, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>

SNIP

>  	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(LIBTRACEEVENT_FLAGS) install_plugins
>  
> -LIBLK_SOURCES = $(wildcard $(LK_PATH)*.[ch])
> +LIBAPIKFS_SOURCES = $(wildcard $(LIB_PATH)fs/*.[ch])
>  
>  # if subdir is set, we've been called from above so target has been built
>  # already
> -$(LIBLK): $(LIBLK_SOURCES)
> +$(LIBAPIKFS): $(LIBAPIKFS_SOURCES)
>  ifeq ($(subdir),)
> -	$(QUIET_SUBDIR0)$(LK_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) liblk.a
> +	$(QUIET_SUBDIR0)$(LIB_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) libapikfs.a
>  endif
>  
> -$(LIBLK)-clean:
> +$(LIBAPIKFS)-clean:
>  ifeq ($(subdir),)
> -	$(call QUIET_CLEAN, liblk)
> -	@$(MAKE) -C $(LK_DIR) O=$(OUTPUT) clean >/dev/null
> +	$(call QUIET_CLEAN, LIBAPIKFS)

do we want 'LIBAPIKFS' in lowercase here?

jirka
