Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab3HLF0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 01:26:25 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:47613 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421Ab3HLF0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 01:26:21 -0400
MIME-Version: 1.0
In-Reply-To: <1376239917-15594-13-git-send-email-Julia.Lawall@lip6.fr>
References: <1376239917-15594-1-git-send-email-Julia.Lawall@lip6.fr>
	<1376239917-15594-13-git-send-email-Julia.Lawall@lip6.fr>
Date: Mon, 12 Aug 2013 10:56:21 +0530
Message-ID: <CAKohpo=MfrUTYQKvJHP1Gns3kUfjqG6r9T8+7ZZ98-8yb0BZXw@mail.gmail.com>
Subject: Re: [PATCH 12/16] drivers/cpufreq/pxa3xx-cpufreq.c: Avoid using
 ARRAY_AND_SIZE(e) as a function argument
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, kernel-janitors@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 August 2013 22:21, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> Replace ARRAY_AND_SIZE(e) in function argument position to avoid hiding the
> arity of the called function.

Makes sense.

> The semantic match that makes this change is as follows:
> (http://coccinelle.lip6.fr/)

What is this doing here?

> // <smpl>
> @@
> expression e,f;
> @@
>
> f(...,
> - ARRAY_AND_SIZE(e)
> + e,ARRAY_SIZE(e)
>   ,...)
> // </smpl>
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>
> ---
> Not compiled.
>
>  drivers/cpufreq/pxa3xx-cpufreq.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
