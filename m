Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175Ab3KZSn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 13:43:28 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:58033 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab3KZSn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 13:43:26 -0500
MIME-Version: 1.0
In-Reply-To: <1385473105.4588.14.camel@po-d-abo-ubu>
References: <1385450037.4588.10.camel@po-d-abo-ubu>
	<1574800.Vl6NB1rGSk@amdc1032>
	<1385473105.4588.14.camel@po-d-abo-ubu>
Date: Tue, 26 Nov 2013 13:43:24 -0500
X-Google-Sender-Auth: HTGm7GVGOHI7CG6S8FMf0ajqqoY
Message-ID: <CAJvTdKm8bcUsnn_=_f_NQzJJ_FgmX6Ch3XDK3un22vwE9_Qh_Q@mail.gmail.com>
Subject: Re: [PATCH v2] intel_idle: Fixed C6 state on Avoton/Rangeley processors
From: Len Brown <lenb@kernel.org>
To: Bockholdt Arne <a.bockholdt@precitec-optronik.de>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>                 .desc = "MWAIT 0x51",
> -               .flags = MWAIT2flg(0x58) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> +               .flags = MWAIT2flg(0x51) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
>                 .exit_latency = 15,
>                 .target_residency = 45,

Thanks for noticing that .desc and .flags are inconsistent.
This is my fault -- apparently I e-mailed a version of this patch that
is older than what I have in my git tree.

No big issue, though, as 0x51 and 0x58 do exactly the same thing in
AVN hardware.
Indeed, changing .desc to 0x58 would be fine also.

Acked-by: Len Brown <len.brown@intel.com>
