Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaFVIZh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:25:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:21774 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbaFVIZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:25:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,523,1400050800"; 
   d="scan'208";a="561399785"
Message-ID: <53A692F9.3060200@intel.com>
Date: Sun, 22 Jun 2014 16:25:29 +0800
From: "Chen, Tiejun" <tiejun.chen@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, daniel.vetter@ffwll.ch,
        jani.nikula@linux.intel.com, airlied@linux.ie
CC: intel-gfx@lists.freedesktop.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        qemu-devel@nongnu.org
Subject: Re: [RFC][PATCH] gpu:drm:i915:intel_detect_pch: back to check devfn
 instead of check class type
References: <1403171631-3452-1-git-send-email-tiejun.chen@intel.com> <53A42DAA.80406@redhat.com>
In-Reply-To: <53A42DAA.80406@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/6/20 20:48, Paolo Bonzini wrote:
> Il 19/06/2014 11:53, Tiejun Chen ha scritto:
>> so this mean that isa bridge is still represented with Dev31:Func0
>> like the native OS. Furthermore, currently we're pushing VGA
>> passthrough support into qemu upstream, and with some discussion,
>> we wouldn't set the bridge class type and just expose this devfn.
>
> Even this is not really optimal.  It just happens to work just because
> QEMU's machine is currently a PCI machine with the ISA bridge on 00:01.0.
>
> As soon as you'll try doing integrated graphics passthrough on a PCIe
> machine type (such as QEMU's "-M q35") things will break down just as
> badly.
>

Sorry, I can't understand why this is related to the ISA bridge, 00:01.0 
or even other PCIe machine type.

In virtualized case we always need to create this ISA bridge as a devfn, 
00:15.0, work for the i915 driver to support IGD passthrough.

In qemu-xen-traditional, this ISA bridge is already created as follows:

1> We set this ISA type explicitly;
2> We register that as 00:15.0.

In qemu-upstream, as you commented we can't create this as a ISA class 
type explicitly. So we compromise by faking this ISA bridge without ISA 
class type setting (as I recall you already said this way is slightly 
better). Maybe we will figure better way in the future. But anyway, this 
is always registered as 00:15.0, right? So I think the i915 driver can 
go back to probe the devfn like the native environment.

If I'm wrong please correct me.

Thanks
Tiejun
