Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab3BRIUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 03:20:08 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:39107 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349Ab3BRIUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 03:20:05 -0500
Date: Mon, 18 Feb 2013 09:20:01 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, jolsa@redhat.com,
        namhyung@kernel.org
Subject: Re: [PATCH 1/5] perf, x86: Add Haswell PEBS record support v3
Message-ID: <20130218082001.GA15591@gmail.com>
References: <1360771693-32063-1-git-send-email-andi@firstfloor.org>
 <1360771693-32063-2-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360771693-32063-2-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> @@ -41,6 +41,22 @@ struct pebs_record_nhm {
>  	u64 status, dla, dse, lat;
>  };
>  
> +/*
> + * Same as pebs_record_nhm, with two additional fields.
> + */
> +struct pebs_record_hsw {
> +	struct pebs_record_nhm nhm;
> +	/* 
> +	 * Real IP of the event. In the Intel documentation this
> +	 * is called eventingrip.
> +	 */
> +	u64 ip_of_the_event;

Sigh.

In a prior review I objected to the original field's 
'eventingrip' name:

    http://permalink.gmane.org/gmane.linux.kernel/1434494

... because it's a misnomer on so many levels. (What is an 
'eventing'? What 'grip' does it have on anything? 
Whyisthenamemergedtogether?)

But, instead of just renaming it to something usable you renamed 
it to an equally silly "ip_of_the_event" field name.

Just do a 'git grep of_the_' in the kernel source to see how 
silly the name you picked is.

Why are you doing this passive-aggressive crap? Do you want to 
drag out the review even more and delay the Haswell enabling 
patches to v3.10 or beyond?

Thanks,

        Ingo
