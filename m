Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab3DWOdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 10:33:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:41674 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755699Ab3DWOdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 10:33:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,533,1363158000"; 
   d="scan'208";a="326883650"
Message-ID: <51769BD1.7070002@intel.com>
Date: Tue, 23 Apr 2013 07:33:53 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>,
        Rik van Riel <riel@redhat.com>, Rob Landley <rob@landley.net>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 6/6] add documentation on proc.txt
References: <1366620306-30940-1-git-send-email-minchan@kernel.org> <1366620306-30940-6-git-send-email-minchan@kernel.org> <51756286.4020704@intel.com> <20130423015349.GC2603@blaptop>
In-Reply-To: <20130423015349.GC2603@blaptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2013 06:53 PM, Minchan Kim wrote:
> echo 'file' > /proc/PID/reclaim
> echo 'anon' > /proc/PID/reclaim
> echo 'both' > /proc/PID/reclaim
> 
> For range reclaim,
> 
> echo $((1<<20)) 8192 > /proc/PID/reclaim.
> 
> IOW, we don't need any type for range reclaim because only thing
> user takes care is address range which has mapped page regardless
> of that it's anon or file.
> 
> Does it make sense to you?

That looks very nice!  Although, I'd probably use 'all' instead of
'both'.  It leaves you more wiggle room to add more types in the future,
like volatile pages.
