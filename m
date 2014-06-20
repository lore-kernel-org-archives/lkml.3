Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967277AbaFTMst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 08:48:49 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:41135 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966820AbaFTMsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 08:48:47 -0400
Message-ID: <53A42DAA.80406@redhat.com>
Date: Fri, 20 Jun 2014 14:48:42 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tiejun Chen <tiejun.chen@intel.com>, daniel.vetter@ffwll.ch,
        jani.nikula@linux.intel.com, airlied@linux.ie
CC: intel-gfx@lists.freedesktop.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        qemu-devel@nongnu.org
Subject: Re: [RFC][PATCH] gpu:drm:i915:intel_detect_pch: back to check devfn
 instead of check class type
References: <1403171631-3452-1-git-send-email-tiejun.chen@intel.com>
In-Reply-To: <1403171631-3452-1-git-send-email-tiejun.chen@intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/06/2014 11:53, Tiejun Chen ha scritto:
> so this mean that isa bridge is still represented with Dev31:Func0
> like the native OS. Furthermore, currently we're pushing VGA
> passthrough support into qemu upstream, and with some discussion,
> we wouldn't set the bridge class type and just expose this devfn.

Even this is not really optimal.  It just happens to work just because 
QEMU's machine is currently a PCI machine with the ISA bridge on 00:01.0.

As soon as you'll try doing integrated graphics passthrough on a PCIe 
machine type (such as QEMU's "-M q35") things will break down just as badly.

Paolo
