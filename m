Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbaF3K4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 06:56:21 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:65384 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaF3K4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 06:56:20 -0400
Message-ID: <53B14250.2080509@redhat.com>
Date: Mon, 30 Jun 2014 12:56:16 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Chen, Tiejun" <tiejun.chen@intel.com>, daniel.vetter@ffwll.ch,
        jani.nikula@linux.intel.com, airlied@linux.ie
CC: intel-gfx@lists.freedesktop.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        qemu-devel@nongnu.org
Subject: Re: [RFC][PATCH] gpu:drm:i915:intel_detect_pch: back to check devfn
 instead of check class type
References: <1403171631-3452-1-git-send-email-tiejun.chen@intel.com> <53A42DAA.80406@redhat.com> <53A692F9.3060200@intel.com> <53AA70C0.2000806@redhat.com> <53AA7B73.90503@intel.com> <53AA808C.5020402@redhat.com> <53B0D5EB.70103@intel.com>
In-Reply-To: <53B0D5EB.70103@intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 30/06/2014 05:13, Chen, Tiejun ha scritto:
> After I discuss internal, we think even we just set the real
> vendor/device ids to this ISA bridge at 00:1f.0, guest firmware should
> still work well with these pair of real vendor/device ids.
>
> So if you think something would conflict or be broken, could you tell us
> what's exactly that? Then we will double check.

The Xen hvmloader doesn't break since it only supports one chipset.  But 
SeaBIOS checks for the exact vendor/device ids since Q35 support was added.

If you want to add this feature, try to implement it in a way that is a 
bit more forward-looking.  I'm sure that Xen sooner or later will want a 
PCIe chipset, otherwise things such as AER forwarding are impossible.

Paolo
