Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbbAYQlP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 11:41:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431AbbAYQlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 11:41:12 -0500
Date: Sun, 25 Jan 2015 17:41:00 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 1/5] tools lib fs: Add helper to find mounted file systems
Message-ID: <20150125164059.GC31987@krava.brq.redhat.com>
References: <20150124181330.195149364@goodmis.org>
 <20150124181448.499062732@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150124181448.499062732@goodmis.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 24, 2015 at 01:13:31PM -0500, Steven Rostedt wrote:

SNIP

>  /* find the path to the mounted debugfs */
>  const char *debugfs_find_mountpoint(void)
>  {
> -	const char * const *ptr;
> -	char type[100];
> -	FILE *fp;
> -
>  	if (debugfs_found)
>  		return (const char *)debugfs_mountpoint;
>  
> -	ptr = debugfs_known_mountpoints;
> -	while (*ptr) {
> -		if (debugfs_valid_mountpoint(*ptr) == 0) {
> -			debugfs_found = true;
> -			strcpy(debugfs_mountpoint, *ptr);
> -			return debugfs_mountpoint;
> -		}
> -		ptr++;
> -	}
> -
> -	/* give up and parse /proc/mounts */
> -	fp = fopen("/proc/mounts", "r");
> -	if (fp == NULL)
> -		return NULL;
> -
> -	while (fscanf(fp, "%*s %" STR(PATH_MAX) "s %99s %*s %*d %*d\n",
> -		      debugfs_mountpoint, type) == 2) {
> -		if (strcmp(type, "debugfs") == 0)
> -			break;
> -	}
> -	fclose(fp);
> -
> -	if (strcmp(type, "debugfs") != 0)
> -		return NULL;
> -
> -	debugfs_found = true;
> -
> -	return debugfs_mountpoint;
> +	return find_mountpoint("debugfs", (long) DEBUGFS_MAGIC,
> +			       debugfs_mountpoint, PATH_MAX + 1,
> +			       debugfs_known_mountpoints);
>  }

debugfs_found is no longer set 'true' by debugfs_find_mountpoint

jirka
