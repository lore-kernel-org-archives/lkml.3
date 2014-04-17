Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702AbaDQSFK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 14:05:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457AbaDQSE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 14:04:58 -0400
Date: Thu, 17 Apr 2014 20:04:52 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Borislav Petkov <bp@suse.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] tools/perf: allow overriding sysfs and proc finding
 with env var
Message-ID: <20140417180452.GI7422@krava.brq.redhat.com>
References: <1397680812-21588-1-git-send-email-cody@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397680812-21588-1-git-send-email-cody@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 01:39:46PM -0700, Cody P Schafer wrote:

SNIP

> +
> +/*
> + * Check for "NAME_PATH" environment variable to override fs location (for
> + * testing). This matches the recommendation in Documentation/sysfs-rules.txt
> + * for SYSFS_PATH.
> + */
> +static bool fs__env_override(struct fs *fs)
> +{
> +	char *override_path;
> +	size_t name_len = strlen(fs->name);
> +	/* name + "_PATH" + '\0' */
> +	char upper_name[name_len + 5 + 1];
> +	memcpy(upper_name, fs->name, name_len);
> +	mem_toupper(upper_name, name_len);
> +	strcpy(&upper_name[name_len], "_PATH");
> +
> +	override_path = getenv(upper_name);
> +	if (!override_path)
> +		return false;
> +
> +	fs->found = true;
> +	strcpy(fs->path, override_path);

please use strncpy with size of fs->path

thanks,
jirka
