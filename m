Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbaGGO6B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 10:58:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753175AbaGGO6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 10:58:00 -0400
Message-ID: <53BAB569.5000709@redhat.com>
Date: Mon, 07 Jul 2014 16:57:45 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Chen, Tiejun" <tiejun.chen@intel.com>, jani.nikula@linux.intel.com,
        airlied@linux.ie, intel-gfx@lists.freedesktop.org,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, qemu-devel@nongnu.org
Subject: Re: [RFC][PATCH] gpu:drm:i915:intel_detect_pch: back to check devfn
 instead of check class type
References: <1403171631-3452-1-git-send-email-tiejun.chen@intel.com> <53A42DAA.80406@redhat.com> <53A692F9.3060200@intel.com> <53AA70C0.2000806@redhat.com> <20140707144917.GZ5821@phenom.ffwll.local>
In-Reply-To: <20140707144917.GZ5821@phenom.ffwll.local>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 07/07/2014 16:49, Daniel Vetter ha scritto:
> So the correct fix to forward intel gpus to guests is indeed to somehow
> fake the pch pci ids since the driver really needs them. Gross design, but
> that's how the hardware works.

A way that could work for virtualization is this: if you find the card 
has a magic subsystem vendor id, fetch the subsystem device id and use 
_that_ as the PCH device id.

Would that work for you?

Paolo
