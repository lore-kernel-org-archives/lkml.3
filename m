Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbaGGR6w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 13:58:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284AbaGGR6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 13:58:49 -0400
Message-ID: <53BADFC6.9060101@redhat.com>
Date: Mon, 07 Jul 2014 19:58:30 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Chen, Tiejun" <tiejun.chen@intel.com>, jani.nikula@linux.intel.com,
        airlied@linux.ie, intel-gfx@lists.freedesktop.org,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, qemu-devel@nongnu.org
Subject: Re: [Intel-gfx] [RFC][PATCH] gpu:drm:i915:intel_detect_pch: back
 to check devfn instead of check class type
References: <1403171631-3452-1-git-send-email-tiejun.chen@intel.com> <53A42DAA.80406@redhat.com> <53A692F9.3060200@intel.com> <53AA70C0.2000806@redhat.com> <20140707144917.GZ5821@phenom.ffwll.local> <53BAB569.5000709@redhat.com> <20140707175402.GS5821@phenom.ffwll.local>
In-Reply-To: <20140707175402.GS5821@phenom.ffwll.local>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 07/07/2014 19:54, Daniel Vetter ha scritto:
> On Mon, Jul 07, 2014 at 04:57:45PM +0200, Paolo Bonzini wrote:
>> Il 07/07/2014 16:49, Daniel Vetter ha scritto:
>>> So the correct fix to forward intel gpus to guests is indeed to somehow
>>> fake the pch pci ids since the driver really needs them. Gross design, but
>>> that's how the hardware works.
>>
>> A way that could work for virtualization is this: if you find the card has a
>> magic subsystem vendor id, fetch the subsystem device id and use _that_ as
>> the PCH device id.
>>
>> Would that work for you?
>
> I guess for quemu it also depends upon what windows does since we can't
> change that. If we care about that part. Another consideration is
> supporting older kernels, if that's possible at all.

Yes, but right now it's more important to get something that's not too 
gross for the future, for both Linux and Windows.  Hacks for existing 
guests can be done separately, especially since they might differ 
between Linux (check ISA bridge) and Windows (check 1f.0).

Paolo

