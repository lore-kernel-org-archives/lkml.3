Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751060AbaEAEyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 00:54:22 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:61496 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbaEAEyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 00:54:20 -0400
MIME-Version: 1.0
In-Reply-To: <CACAvsv51Ju_ZqJfNU5GzzEmDzf2Fr6Xr_5yGRtfqOQRVTgvDPg@mail.gmail.com>
References: <1398410396-23338-1-git-send-email-acourbot@nvidia.com>
 <1398410396-23338-7-git-send-email-acourbot@nvidia.com> <CACAvsv51Ju_ZqJfNU5GzzEmDzf2Fr6Xr_5yGRtfqOQRVTgvDPg@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 1 May 2014 13:53:58 +0900
Message-ID: <CAAVeFuK7H3zK3CaxYT4MP4pY=r2dF0oojjYHG1DGRf7Sq0TExg@mail.gmail.com>
Subject: Re: [Nouveau] [PATCH v3 6/9] drm/nouveau/graph: enable when using
 external firmware
To: Ben Skeggs <skeggsb@gmail.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 11:10 AM, Ben Skeggs <skeggsb@gmail.com> wrote:
> On Fri, Apr 25, 2014 at 5:19 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>> nvc0_graph_ctor() would only let the graphics engine be enabled if its
>> oclass has a proper microcode linked to it. This prevents GR from being
>> enabled at all on chips that rely exclusively on external firmware, even
>> though such a use-case is valid.
>>
>> Relax the conditions enabling the GR engine to also include the case
>> where an external firmware has also been loaded.
> I'm happy to take this patch as-is.  I do wonder if we should do
> something like this though:
>
> if (nouveau_boolopt(device->cfgopt, "NvGrUseFW", oclass->fecs.ucode == NULL))
>
> Which will automatically switch to external firmware if there's no
> internal implementation available.
>
> Thoughts?  This could be a separate patch even, if preferred.

Sure, that should work. Do you mind if I come with a follow-up patch
for this so I don't have to re-sent the current patch series? Since
this is the only comment it received so far.

Thanks,
Alex.
