Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab3ITPgl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 11:36:41 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:64046 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab3ITPgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 11:36:38 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpomXsZ+BsE7j-J4qU+x9f+JPsNEMi3d=CmfMByzPw_wvtw@mail.gmail.com>
References: <CACRpkdYo24DO7ra7cgc54BUN-1SGfmbdhacOT41n2=KknyEtLw@mail.gmail.com>
	<45987104.t6r4hvPgQn@vostro.rjw.lan>
	<523AF22F.1010909@linux.vnet.ibm.com>
	<CACRpkdYxiDA25Yb+csWWgXMmJuKMMTNVbdF+2JUnsSrXQpYysQ@mail.gmail.com>
	<CACRpkdYBYdMJ6mTGUropOypx0ZVNn8eQMzV+eKocCSBZAu6xTA@mail.gmail.com>
	<CAKohpokQO82XMGwcTjVmNTbBVESyFqV4DAxMMU_RHEtN+LqUgg@mail.gmail.com>
	<CACRpkdYoNkgno24dtJAwOq2T9yoKQYgKQ+adfkSN8affYNePjQ@mail.gmail.com>
	<CAKohpokdOXrGVxEA89yrAq2T8MiqZNHrrXNagqqggo67rEmKYg@mail.gmail.com>
	<CAKohpomXsZ+BsE7j-J4qU+x9f+JPsNEMi3d=CmfMByzPw_wvtw@mail.gmail.com>
Date: Fri, 20 Sep 2013 17:36:37 +0200
Message-ID: <CACRpkdYzHw3u4wiZZxZ76mHX81VtOuJXEMtfVj7Ka8g=j_FY_w@mail.gmail.com>
Subject: Re: Regression on cpufreq in v3.12-rc1
From: Linus Walleij <linus.walleij@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 11:35 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:

> commit 389fbc3c8ad7c339cd2d9572d73c355b7b967823
> Author: Viresh Kumar <viresh.kumar@linaro.org>
> Date:   Fri Sep 20 14:55:31 2013 +0530
>
>     cpufreq: check cpufreq driver is valid and cpufreq isn't disabled
> in cpufreq_get()
>
>     cpufreq_get() can be called from external drivers which might not
> be aware if
>     cpufreq driver is registered or not. And so we should actually
> check if cpufreq
>     driver is registered or not and also if cpufreq is active or
> disabled, at the
>     beginning of cpufreq_get().
>
>     Otherwise call to lock_policy_rwsem_read() might hit BUG_ON(!policy).
>
>     Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/cpufreq.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 82ecbe3..db004a8 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1460,6 +1460,9 @@ unsigned int cpufreq_get(unsigned int cpu)
>  {
>         unsigned int ret_freq = 0;
>
> +       if (cpufreq_disabled() || !cpufreq_driver)
> +               return -ENOENT;
> +
>         if (!down_read_trylock(&cpufreq_rwsem))
>                 return 0;

This works! My system boots without crashes after this.

Tested-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
