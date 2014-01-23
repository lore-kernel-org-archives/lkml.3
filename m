Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152AbaAWRiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 12:38:09 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:45948 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbaAWRiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 12:38:07 -0500
MIME-Version: 1.0
Reply-To: kusmabite@gmail.com
In-Reply-To: <1389124986-32501-1-git-send-email-kusmabite@gmail.com>
References: <1389124986-32501-1-git-send-email-kusmabite@gmail.com>
From: Erik Faye-Lund <kusmabite@gmail.com>
Date: Thu, 23 Jan 2014 18:31:22 +0100
Message-ID: <CABPQNSarSsWTuYTP0pmBQUiMPcbLG-iPHR-3rS60qSGSVKO0qw@mail.gmail.com>
Subject: Re: [PATCH] gpu: host1x: do not check previously handled gathers
To: linux-tegra@vger.kernel.org
Cc: thierry.reding@gmail.com, tbergstrom@nvidia.com,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Erik Faye-Lund <kusmabite@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

On Tue, Jan 7, 2014 at 9:03 PM, Erik Faye-Lund <kusmabite@gmail.com> wrote:
> When patching gathers, we don't need to check against
> gathers with lower indices than the current one, as
> they are guaranteed to already have been handled.
>
> Signed-off-by: Erik Faye-Lund <kusmabite@gmail.com>
> ---
>
> Here's a trivial optimization I have been running with for a while.
>
>  drivers/gpu/host1x/job.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/host1x/job.c b/drivers/gpu/host1x/job.c
> index de5ec33..e965805 100644
> --- a/drivers/gpu/host1x/job.c
> +++ b/drivers/gpu/host1x/job.c
> @@ -534,7 +534,7 @@ int host1x_job_pin(struct host1x_job *job, struct device *dev)
>
>                 g->base = job->gather_addr_phys[i];
>
> -               for (j = 0; j < job->num_gathers; j++)
> +               for (j = i + 1; j < job->num_gathers; j++)
>                         if (job->gathers[j].bo == g->bo)
>                                 job->gathers[j].handled = true;
>
> --
> 1.8.1.2
>
