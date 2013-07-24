Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308Ab3GXOeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:34:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:31327 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696Ab3GXOdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:33:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,735,1367996400"; 
   d="scan'208";a="375285837"
Message-ID: <51EFE5A8.1060109@linux.intel.com>
Date: Wed, 24 Jul 2013 07:33:12 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jkosina@suse.cz, masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        tglx@linutronix.de, hpa@linux.intel.com, fengguang.wu@intel.com
CC: tip-bot for Jiri Kosina <tipbot@zytor.com>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] kprobes/x86: Call out into INT3 handler directly
 instead of using notifier
References: <alpine.LNX.2.00.1307231007490.14024@pobox.suse.cz> <tip-17f41571bb2c4a398785452ac2718a6c5d77180e@git.kernel.org>
In-Reply-To: <tip-17f41571bb2c4a398785452ac2718a6c5d77180e@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 08:55 PM, tip-bot for Jiri Kosina wrote:
> Commit-ID:  17f41571bb2c4a398785452ac2718a6c5d77180e
> Gitweb:     http://git.kernel.org/tip/17f41571bb2c4a398785452ac2718a6c5d77180e
> Author:     Jiri Kosina <jkosina@suse.cz>
> AuthorDate: Tue, 23 Jul 2013 10:09:28 +0200
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Tue, 23 Jul 2013 10:12:57 +0200
> 
> kprobes/x86: Call out into INT3 handler directly instead of using notifier
> 
> In fd4363fff3d96 ("x86: Introduce int3 (breakpoint)-based
> instruction patching"), the mechanism that was introduced for
> notifying alternatives code from int3 exception handler that and
> exception occured was die_notifier.
> 
> This is however problematic, as early code might be using jump
> labels even before the notifier registration has been performed,
> which will then lead to an oops due to unhandled exception. One
> of such occurences has been encountered by Fengguang:
> 

Please note that putting this patch in perf/core means x86/jumplabel is
completely nonfunctional by itself.

	-hpa


