Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186AbaD1Xwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 19:52:39 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:63149 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930AbaD1Xwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:52:37 -0400
MIME-Version: 1.0
In-Reply-To: <20140428065700.GB19455@ulmo>
References: <1398410396-23338-1-git-send-email-acourbot@nvidia.com>
	<1398410396-23338-7-git-send-email-acourbot@nvidia.com>
	<CACAvsv51Ju_ZqJfNU5GzzEmDzf2Fr6Xr_5yGRtfqOQRVTgvDPg@mail.gmail.com>
	<20140428065700.GB19455@ulmo>
Date: Tue, 29 Apr 2014 09:52:36 +1000
Message-ID: <CACAvsv7gp=gWQTRezdSyt4qOBXZR71+dyt0qBKQknOsJ02f6ug@mail.gmail.com>
Subject: Re: [Nouveau] [PATCH v3 6/9] drm/nouveau/graph: enable when using
 external firmware
From: Ben Skeggs <skeggsb@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
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

On Mon, Apr 28, 2014 at 4:57 PM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Mon, Apr 28, 2014 at 12:10:27PM +1000, Ben Skeggs wrote:
>> On Fri, Apr 25, 2014 at 5:19 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>> > nvc0_graph_ctor() would only let the graphics engine be enabled if its
>> > oclass has a proper microcode linked to it. This prevents GR from being
>> > enabled at all on chips that rely exclusively on external firmware, even
>> > though such a use-case is valid.
>> >
>> > Relax the conditions enabling the GR engine to also include the case
>> > where an external firmware has also been loaded.
>> I'm happy to take this patch as-is.  I do wonder if we should do
>> something like this though:
>>
>> if (nouveau_boolopt(device->cfgopt, "NvGrUseFW", oclass->fecs.ucode == NULL))
>>
>> Which will automatically switch to external firmware if there's no
>> internal implementation available.
>
> I think that makes a lot of sense. Perhaps outputting a warning or so at
> runtime when this happens would be helpful in reminding people that the
> goal is to make the GPU run with nouveau firmware rather than external
> firmware, and hence that there's some work left to do.
That already happens with a "using external firmware" notice.

>
> Thierry
