Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbbAFQNr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 11:13:47 -0500
Received: from casper.infradead.org ([85.118.1.10]:55115 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbbAFQNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 11:13:46 -0500
Date: Tue, 6 Jan 2015 17:13:27 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Kanaka Juvva <kanaka.d.juvva@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v4 10/11] perf/x86/intel: Perform rotation on Intel CQM
 RMIDs
Message-ID: <20150106161327.GG3337@twins.programming.kicks-ass.net>
References: <1415999712-5850-1-git-send-email-matt@console-pimps.org>
 <1415999712-5850-11-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415999712-5850-11-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 09:15:11PM +0000, Matt Fleming wrote:
> +enum rmid_recycle_state {
> +	RMID_YOUNG = 0,
> +	RMID_AVAILABLE,
> +	RMID_DIRTY,
> +};
> +
>  struct cqm_rmid_entry {
> -	u64 rmid;
> +	unsigned int rmid;
>  	struct list_head list;
> +	unsigned long queue_time;
> +	enum rmid_recycle_state state;
>  };

You probably want that enum after rmid to better pack the structure.
