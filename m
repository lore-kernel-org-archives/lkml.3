Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab3DVKf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 06:35:29 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:37203 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523Ab3DVKf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 06:35:28 -0400
Date: Mon, 22 Apr 2013 12:35:21 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Michael Wang <wangyun@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Alex Shi <alex.shi@intel.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] sched: wake-affine throttle
Message-ID: <20130422103521.GA14103@gmail.com>
References: <5164DCE7.8080906@linux.vnet.ibm.com>
 <1366626208.2721.12.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366626208.2721.12.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> OK,.. Ingo said that pipe-test was the original motivation for 
> wake_affine() and since that's currently broken to pieces due to 
> select_idle_sibling() is there still a benefit to having it at all?
> 
> Can anybody find any significant regression when simply killing 
> wake_affine()?

I'd suggest doing a patch that does:

   s/SD_WAKE_AFFINE/0*SD_WAKE_AFFINE

in all the relevant toplogy.h files, but otherwise keep the logic in 
place. That way it's easy to revert.

Thanks,

	Ingo
