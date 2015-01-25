Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbbAYRCP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 12:02:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60597 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041AbbAYRCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 12:02:13 -0500
Date: Sun, 25 Jan 2015 18:02:03 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 4/5] tools lib api fs: Add {tracefs,debugfs}_configured()
 functions
Message-ID: <20150125170203.GG31987@krava.brq.redhat.com>
References: <20150124181330.195149364@goodmis.org>
 <20150124181449.008674149@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150124181449.008674149@goodmis.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 24, 2015 at 01:13:34PM -0500, Steven Rostedt wrote:

SNIP

>  #include <sys/mount.h>
>  #include <linux/kernel.h>
>  
> @@ -24,6 +27,16 @@ static const char * const debugfs_known_mountpoints[] = {
>  
>  static bool debugfs_found;
>  
> +bool debugfs_configured(void)
> +{
> +	struct stat st;
> +
> +	if (stat(DEBUGFS_DEFAULT_PATH, &st) < 0)
> +		return false;
> +

hum, should  this function rather do

bool debugfs_configured(void)
{
	return debugfs_find_mountpoint() != NULL;
}


SNIP

>  static bool tracefs_found;
>  
> +bool tracefs_configured(void)
> +{
> +	struct stat st;
> +
> +	if (stat(TRACEFS_DEFAULT_PATH, &st) < 0)
> +		return false;
> +
> +	return true;
> +}

same for this one..

jirka
