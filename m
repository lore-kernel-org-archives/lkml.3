Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164AbaDBODl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 10:03:41 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:43828 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065AbaDBODj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 10:03:39 -0400
MIME-Version: 1.0
In-Reply-To: <CACAvsv4yQuPeoGMW6+k7ChsCZWCjpyBYhEMUomQH2QRrxkW=-w@mail.gmail.com>
References: <1395650554-31925-1-git-send-email-acourbot@nvidia.com>
 <1395650554-31925-11-git-send-email-acourbot@nvidia.com> <CACAvsv4yQuPeoGMW6+k7ChsCZWCjpyBYhEMUomQH2QRrxkW=-w@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Wed, 2 Apr 2014 23:03:19 +0900
Message-ID: <CAAVeFuLimi8Mzmqs0Y1OQv6ZJxgQd6Y2bfyF7hmP5_wcPya-gA@mail.gmail.com>
Subject: Re: [PATCH 10/12] drm/nouveau/graph: add GK20A support
To: Ben Skeggs <skeggsb@gmail.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>, Ben Skeggs <bskeggs@redhat.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 1:24 PM, Ben Skeggs <skeggsb@gmail.com> wrote:
> On Mon, Mar 24, 2014 at 6:42 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>> Add a GR device for GK20A based on NVE4, with the correct classes
>> definitions (GK20A's 3D class is 0xa297).
>>
>> Most of the NVE4 code can be used on GK20A, so make relevant bits of
>> NVE4 available to other chips as well.
> This will need a bit of a rebase on top of the tree I mentioned
> earlier (also queued for drm-next now), where I've further split out
> and named the various chunks of state.

Will do that.

>
> Does GK104 match entirely correctly, or just happen to work?  I could
> probably hunt down the GK20A netlist images and check that actually :)

Do you mean, the init sequence? I haven't checked in detail (we are
certainly doing things differently in the non-DRM driver), but the
registers seem to match and the GPU is able to render after that. I
admit I have not looked much further for now.

The only register that does not exist on GK20A is 0x260, but when
accessing it Nouveau will be able to continue unharmed after a memory
fault.
