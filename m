Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaAMXM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 18:12:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbaAMXM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 18:12:56 -0500
Message-ID: <52D472ED.3050303@redhat.com>
Date: Tue, 14 Jan 2014 00:12:45 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Dave Hansen <dave@sr71.net>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, bp@suse.de, dtor@vmware.com,
        kys@microsoft.com, haiyangz@microsoft.com, agraf@suse.de,
        gleb@redhat.com
Subject: Re: [PATCH 11/12] x86 Kconfig: create x86/Kconfig.virt
References: <20140113192245.3F682C7F@viggo.jf.intel.com> <20140113192259.5E9DFB02@viggo.jf.intel.com> <52D46CBB.9080103@redhat.com> <52D47020.6050306@sr71.net>
In-Reply-To: <52D47020.6050306@sr71.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 14/01/2014 00:00, Dave Hansen ha scritto:
>> > Please rename this to "Hypervisor support" or "Virtual guest support" to
>> > avoid confusion with KVM.  Note there is a reference to
>> > CONFIG_VIRTUALIZATION in configs/kvm_guest.config.
> I'm not sure I'm following.  When this gets done, we have a menu that says:
> 
>> >         --- Virtualization                                                                          
>> >         <*>   Kernel-based Virtual Machine (KVM) support                                            
>> >         <*>     KVM for Intel processors support                                                    
>> >         <*>     KVM for AMD processors support
>> >         [*]     Audit KVM MMU                                                                       
>> >         [*]     KVM legacy PCI device assignment support                                            
>> >         < >   Host kernel accelerator for virtio net
>> >         [*]   Linux guest support  --->

Ok, got it now.  The diff headers confused me...

I think this is as confusing as before, perhaps worse because it is not
clear that Linux guest support is not limited to KVM.  If you really
want a Virtualization menu, you have to clearly separate the guest and host:

    --- Virtualization
        Linux guest support  --->
        Virtualization host support  --->

with KVM and vhost under the second item.

> So this new menu grouping includes both KVM, Xen, and lguest.  It
> includes both the host-side and guest-side support.  Are you suggesting
> that we separate out host and guest somehow?

