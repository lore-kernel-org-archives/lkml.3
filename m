Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393Ab3LFSYe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 13:24:34 -0500
Received: from mga01.intel.com ([192.55.52.88]:16023 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446Ab3LFSYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 13:24:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,842,1378882800"; 
   d="scan'208";a="445883641"
From: Andi Kleen <andi@firstfloor.org>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: unlisted-recipients:;;linux-fsdevel@vger.kernel.org (no To-header on input),
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Chao Yu <chao2.yu@samsung.com>
Illegal-Object: Syntax error in Cc: address found on vger.kernel.org:
	Cc:	unlisted-recipients:; (no To-header on input)linux-fsdevel@vger.kernel.org
								     ^-missing end of address
Subject: Re: [PATCH] f2fs: add unlikely() macro for compiler more aggressively
References: <1386310509-5864-1-git-send-email-jaegeuk.kim@samsung.com>
Date: Fri, 06 Dec 2013 10:24:31 -0800
In-Reply-To: <1386310509-5864-1-git-send-email-jaegeuk.kim@samsung.com>
	(Jaegeuk Kim's message of "Fri, 06 Dec 2013 15:15:09 +0900")
Message-ID: <87siu5vnvk.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaegeuk Kim <jaegeuk.kim@samsung.com> writes:
>  	struct page *page;
>  repeat:
>  	page = grab_cache_page(mapping, index);
> -	if (!page) {
> +	if (unlikely(!page)) {

This is completely pointless, gcc already considers any test for NULL
unlikely.

In general i would advise against splattering unlikely all over your
code, the benefits are very minimal and programers often get it wrong.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
