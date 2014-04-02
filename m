Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030685AbaDBXLH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 19:11:07 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:50367 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933473AbaDBXLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 19:11:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAAVeFuLimi8Mzmqs0Y1OQv6ZJxgQd6Y2bfyF7hmP5_wcPya-gA@mail.gmail.com>
References: <1395650554-31925-1-git-send-email-acourbot@nvidia.com>
	<1395650554-31925-11-git-send-email-acourbot@nvidia.com>
	<CACAvsv4yQuPeoGMW6+k7ChsCZWCjpyBYhEMUomQH2QRrxkW=-w@mail.gmail.com>
	<CAAVeFuLimi8Mzmqs0Y1OQv6ZJxgQd6Y2bfyF7hmP5_wcPya-gA@mail.gmail.com>
Date: Thu, 3 Apr 2014 09:11:03 +1000
Message-ID: <CACAvsv5Cy0BWXMTTeDtFSrX2jg51YAzgF9AjOdyhA-XMALLYjw@mail.gmail.com>
Subject: Re: [PATCH 10/12] drm/nouveau/graph: add GK20A support
From: Ben Skeggs <skeggsb@gmail.com>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>, Ben Skeggs <bskeggs@redhat.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 3, 2014 at 12:03 AM, Alexandre Courbot <gnurou@gmail.com> wrote:
> On Wed, Mar 26, 2014 at 1:24 PM, Ben Skeggs <skeggsb@gmail.com> wrote:
>> On Mon, Mar 24, 2014 at 6:42 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>>> Add a GR device for GK20A based on NVE4, with the correct classes
>>> definitions (GK20A's 3D class is 0xa297).
>>>
>>> Most of the NVE4 code can be used on GK20A, so make relevant bits of
>>> NVE4 available to other chips as well.
>> This will need a bit of a rebase on top of the tree I mentioned
>> earlier (also queued for drm-next now), where I've further split out
>> and named the various chunks of state.
>
> Will do that.
>
>>
>> Does GK104 match entirely correctly, or just happen to work?  I could
>> probably hunt down the GK20A netlist images and check that actually :)
>
> Do you mean, the init sequence? I haven't checked in detail (we are
> certainly doing things differently in the non-DRM driver), but the
> registers seem to match and the GPU is able to render after that. I
> admit I have not looked much further for now.
I meant the arrays of register data, there's generally been some
differences for most major chipset bumps.  Where can I find the
netlist firmware packages that go with the android driver?  I can pull
all the required info out of there to check :)

>
> The only register that does not exist on GK20A is 0x260, but when
> accessing it Nouveau will be able to continue unharmed after a memory
> fault.
I have it in my queue to fix that too, the register doesn't exist on a
couple of the other chips we support too.
