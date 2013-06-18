Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933779Ab3FRWNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 18:13:15 -0400
Received: from atlmailgw1.ami.com ([63.147.10.40]:23707 "EHLO
	atlmailgw1.ami.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932479Ab3FRWNM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 18:13:12 -0400
X-AuditID: ac1060b2-b7f996d0000061b5-23-51c0db747759
From: Zachary Bobroff <zacharyb@ami.com>
To: "'Jan Beulich'" <jbeulich@suse.com>,
        "matt@console-pimps.org" <matt@console-pimps.org>
CC: "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "mjg59@srcf.ucam.org" <mjg59@srcf.ucam.org>, Joey Lee <JLee@suse.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] x86, efi: retry ExitBootServices() on failure
Thread-Topic: [PATCH] x86, efi: retry ExitBootServices() on failure
Thread-Index: AQHOZnAqhIBWC10AuUqEyEUoHkYO0Zk0FHKAgAXZuoCAAAcVAIAACL6AgAAMY4CAABjOAIAAc6uQgAEn2oCAAEuXQA==
Date: Tue, 18 Jun 2013 22:12:22 +0000
Message-ID: <7BD74F8E52BFD147B6C83AE7A1E893FFE286040C@atlms1.us.megatrends.com>
References: <1370933558-10128-1-git-send-email-matt@console-pimps.org>
 <1371139233.6523.272.camel@linux-s257.site>
 <20130617092107.GA5440@console-pimps.org>
 <51BEF71402000078000DEC12@nat28.tlf.novell.com>
 <20130617101745.GB8569@console-pimps.org>
 <51BF08CD02000078000DEC99@nat28.tlf.novell.com>
 <20130617123052.GE8569@console-pimps.org>
 <7BD74F8E52BFD147B6C83AE7A1E893FFE285F690@atlms1.us.megatrends.com>
 <51C068C1020000780009C995@nat28.tlf.novell.com>
In-Reply-To: <51C068C1020000780009C995@nat28.tlf.novell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.98.201]
Content-Type: text/plain; charset="us-ascii"
content-transfer-encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKKsWRmVeSWpSXmKPExsWyRiBhhm7p7QOBBus6uC1+7nnIZvHk4Xd2
	i7aHtxgtLu+aw2bRv/0Fu8W3q9OYLK4+nM1isWDjI0YHDo8zjW8YPRbvecnkse7GV3aP9Vuu
	snh83iQXwBrVwGiTmJeXX5JYkqqQklqcbKsUUJRZlphcqaSQmWKrZKikUJCTmJyam5pXYquU
	WFCQmpeiZMelgAFsgMoy8xRS85LzUzLz0m2VPIP9dS0sTC11DZXsQjJSFTLz0vKLchNLMvPz
	FJLz80qAqlNTgKIKCVNYM3qX3GEsuG5Y8eXhOtYGxpUaXYycHBICJhK7Z75ihrDFJC7cW8/W
	xcjFISSwmEmi79cxFgjnMKPE8kN9QFUcHGwCGhIv9lqBNIgIREncf9bKClLDLLCeSeLcgkus
	IAlhASeJzr7XLBBFzhLf+6+xQthZEpM/zwSLswioSvy6/YINxOYV8Jd4fGArI8SyK8wSx1pv
	giU4BWwkDpyfAdbMCHTe91NrmEBsZgFxiVtP5jNBnC0gsWTPeagXRCVePv7HCmErSpzoaISq
	15FYsPsTG4StLbFs4WtmiMWCEidnPmGZwCg2C8nYWUhaZiFpmYWkZQEjyypGocSSnNzEzJz0
	ckO9xNxMveT83E2MkCS0aQdjy0XzQ4wCHIxKPLwNKw8ECrEmlhVX5h5ilOBgVhLh/dMMFOJN
	SaysSi3Kjy8qzUktPsToCgyXicxS3KDIA6aGeGMDA9wcJXHenVeO+AsJpAMTVnZqakFqEcwc
	Jg5OqQZGu4VhO7prtXdabpl16iW7Gl/Q37pZjq4aFyc+8dy9+8biK/MrNt6x7erpP2P752Sy
	6GN5QYYlS7XYT9p1vd8qeL/Y+Ivw2ULF7Sfe3Ajk6n3n4OGWH3XhYcCPnbLBvB+XWxRVSgpe
	y9s5P/bN0dCYynmnfX1Yb1zZcmDSrKfCWcbdOu+3ix/NUGIpzkg01GIuKk4EAMa/6zBoAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All,

Just to make a few more minor clarifications.  According to everything going correctly you will only have two calls to ExitBootServices.  In our specific implementation you will only have one possible failure to ExitBootServices and then a success.  Just to be fair to the industry there is one other case where there could be more than one call to ExitBootServices that returns a failure.  According to the specification, this is the definition of ExitBootServices:

typedef
EFI_STATUS
ExitBootServices (
IN EFI_HANDLEImageHandle,
IN UINTN MapKey
);

With this description of the parameters:
ImageHandle-- Handle that identifies the exiting image. Type EFI_HANDLE is defined in the InstallProtocolInterface() function description.
MapKey-- Key to the latest memory map.

If you pass an invalid MapKey the function is forced to return EFI_INVALID_PARAMETER based upon the following statement:
" If MapKey value is incorrect, ExitBootServices() returns EFI_INVALID_PARAMETER and GetMemoryMap() with ExitBootServices() must be called again. Firmware implementation may choose to do a partial shutdown of the boot services during the first call to ExitBootServices()."  You will note they leave some leeway to what shutdown of services is done if an invalid MapKey is provided.  If you are confident that the Linux code wont pass an Invalid MapKey then no problem, 2 calls should be sufficient(Also, it would be a coding mistake if it did pass one).  If not, you can feel more comfortable increasing the retry number to something more than 1 retry.

> Okay, I'm fine with that aspect then. Let's hope everyone plays by that rule.
This is all according to specification, so if they are not following these rules they should be corrected.  The link to where the current public version of the specification is available is here:
http://www.uefi.org/specs/agreement

I don't think any of the fields are checked so feel free to enter whatever you wish for the items.  It will then take you to a download page.  The version we have been discussing in this e-mail thread is UEFI 2.3.1C.  ExitBootServices is described on pages 256-257 (page numbers 200-201).  If you haven't read it before, it is a pretty simple read.

> Why by one? Splitting some 'free memory' block may result in an increase by more then one afaict. Assuming the increment can only be one is >implying you having knowledge of the allocator implementation and behavior, which shouldn't be made use of in kernel code.
We had to actually increment it by two to get it to work correctly.  This is all based upon the use of the low_alloc routine in the linux kernel file.  I agree there is still some outstanding issue based upon this, but we put it through several different types of tests and it continued to work correctly.  The truest solution would be to us the AllocateMaxAddress parameter when using AllocatePages.  AllocatePages definition listed here:

typedef
EFI_STATUS
AllocatePages(
IN EFI_ALLOCATE_TYPE Type,
IN EFI_MEMORY_TYPE MemoryType,
IN UINTN Pages,
IN OUT EFI_PHYSICAL_ADDRESS*Memory
);

And description when Type= AllocateMaxAddress:

Allocation requests of Type AllocateMaxAddress allocate any available range of pages whose uppermost address is less than or equal to the address pointed to by Memory on input.

This should be able to get you a low allocation in one allocation as opposed to the low_alloc routine which might go through a few iterations of allocations based upon what it is doing.  It was my understanding that the point of this was to allocate the memory map below a certain address in memory because the kernel required it.  Matt, can you comment here?  I am not aware of what address it needs to be below, but using this function should do the trick.  Also, if you want to inform me better of what memory ceiling restrictions there are at this early stage of the kernel, I can rewrite the file without the need of the low_alloc routine entirely.

Hope this clarifies a few things.

Best Regards,
Zach
-----Original Message-----
From: Jan Beulich [mailto:jbeulich@suse.com] 
Sent: Tuesday, June 18, 2013 9:04 AM
To: Zachary Bobroff; matt@console-pimps.org
Cc: matt.fleming@intel.com; mjg59@srcf.ucam.org; Joey Lee; linux-efi@vger.kernel.org; linux-kernel@vger.kernel.org; stable@vger.kernel.org
Subject: RE: [PATCH] x86, efi: retry ExitBootServices() on failure

>>> Zachary Bobroff <zacharyb@ami.com> 06/18/13 2:25 AM >>>
> We only need to retry once because of what is in the UEFI 
> specification 2.3.1 Errata C.  The exact verbiage is as follows:
>
> The ExitBootServices() function is called by the currently executing 
> EFI OS loader image to terminate all boot services. On success, the 
> loader becomes responsible for the continued operation of the system. 
> All events of type EVT_SIGNAL_EXIT_BOOT_SERVICES must be signaled 
> before ExitBootServices() returns EFI_SUCCESS. The events are only signaled once even if ExitBootServices() is called multiple times.
>
> Since the firmware will only signal the ExitBootServices event once, 
> the code that has the potential to change the memory map will only be 
> signaled on the first call to exit boot services.

Okay, I'm fine with that aspect then. Let's hope everyone plays by that rule.

> Here is the logic for why we need space for the two additional Efi 
> Memory Map Descriptors is as follows:
> First, we should think of the size that is returned from the 
> GetMemoryMap as being the number of bytes to contain the current 
> memory map.  Once we have the size of the current memory map, we, the 
> kernel, have to perform an allocation of memory so that we can store 
> the current memory map into some memory that will not be overwritten. 
> That allocation has the possibility of increasing the current memory map count by one efi_memory_desc_t structure.

Why by one? Splitting some 'free memory' block may result in an increase by more then one afaict. Assuming the increment can only be one is implying you having knowledge of the allocator implementation and behavior, which shouldn't be made use of in kernel code.

Jan


The information contained in this message may be confidential and proprietary to American Megatrends, Inc.  This communication is intended to be read only by the individual or entity to whom it is addressed or by their designee. If the reader of this message is not the intended recipient, you are on notice that any distribution of this message, in any form, is strictly prohibited.  Please promptly notify the sender by reply e-mail or by telephone at 770-246-8600, and then delete or destroy all copies of the transmission.
