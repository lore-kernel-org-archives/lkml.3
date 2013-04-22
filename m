Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab3DVQRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 12:17:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:14049 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347Ab3DVQRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 12:17:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,527,1363158000"; 
   d="scan'208";a="322376736"
Message-ID: <51756286.4020704@intel.com>
Date: Mon, 22 Apr 2013 09:17:10 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>,
        Rik van Riel <riel@redhat.com>, Rob Landley <rob@landley.net>
Subject: Re: [PATCH 6/6] add documentation on proc.txt
References: <1366620306-30940-1-git-send-email-minchan@kernel.org> <1366620306-30940-6-git-send-email-minchan@kernel.org>
In-Reply-To: <1366620306-30940-6-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2013 01:45 AM, Minchan Kim wrote:
> +The /proc/PID/reclaim is used to reclaim pages in this process.
> +To reclaim file-backed pages,
> +    > echo 1 > /proc/PID/reclaim
> +
> +To reclaim anonymous pages,
> +    > echo 2 > /proc/PID/reclaim
> +
> +To reclaim both pages,
> +    > echo 3 > /proc/PID/reclaim

This seems to be in the same spirit as /proc/sys/vm/drop_caches.  That's
not a sin in and of itself.  But, why use numbers here?

Any chance I could talk you in to using some strings, say like:

	echo 'anonymous' > /proc/PID/reclaim
	echo 'anonymous|file' > /proc/PID/reclaim


