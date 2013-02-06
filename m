Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758445Ab3BFUmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:42:04 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17281 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758201Ab3BFUmB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 15:42:01 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 06 Feb 2013 12:41:55 -0800
Message-ID: <5112C00D.7010507@nvidia.com>
Date: Wed, 6 Feb 2013 12:41:49 -0800
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Arto Merilainen <amerilainen@nvidia.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5,RESEND 2/8] gpu: host1x: Add syncpoint wait and interrupts
References: <1358250244-9678-1-git-send-email-tbergstrom@nvidia.com> <1358250244-9678-3-git-send-email-tbergstrom@nvidia.com> <20130204103032.GB27443@avionic-0098.mockup.avionic-design.de> <51108A94.3060501@nvidia.com> <20130205084255.GB20437@avionic-0098.mockup.avionic-design.de> <5112BD26.5060800@nvidia.com> <20130206203854.GA1012@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20130206203854.GA1012@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.02.2013 12:38, Thierry Reding wrote:
> On Wed, Feb 06, 2013 at 12:29:26PM -0800, Terje Bergström wrote:
>> This was done purely, because I'm hiding the struct size from the
>> caller. If the caller needs to allocate, I need to expose the struct in
>> a header, not just a forward declaration.
> 
> I don't think we need to hide the struct from the caller. This is all
> host1x internal. Even if a host1x client uses the struct it makes little
> sense to hide it. They are all part of the same code base so there's not
> much to be gained by hiding the structure definition.

I agree, and will change.

>> Ok, I'll add the wrapper, and I'll check if passing struct host1x *
>> would make sense. In effect that'd render struct host1x_intr mostly
>> unused, so how about if we just merge the contents of host1x_intr to host1x?
> 
> We can probably do that. It might make some sense to keep it in order to
> scope the related fields but struct host1x isn't very large yet, so I
> think omitting host1x_intr should be fine.

Yes, it's not very large, and it'd remove a lot of casting between
host1x and host1x_intr, so I'll just do that.

Terje

