Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408Ab3DXCxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 22:53:19 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7825 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223Ab3DXCxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 22:53:18 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 23 Apr 2013 19:50:56 -0700
Message-ID: <5177490E.7040509@nvidia.com>
Date: Wed, 24 Apr 2013 10:53:02 +0800
From: Mark Zhang <markz@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        Terje Bergstrom <tbergstrom@nvidia.com>,
        Arto Merilainen <amerilainen@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        "yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next RESEND] gpu: host1x: drm: fix missing unlock on
 error
References: <CAPgLHd8X3pLTM5vsTnHWL3g9GNOrxVF-LkmGWp6_doFkX2_LcQ@mail.gmail.com>
In-Reply-To: <CAPgLHd8X3pLTM5vsTnHWL3g9GNOrxVF-LkmGWp6_doFkX2_LcQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think Thierry has acked this patch. So why?

Mark
On 04/24/2013 10:48 AM, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Add the missing unlock before return from function host1x_drm_init() and
> host1x_drm_exit() in the error handling case.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
> rebased on the latest linux-next.git tree.
> ---
>  drivers/gpu/host1x/drm/drm.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/gpu/host1x/drm/drm.c b/drivers/gpu/host1x/drm/drm.c
> index 2b561c9..0dbb9c0 100644
> --- a/drivers/gpu/host1x/drm/drm.c
> +++ b/drivers/gpu/host1x/drm/drm.c
> @@ -148,6 +148,7 @@ int host1x_drm_init(struct host1x_drm *host1x, struct drm_device *drm)
>  				dev_err(host1x->dev,
>  					"DRM setup failed for %s: %d\n",
>  					dev_name(client->dev), err);
> +				mutex_unlock(&host1x->clients_lock);
>  				return err;
>  			}
>  		}
> @@ -175,6 +176,7 @@ int host1x_drm_exit(struct host1x_drm *host1x)
>  				dev_err(host1x->dev,
>  					"DRM cleanup failed for %s: %d\n",
>  					dev_name(client->dev), err);
> +				mutex_unlock(&host1x->clients_lock);
>  				return err;
>  			}
>  		}
> 
