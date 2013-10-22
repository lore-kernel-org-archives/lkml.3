Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab3JVQgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 12:36:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:9078 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754307Ab3JVQgO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:36:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,549,1378882800"; 
   d="scan'208";a="415262807"
From: "Maliszewski, Richard L" <richard.l.maliszewski@intel.com>
To: =?iso-2022-jp?B?VmxhZGltaXIgJxskQiZVGyhCLWNvZGVyL3BoY29kZXInIFNlcmJpbmVu?=
	 =?iso-2022-jp?B?a28=?= <phcoder@gmail.com>,
        The development of GNU GRUB <grub-devel@gnu.org>
CC: Daniel Kiper <daniel.kiper@oracle.com>,
        "Woodhouse, David" <david.woodhouse@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, "keir@xen.org" <keir@xen.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        "stefano.stabellini@eu.citrix.com" <stefano.stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        Jan Beulich <JBeulich@suse.com>,
        "ross.philipson@citrix.com" <ross.philipson@citrix.com>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>
Subject: Re: EFI and multiboot2 devlopment work for Xen
Thread-Topic: EFI and multiboot2 devlopment work for Xen
Thread-Index: AQHOzl01U2QqStCwI06ZIUY46NKV8Zn/osgAgABUwACAAPKqAIAAAVgAgAAD9ICAAAPwgIAAPmUAgAAQ2ICAAAvggIAAAgsAgAACuACAAAVUAIAABkaA//+N9YA=
Date: Tue, 22 Oct 2013 16:36:04 +0000
Message-ID: <CE8BF72A.243C%richard.l.maliszewski@intel.com>
In-Reply-To: <5266A6AD.90004@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.8.130913
x-originating-ip: [10.252.138.123]
Content-Type: text/plain; charset="iso-2022-jp"
Content-ID: <D1E71335C480864DB53ED9A8023C7183@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I may be off-base, but when I was wading through the grub2 code earlier
this year, it looked to me like it was going to refuse to launch anything
via MB1 or MB2 if the current state was a secure boot launch.

--Richard

On 10/22/13 9:24 AM, "Vladimir 'φ-coder/phcoder' Serbinenko"
<phcoder@gmail.com> wrote:

>On 22.10.2013 18:01, Daniel Kiper wrote:
>> On Tue, Oct 22, 2013 at 03:42:42PM +0000, Woodhouse, David wrote:
>>> On Tue, 2013-10-22 at 16:32 +0100, Matthew Garrett wrote:
>>>>
>>>> There are two problems with this:
>>>>
>>>> 1) The kernel will only boot if it's signed with a key in db, not a
>>>>key
>>>> in MOK.
>>>> 2) grub will read the kernel, but the kernel will have to read the
>>>> initramfs using EFI calls. That means your initramfs must be on a FAT
>>>> partition.
>>>>
>>>> If you're happy with those limitations then just use the chainloader
>>>> command. If you're not, use the linuxefi command.
>>>
>>> Well, we're talking about booting the Xen hypervisor aren't we?
>>>
>>> So yes, there are reasons the Linux kernel uses the 'boot stub' the way
>>> it does, but I'm not sure we advocate that Xen should emulate that in
>>> all its 'glory'?
>> 
>> Right, I think that sensible mixture of multiboot2 protocol (it is
>>needed
>> to pass at least modules list to Xen; IIRC, linuxefi uses Linux Boot
>>protocol
>> for it) with extension proposed by Vladimir and something similar to
>>linuxefi
>> command will solve our problem (I proposed it in my first email). Users
>>which
>> do not need SB may use upstream GRUB2 and others could use
>> 'multiboot2efi extension'.
>I think it's possible to handle secureboot with same multiboot2 base.
>Correct me if I'm wrong but secureboot doesn't specify format of
>signaatures, only that they should be present and checked.
>So why not to make that the only difference between secureboot-enabled
>and not-secureboot-enabled versions is that former enforces signatures
>even against user will. This will reduce the policy-charger patch to
>about 100 lines.
>The signature format to use can be discussed as well. My main problem
>with pe signatures as used for EFI is their apparent complexity but I
>haven't looked in them yet.
>> 
>> Daniel
>> 
>> _______________________________________________
>> Grub-devel mailing list
>> Grub-devel@gnu.org
>> https://lists.gnu.org/mailman/listinfo/grub-devel
>> 
>
>

