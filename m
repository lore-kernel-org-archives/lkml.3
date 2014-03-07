Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbaCGWJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 17:09:00 -0500
Received: from ihemail3.lucent.com ([135.245.0.37]:33300 "EHLO
	ihemail3.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbaCGWI6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 17:08:58 -0500
From: "Li, Bin (Bin)" <bin.bl.li@alcatel-lucent.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jatania, Neel (Neel)" <Neel.Jatania@alcatel-lucent.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Enhancement for PLE handler in KVM
Thread-Topic: Enhancement for PLE handler in KVM
Thread-Index: AQHPNw3F4lhzD8AlbUmUFBaMt3tdkZrQESCAgAJ5ASCAAF+xgP//5v4AgAJ5Z4CAAGTSoIAAj6mA///vIRA=
Date: Fri, 7 Mar 2014 22:08:52 +0000
Message-ID: <72F5E0D8DB6D83469579E473AD72DB23779F88CA@US70UWXCHMBA01.zam.alcatel-lucent.com>
References: <53061044.2000009@alcatel-lucent.com>
 <530B9637.6030708@alcatel-lucent.com> <5314C8C3.3090607@alcatel-lucent.com>
 <5314D61B.9050407@redhat.com>
 <72F5E0D8DB6D83469579E473AD72DB23779EFF64@US70UWXCHMBA01.zam.alcatel-lucent.com>
 <53173961.6080301@redhat.com>
 <72F5E0D8DB6D83469579E473AD72DB23779F1B6B@US70UWXCHMBA01.zam.alcatel-lucent.com>
 <20140307030636.GA13701@amt.cnet>
 <72F5E0D8DB6D83469579E473AD72DB23779F63B3@US70UWXCHMBA01.zam.alcatel-lucent.com>
 <20140307174139.GB30738@amt.cnet>
In-Reply-To: <20140307174139.GB30738@amt.cnet>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [135.5.27.17]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fully agree.
It will be a very helpful feature to make ple setting per VM. 
This feature will provide more flexible control to the VM user. All KVM user will love to have it.

The enhancement we proposed is neither overlapping nor conflicting with this feature. The enhancement is targeting to provide the best real time performance to the guest OS.
There will be more and more embedded system migrating to KVM. Especially in the telecom industry. And a lot of existing system will be running on top of customized embedded OS which significant different from generic OS (either linux  or windows ).

Is there any concern regarding to the enhancement we need to address? Or more work need to be done?

Regards
Bin

-----Original Message-----
From: Marcelo Tosatti [mailto:mtosatti@redhat.com] 
Sent: Friday, March 07, 2014 12:42 PM
To: Li, Bin (Bin)
Cc: Paolo Bonzini; kvm@vger.kernel.org; Jatania, Neel (Neel); linux-kernel@vger.kernel.org
Subject: Re: Enhancement for PLE handler in KVM

On Fri, Mar 07, 2014 at 02:26:19PM +0000, Li, Bin (Bin) wrote:
> Can we have "per-VM PLE values"?
> 
> My understanding is that the ple values are kvm module setting which applying to all VMs in the system.
> And all vms must be stopped first, then unload kvm-intel, reload kvm-intel with new ple setting.
> 
> /sbin/modprobe -r kvm-intel
> /sbin/modprobe kvm-intel ple_window=16384
> 
> Regards
> Bin

Yes, but it can be made per-VM (its a VMCS field).

