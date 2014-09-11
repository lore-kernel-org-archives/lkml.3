Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbaIKFcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 01:32:25 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:26609 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbaIKFcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 01:32:23 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-49-541133e4b3f7
Message-id: <5411325A.5010308@samsung.com>
Date: Thu, 11 Sep 2014 09:25:46 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.7.0
MIME-version: 1.0
To: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, Dave Hansen <dave.hansen@intel.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Christoph Lameter <cl@linux.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC/PATCH v2 02/10] x86_64: add KASan support
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1410359487-31938-1-git-send-email-a.ryabinin@samsung.com>
 <1410359487-31938-3-git-send-email-a.ryabinin@samsung.com>
 <5410724B.8000803@intel.com>
 <CAPAsAGzm29VWz8ZvOu+fVGn4Vbj7bQZAnB11M5ZZXRTQTchj0w@mail.gmail.com>
 <5410D486.4060200@intel.com> <9E98939B-E2C6-4530-A822-ED550FC3B9D2@zytor.com>
 <54112512.6040409@oracle.com> <54112607.9030303@zytor.com>
 <20140911044650.GN4120@two.firstfloor.org>
In-reply-to: <20140911044650.GN4120@two.firstfloor.org>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t/xK7pPjAVDDFZtkbP4vXcmq8Wc9WvY
	LI5c+85ucf3bG0aLTy8fMFo8f/iQ3WLCwzZ2i2kbxS1WdjezWWx/9pbJYmXnA1aLy7vmsFnc
	W/Of1eLSgQVMFse3bmG2WHzkNrPFu2eTmS02b5rKbHF11UF2ix8bHrM6iHjM3/mR0WPnrLvs
	Hgs2lXos3vOSyWPTqk42j02fJrF7dL29wuTx7tw5do8TM36zeDy5Mp3J4+PTWywe7/ddZfP4
	vEnO40TLF9YAvigum5TUnMyy1CJ9uwSujLata1kLDrBVHH37n6WBsYu1i5GTQ0LARGLn2afM
	ELaYxIV769m6GLk4hASWMkp83H2RFcJpZpLY+mkJG0gVr4CWxIHOvWA2i4CqRNuye2A2m4Ce
	xL9Z28FsUYEIiZ+fv7FD1AtK/Jh8jwXEFhFwk1jX0skEMpRZ4BirxNMjE8EahAWsJTbu3Qe1
	7T6zxOF778ESnALmEg/OfAVKcAB16Encv6gFEmYWkJfYvOYt8wRGgVlIdsxCqJqFpGoBI/Mq
	RtHU0uSC4qT0XEO94sTc4tK8dL3k/NxNjJD4/bKDcfExq0OMAhyMSjy8hRf5Q4RYE8uKK3MP
	MUpwMCuJ8CY8EAgR4k1JrKxKLcqPLyrNSS0+xMjEwSnVwJjscpt32W/NzV8SdyZOUpedd3cP
	r8Shmb+FfCaK16XHSizUk6j93aC5Yl2EXuDJPZ+1T51etkp+zkwuq02WRyOmsjzZfFMrvYj5
	/22TG0nLjcR+v5pT8W070/9KFhPVHM3egNkP5669qrJq6twL+UIBTvse9X/b8kVqV+46o75t
	LwWOSvkKyz5SYinOSDTUYi4qTgQAvzEHa70CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2014 08:46 AM, Andi Kleen wrote:
> On Wed, Sep 10, 2014 at 09:33:11PM -0700, H. Peter Anvin wrote:
>> On 09/10/2014 09:29 PM, Sasha Levin wrote:
>>> On 09/11/2014 12:26 AM, H. Peter Anvin wrote:
>>>> Except you just broke PVop kernels.
>>>
>>> So is this why v2 refuses to boot on my KVM guest? (was digging
>>> into that before I send a mail out).
>>>
>>
>> No, KVM should be fine.  It is Xen PV which ends up as a smoldering crater.
> 
> Just exclude it in Kconfig? I assume PV will eventually go away anyways.
> 
> -Andi
> 

That's done already in this patch:

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -135,6 +135,7 @@ config X86
 	select HAVE_ACPI_APEI if ACPI
 	select HAVE_ACPI_APEI_NMI if ACPI
 	select ACPI_LEGACY_TABLES_LOOKUP if ACPI
+	select HAVE_ARCH_KASAN if X86_64 && !XEN

