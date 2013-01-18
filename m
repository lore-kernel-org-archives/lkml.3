Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905Ab3ARSac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 13:30:32 -0500
Received: from mga01.intel.com ([192.55.52.88]:1321 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015Ab3ARSab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 13:30:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,494,1355126400"; 
   d="scan'208";a="278743441"
Date: Fri, 18 Jan 2013 10:30:30 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, jolsa@redhat.com, namhyung.kim@lge.com
Subject: Re: [PATCH v3 2/2] perf stat: add interval printing
Message-ID: <20130118183030.GE4051@tassilo.jf.intel.com>
References: <1358526409-9382-1-git-send-email-eranian@google.com>
 <1358526409-9382-3-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358526409-9382-3-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  	if (forks) {
>  		close(go_pipe[1]);
> +		if (interval) {
> +			while (!waitpid(child_pid, &status, WNOHANG)) {
> +				ret = nanosleep(&ts, NULL);
> +				if (ret == 0 && interval)
> +					print_interval();

It would be good to make sure that if someone Ctrl-Cs
you still print the latest interval(even if shorter)

The rest looks good to me.

-Andi
