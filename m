Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333AbaAMXCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 18:02:22 -0500
Received: from www.sr71.net ([198.145.64.142]:44806 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbaAMXCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 18:02:19 -0500
Message-ID: <52D47020.6050306@sr71.net>
Date: Mon, 13 Jan 2014 15:00:48 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, bp@suse.de, dtor@vmware.com,
        kys@microsoft.com, haiyangz@microsoft.com, agraf@suse.de,
        gleb@redhat.com
Subject: Re: [PATCH 11/12] x86 Kconfig: create x86/Kconfig.virt
References: <20140113192245.3F682C7F@viggo.jf.intel.com> <20140113192259.5E9DFB02@viggo.jf.intel.com> <52D46CBB.9080103@redhat.com>
In-Reply-To: <52D46CBB.9080103@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2014 02:46 PM, Paolo Bonzini wrote:
> Il 13/01/2014 20:22, Dave Hansen ha scritto:
>> diff -puN arch/x86/Kconfig~x86-Kconfig-move-paravirt-under-virtualization arch/x86/Kconfig
>> --- linux.git/arch/x86/Kconfig~x86-Kconfig-move-paravirt-under-virtualization	2014-01-13 11:11:36.617255854 -0800
>> +++ linux.git-davehans/arch/x86/Kconfig	2014-01-13 11:11:36.620255990 -0800
> 
> These diff headers are unreadable...

Man, and I thought I was pedantic about about those kinds of things.  I
guess git has spoiled everyone. :)

>> @@ -2416,6 +2416,6 @@ source "security/Kconfig"
>>  
>>  source "crypto/Kconfig"
>>  
>> -source "arch/x86/kvm/Kconfig"
>> +source "arch/x86/Kconfig.virt"
>>  
>>  source "lib/Kconfig"
>> diff -puN /dev/null arch/x86/Kconfig.virt
>> --- /dev/null	2013-11-27 17:20:18.337162396 -0800
>> +++ linux.git-davehans/arch/x86/Kconfig.virt	2014-01-13 11:11:36.621256035 -0800
>> @@ -0,0 +1,18 @@
>> +
>> +menuconfig VIRTUALIZATION
>> +	bool "Virtualization"
> 
> Please rename this to "Hypervisor support" or "Virtual guest support" to
> avoid confusion with KVM.  Note there is a reference to
> CONFIG_VIRTUALIZATION in configs/kvm_guest.config.

I'm not sure I'm following.  When this gets done, we have a menu that says:

>         --- Virtualization                                                                          
>         <*>   Kernel-based Virtual Machine (KVM) support                                            
>         <*>     KVM for Intel processors support                                                    
>         <*>     KVM for AMD processors support
>         [*]     Audit KVM MMU                                                                       
>         [*]     KVM legacy PCI device assignment support                                            
>         < >   Host kernel accelerator for virtio net
>         [*]   Linux guest support  --->

So this new menu grouping includes both KVM, Xen, and lguest.  It
includes both the host-side and guest-side support.  Are you suggesting
that we separate out host and guest somehow?


