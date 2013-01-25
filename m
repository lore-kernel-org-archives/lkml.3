Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab3AYJaZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 04:30:25 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:61463 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860Ab3AYJaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 04:30:20 -0500
MIME-Version: 1.0
In-Reply-To: <CAHp75Vd_1iozR20gHO46fqVQMBrJ43rXbWrLKCesJcqxE5QAhA@mail.gmail.com>
References: <CAOh2x=kqEzw9cvg=WLpjEbF50aTKCUUVd9GzNg8PqtBx_BpYLg@mail.gmail.com>
	<1359032849-25551-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAOh2x=nnrEo69W7sBES85KgF0+WUy8Ouoq+SG1XiB54e7QLiow@mail.gmail.com>
	<1359104204.12502.101.camel@smile>
	<CAHp75Vex-t=q4aQtBsJHiu-r8u98UDPvcbgQi3Z+42dkQWL+YA@mail.gmail.com>
	<CAKohponpZa5Lzf-0p_porTuidL+LhZX3xrHzkwnC6ffTMchRQg@mail.gmail.com>
	<CAHp75Vd_1iozR20gHO46fqVQMBrJ43rXbWrLKCesJcqxE5QAhA@mail.gmail.com>
Date: Fri, 25 Jan 2013 15:00:19 +0530
X-Google-Sender-Auth: iLdP8dMXgKupNsHNkBGUkNPfuWk
Message-ID: <CAOh2x==-amzWv_8s736LQ4AXi35kQY3q3VFLmSaTFBG7A_d0BA@mail.gmail.com>
Subject: Re: [PATCH v3.5] dw_dmac: return proper residue value
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 2:49 PM, Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> On Fri, Jan 25, 2013 at 11:07 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> Who is going to right on ctlhi/lo?

Ahh, my English :( (/s/right/write)

> dwc_do_single_block()
>
>> we write to ctlhi/lo only when we program new
>> transfer. and that is not going to happen while we are in middle of a transfer.
>
> We have got a tasklet running inside tx_status call. Isn't possible?
> tasklet runs scan_descriptors, that continues transfer in soft LLP mode.

But we have just executed scan_descriptor() before this function and it doesn't
look possible that transfer wasn't over then and inbetween these calls we got an
interrupt, scheduled an tasklet and called dwc_do_single_block() :)
