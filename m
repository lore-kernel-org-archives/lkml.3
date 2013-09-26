Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab3IZDUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 23:20:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:34313 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941Ab3IZDUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 23:20:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,982,1371106800"; 
   d="scan'208";a="409544880"
From: Andi Kleen <andi@firstfloor.org>
To: Lin Ming <minggr@gmail.com>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: increased vmap_area_lock contentions on "n_tty: Move buffers into n_tty_data"
References: <20130913005133.GA32479@localhost>
	<20130913010936.GA1291@localhost>
	<5238767D.1080606@hurleysoftware.com>
	<20130917232214.GA11390@localhost>
	<5238F252.5070905@hurleysoftware.com>
	<CAF1ivSbYg296oHhO0_UXwkos8Ui_1C93pUnXPzow4qLWyAa2kg@mail.gmail.com>
	<5242C960.7050506@hurleysoftware.com>
	<1380124944.27676.1.camel@monkey32>
Date: Wed, 25 Sep 2013 20:20:37 -0700
In-Reply-To: <1380124944.27676.1.camel@monkey32> (Lin Ming's message of "Thu,
	26 Sep 2013 00:02:24 +0800")
Message-ID: <87r4cc8e0q.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lin Ming <minggr@gmail.com> writes:
>
> Would you like below patch?

The loop body keeps rather complex state. It could easily 
get confused by parallel RCU changes.

So if the list changes in parallel you may suddenly
report very bogus values, as the va_start - prev_end 
computation may be bogus.

Perhaps it's ok (may report bogus gaps), but it seems a bit risky.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
