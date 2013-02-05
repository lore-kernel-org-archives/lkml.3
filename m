Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab3BEO7A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 09:59:00 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58159 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540Ab3BEO66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 09:58:58 -0500
Date: Tue, 5 Feb 2013 15:58:54 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Alex Shi <alex.shi@intel.com>
Cc: torvalds@linux-foundation.org, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rwsem: steal writing sem for better performance
Message-ID: <20130205145854.GA30949@gmail.com>
References: <1360069915-31619-1-git-send-email-alex.shi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360069915-31619-1-git-send-email-alex.shi@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alex Shi <alex.shi@intel.com> wrote:

> Commit 5a50508 change to rwsem from mutex, that cause aim7 fork_test
> dropped 50%. Yuanhan liu does a good analysis, find it caused by
> strict sequential writing. Ingo suggest stealing sem writing from
> front task in waiting queue. https://lkml.org/lkml/2013/1/29/84
> So has this patch.
> 
> In this patch, I just allow writing steal happen when the 
> first waiter is also writer. Then the performance fully 
> recovered.

All the aim7 fork_test performance regression is recovered?

Thanks,

	Ingo
