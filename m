Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab3LJINT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:13:19 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:39320 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab3LJINQ convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:8:1>);
	Tue, 10 Dec 2013 03:13:16 -0500
Message-Id: <52A6DB24020000780010BAC6@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Tue, 10 Dec 2013 08:13:08 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "John Stultz" <john.stultz@linaro.org>
Cc: "David Vrabel" <david.vrabel@citrix.com>,
        "Richard Cochran" <richardcochran@gmail.com>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>, <xen-devel@lists.xen.org>,
        "Prarit Bhargava" <prarit@redhat.com>,
        "LKML" <linux-kernel@vger.kernel.org>,
        "stable" <stable@vger.kernel.org>
Subject: Re: [Xen-devel] [RFC][PATCH 3/3] timekeeping: Fix potential
 lost pv notification of time change
References: <1386652197-7035-1-git-send-email-john.stultz@linaro.org>
 <1386652197-7035-4-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1386652197-7035-4-git-send-email-john.stultz@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 10.12.13 at 06:09, John Stultz <john.stultz@linaro.org> wrote:
>  static cycle_t logarithmic_accumulation(struct timekeeper *tk, cycle_t offset,
> -						u32 shift)
> +						u32 shift, int *action)

With plain int used here, ...

> @@ -1369,7 +1369,7 @@ static void update_wall_time(void)
>  	struct timekeeper *tk = &shadow_timekeeper;
>  	cycle_t offset;
>  	int shift = 0, maxshift;
> -	unsigned int action;
> +	unsigned int action = 0;

... and unsigned int used here, ...

> @@ -1404,7 +1404,7 @@ static void update_wall_time(void)
>  	maxshift = (64 - (ilog2(ntp_tick_length())+1)) - 1;
>  	shift = min(shift, maxshift);
>  	while (offset >= tk->cycle_interval) {
> -		offset = logarithmic_accumulation(tk, offset, shift);
> +		offset = logarithmic_accumulation(tk, offset, shift, &action);

... does this compile without warning for you?

Jan

