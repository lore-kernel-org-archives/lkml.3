Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787Ab3KRMkw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 07:40:52 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:50653 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab3KRMkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 07:40:47 -0500
MIME-Version: 1.0
In-Reply-To: <20131118091042.GB13322@ulmo.nvidia.com>
References: <CA+5PVA7hq9e2twtQ2e24VvF+KHJ_XS4uVskWRQo+g7z3VpmKXw@mail.gmail.com>
	<20131118091042.GB13322@ulmo.nvidia.com>
Date: Mon, 18 Nov 2013 07:40:46 -0500
X-Google-Sender-Auth: tmKuenAl8WItlb9jTtI7CcYnAgg
Message-ID: <CA+5PVA7iAR6B=NkuJ8f+FZdWKJ8AskBG5Pc+rWiQZUttO99BxQ@mail.gmail.com>
Subject: Re: DRM_TEGRA not buildable as a module
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Thierry Reding <treding@nvidia.com>
Cc: Terje Bergstrom <tbergstrom@nvidia.com>, Dave Airlie <airlied@redhat.com>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 4:10 AM, Thierry Reding <treding@nvidia.com> wrote:
> On Sat, Nov 16, 2013 at 03:25:09PM +0100, Josh Boyer wrote:
>> Hi All,
>>
>> The commit below seems to have made the Tegra DRM driver a bool option
>> instead of tristate:
>>
>> commit dee8268f8fb218c9e9b604a40f7dbdd395e910f9
>> Author: Thierry Reding <treding@nvidia.com>
>> Date:   Wed Oct 9 10:32:49 2013 +0200
>>
>>     drm/tegra: Move driver to DRM tree
>>
>>     In order to make subsystem-wide changes easier, move the Tegra DRM
>>     driver back into the DRM tree.
>>
>>     Signed-off-by: Thierry Reding <treding@nvidia.com>
>>
>> That means you can't build the driver as a module.  Was this intended?
>>  The changelog doesn't mention anything about that and the existing
>> help text on the option seems to imply it should be buildable as a
>> module.
>
> This was intended yes. And it wasn't really a change at all, since prior
> to the commit you mention above the DRM driver was always built into the
> host1x driver. That's why I didn't think it necessary to mention it in
> the commit message.
>
> I have some patches queued for 3.14 to enable the driver to be built as
> a module. There are some dependencies such as symbols that need to be
> exported so that the modules can be linked, so it'll require some amount
> of coordination to make that work out within one release cycle, but I'm
> hopeful that we can do it.

OK.  Thanks for the detailed reply.

josh
