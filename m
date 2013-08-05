Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab3HETKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 15:10:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:3635 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623Ab3HETKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 15:10:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,820,1367996400"; 
   d="scan'208";a="376527139"
From: Andi Kleen <andi@firstfloor.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, acme@infradead.org,
        Namhyung Kim <namhyung.kim@lge.com>, peterz@infradead.org
Subject: Re: [PATCH] RFC: perf, tools: Move gtk browser into separate perfgtk executable
References: <1375669364-13838-1-git-send-email-andi@firstfloor.org>
	<20130805081641.GA24808@gmail.com>
	<20130805082320.GA9562@infradead.org>
	<87fvuozerv.fsf@sejong.aot.lge.com>
Date: Mon, 05 Aug 2013 12:10:34 -0700
In-Reply-To: <87fvuozerv.fsf@sejong.aot.lge.com> (Namhyung Kim's message of
	"Mon, 05 Aug 2013 18:08:04 +0900")
Message-ID: <87ob9c3qdx.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namhyung Kim <namhyung@kernel.org> writes:
>
> I wrote a patch series [1] separating gtk code to a dso and use it with
> libdl last year.  But I didn't get much feedback probably due to the
> mistake of not installing the dso to a proper place.  It'd be great if
> you guys take a look at it and give some comments.

It looks good as a replacement of this patch

Except for the requirement to build libperf as -fPIC
In some setups the PIC penalty can be high, and libperf
has some very hot code (e.g. callstack merging)

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
