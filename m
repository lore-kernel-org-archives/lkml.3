Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbaCGO01 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 09:26:27 -0500
Received: from ihemail1.lucent.com ([135.245.0.33]:60267 "EHLO
	ihemail1.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbaCGO0Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 09:26:24 -0500
From: "Li, Bin (Bin)" <bin.bl.li@alcatel-lucent.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jatania, Neel (Neel)" <Neel.Jatania@alcatel-lucent.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Enhancement for PLE handler in KVM
Thread-Topic: Enhancement for PLE handler in KVM
Thread-Index: AQHPNw3F4lhzD8AlbUmUFBaMt3tdkZrQESCAgAJ5ASCAAF+xgP//5v4AgAJ5Z4CAAGTSoA==
Date: Fri, 7 Mar 2014 14:26:19 +0000
Message-ID: <72F5E0D8DB6D83469579E473AD72DB23779F63B3@US70UWXCHMBA01.zam.alcatel-lucent.com>
References: <53061044.2000009@alcatel-lucent.com>
 <530B9637.6030708@alcatel-lucent.com> <5314C8C3.3090607@alcatel-lucent.com>
 <5314D61B.9050407@redhat.com>
 <72F5E0D8DB6D83469579E473AD72DB23779EFF64@US70UWXCHMBA01.zam.alcatel-lucent.com>
 <53173961.6080301@redhat.com>
 <72F5E0D8DB6D83469579E473AD72DB23779F1B6B@US70UWXCHMBA01.zam.alcatel-lucent.com>
 <20140307030636.GA13701@amt.cnet>
In-Reply-To: <20140307030636.GA13701@amt.cnet>
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

Can we have "per-VM PLE values"?

My understanding is that the ple values are kvm module setting which applying to all VMs in the system.
And all vms must be stopped first, then unload kvm-intel, reload kvm-intel with new ple setting.

/sbin/modprobe -r kvm-intel
/sbin/modprobe kvm-intel ple_window=16384

Regards
Bin

-----Original Message-----
From: Marcelo Tosatti [mailto:mtosatti@redhat.com] 
Sent: Thursday, March 06, 2014 10:07 PM
To: Li, Bin (Bin)
Cc: Paolo Bonzini; kvm@vger.kernel.org; Jatania, Neel (Neel); linux-kernel@vger.kernel.org; Peter Zijlstra; Mike Galbraith; Chris Wright; ttracy@redhat.com; Nakajima, Jun; riel@redhat.com
Subject: Re: Enhancement for PLE handler in KVM

On Wed, Mar 05, 2014 at 09:16:45PM +0000, Li, Bin (Bin) wrote:
> Did you also find out here why this is the case?
> 
> Binl:
> Yes. The application running in our customized embedded OS is also real time application which is timing sensitive. 
> The timing sensitive level varies among the applications.
> When I talking about different threshold, the assumption is using default 4096 ple_window setting.
> If I set up the ple_window to 16384 or higher, there will be no problem for our application. But the finial user could also run linux or window VM on same hypervisor which would prefer default 4096 setting for linux and windows.

Then have per-VM PLE values?

> We are looking for a solution to be good for both linux / window and real time application.
> The enhancement patch we proposed will satisfy both linux/window application and real time embedded applications.
> 
> Paolo


