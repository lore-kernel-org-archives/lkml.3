Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722Ab3CKG33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 02:29:29 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14090 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab3CKG32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 02:29:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 10 Mar 2013 23:22:54 -0700
Message-ID: <513D79E7.5000801@nvidia.com>
Date: Mon, 11 Mar 2013 08:29:59 +0200
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Arto Merilainen <amerilainen@nvidia.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5,RESEND 3/8] gpu: host1x: Add channel support
References: <1358250244-9678-1-git-send-email-tbergstrom@nvidia.com> <1358250244-9678-4-git-send-email-tbergstrom@nvidia.com> <20130225152457.GA29545@avionic-0098.mockup.avionic-design.de> <512C84E2.5090201@nvidia.com> <513A0ED0.4070701@nvidia.com> <20130308204301.GA30742@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20130308204301.GA30742@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.03.2013 22:43, Thierry Reding wrote:
> A bo is just a buffer object, so I don't see why the name shouldn't
> be used. The name is in no way specific to DRM or GEM. But the point
> that I was trying to make was that there is nothing to suggest that
> we couldn't use drm_gem_object as the underlying scaffold to base all
> host1x buffer objects on.
> 
> Furthermore I don't understand why you've chosen this approach. It
> is completely different from what other drivers do and therefore
> makes it more difficult to comprehend. That alone I could live with
> if there were any advantages to that approach, but as far as I can
> tell there are none.

I was following the plan we agreed on earlier in email discussion with
you and Lucas:

On 29.11.2012 11:09, Lucas Stach wrote:
> We should aim for a clean split here. GEM handles are something which
> is really specific to how DRM works and as such should be constructed
> by tegradrm. nvhost should really just manage allocations/virtual
> address space and provide something that is able to back all the GEM
> handle operations.
> 
> nvhost has really no reason at all to even know about GEM handles.
> If you back a GEM object by a nvhost object you can just peel out
> the nvhost handles from the GEM wrapper in the tegradrm submit ioctl
> handler and queue the job to nvhost using it's native handles.
> 
> This way you would also be able to construct different handles (like
> GEM obj or V4L2 buffers) from the same backing nvhost object. Note
> that I'm not sure how useful this would be, but it seems like a
> reasonable design to me being able to do so.

With this structure, we are already prepared for non-DRM APIs. Tt's a
matter of familiarity of code versus future expansion. Code paths for
both are as simple/complex, so neither has a direct technical
superiority in performance.

I know other DRM drivers have opted to hard code GEM dependency
throughout the code. Then again, host1x hardware is managing much more
than graphics, so we need to think outside the DRM box, too.

Terje
