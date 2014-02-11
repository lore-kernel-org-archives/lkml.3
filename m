Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbaBKEPQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 23:15:16 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:61114 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbaBKEPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 23:15:13 -0500
MIME-Version: 1.0
In-Reply-To: <20140210123424.GE20143@ulmo.nvidia.com>
References: <1392011892-4339-1-git-send-email-acourbot@nvidia.com> <20140210123424.GE20143@ulmo.nvidia.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 11 Feb 2014 13:14:53 +0900
Message-ID: <CAAVeFuLgopbCSE2u_paxUJC-dsZU=XwJxHen-jWMADQKZuuucQ@mail.gmail.com>
Subject: Re: [PATCH] drm/nouveau: handle -EACCES runtime PM return code
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>, Ben Skeggs <bskeggs@redhat.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 9:34 PM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Mon, Feb 10, 2014 at 02:58:12PM +0900, Alexandre Courbot wrote:
>> pm_runtime_get*() may return -EACCESS to indicate a device does not have
>
> s/-EACCESS/-EACCES/

Oops.

>> runtime PM enabled. This is the case when the nouveau.runpm parameter is
>> set to 0, and is not an error in that context. Handle this case without
>> failure.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>> ---
>>  drivers/gpu/drm/nouveau/dispnv04/crtc.c     | 2 +-
>>  drivers/gpu/drm/nouveau/nouveau_connector.c | 2 +-
>>  drivers/gpu/drm/nouveau/nouveau_drm.c       | 4 ++--
>>  3 files changed, 4 insertions(+), 4 deletions(-)
>
> I'm not sure if the commit message is entirely accurate. Looking at the
> various runtime power-management functions in nouveau_drm.c (such as
> nouveau_pmops_runtime_suspend() for example), they seem to return
> -EINVAL if the nouveau.runpm parameter is set to 0.
>
> However it seems like -EACCES is indeed returned when runtime power-
> management hasn't been enabled for a device. This is done automatically
> for PCI devices, but not for platform devices. We don't support runtime
> power-management on gk20a yet, therefore pm_runtime_enable() is never
> called, causing disable_depth to remain at -1 and therefore runtime PM
> helpers return -EACCES.

I will fix the commit message, as indeed the -EACCES code is not
directly related to the runpm parameter, but rather to the fact
pm_runtime_enable() is not called for platform devices yet.

Do we however agree on the issue that this patch addresses, and the
way it addresses it?

Thanks,
Alex.
