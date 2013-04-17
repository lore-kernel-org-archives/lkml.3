Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965807Ab3DQJKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 05:10:09 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:61260 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab3DQJKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 05:10:07 -0400
Message-ID: <39D7C3658A5B4979A3F025E1D944E743@local.st.by>
From: "Victor Miasnikov" <vvm@tut.by>
To: "Michael S. Tsirkin" <mst@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Cc: <x86@kernel.org>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <devel@linuxdriverproject.org>,
        <olaf@aepfle.de>, <apw@canonical.com>, <jasowang@redhat.com>,
        <tglx@linutronix.de>, <hpa@zytor.com>, <JBeulich@suse.com>,
        <bp@alien8.de>
References: <1359940910-32114-1-git-send-email-kys@microsoft.com> <1359940959-32168-1-git-send-email-kys@microsoft.com> <1359940959-32168-2-git-send-email-kys@microsoft.com> <20130417070616.GA4487@redhat.com>
Subject: KVM  "Hyper-V emulation"   -- this can be related "Linux on Hyper-V" ? Or  "KVM emulates Hyper-V" as  "Hyper-V emulates Hyper-V" ? Re: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
Date: Wed, 17 Apr 2013 12:10:01 +0300
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.3790.4548
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4862
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Short:

>> >> When KVM runs in Hyper-V emulation mode it expects to get Hyper-V hypercalls.
>> >>   Mixing KVM hypercalls and Hyper-V requires some tricks. It
VVM>> KVM  "Hyper-V emulation"   -- this can be related "Linux on Hyper-V" ?
> It's not related.

 Are You shue?
Xen-team _think_ too what is not related, but has non-100% _full_ emulation of Hyper-V and, as result, create problems

 Question is very simple:  Hyper-V users/sysadmins need wait patch a-la this:

==
KVM emulates Hyper-V to host enlightened Windows.

 . . .

[ hpa: the problem here is that KVM doesn't emulate Hyper-V well
  enough,  .  . ]

 . . .

+  * KVM emulates Hyper-V to support enlightened Windows.
+  * Check to see first if we are on a KVM Hypervisor.
+ if (KVM_cpuid_base())
+  return false;
 . . .
==

Or  "KVM emulates Hyper-V" as  "Hyper-V emulates Hyper-V" ?



--
Full:

----- Original Message ----- 
From: "Michael S. Tsirkin"
To: "K. Y. Srinivasan"
Cc:
Sent: Wednesday, April 17, 2013 10:06 AM
Subject: Re: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V


> On Sun, Feb 03, 2013 at 05:22:38PM -0800, K. Y. Srinivasan wrote:
>> Xen emulates Hyper-V to host enlightened Windows. Looks like this
>> emulation may be turned on by default even for Linux guests. Check and
>> fail Hyper-V detection if we are on Xen.
>>
>> Signed-off-by: K. Y. Srinivasan kys (at) microsoft.com
>
> I'm very curious what's the specific bug that is fixed here?
> I went over the original discussion in
> https://patchwork.kernel.org/patch/2064331/
> and that's still not clear to me. Is there a configuration
> that is broken without this patch but starts working with
> this patch?
>
> It seems that one might want to use hyper-v emulation e.g. to test
> hyper-v code without using windows, so the functionality
> that this patch disables is not completely useless,
> so there should be a good reason for disabling it.
>
> Could you enlighten me please? :)

 Short history of question:

{{
==
> > And hypercall has its own set of problems with Windows guests.
> > When KVM runs in Hyper-V emulation mode it expects to get Hyper-V hypercalls.
> >   Mixing KVM hypercalls and Hyper-V requires some tricks. It
>
> Can't we simply register a hypercall ID range with Microsoft?
>
> > may also affect WHQLing Windows drivers since driver will talk to HW
> > bypassing Windows interfaces.
>
> Then the WHQL'ed driver doesn't support the PV MMIO hcall?
==

KVM  "Hyper-V emulation"   -- this can be related "Linux on Hyper-V" ?
}}

{{
>> >> When KVM runs in Hyper-V emulation mode it expects to get Hyper-V hypercalls.
>> >>   Mixing KVM hypercalls and Hyper-V requires some tricks. It
>> KVM  "Hyper-V emulation"   -- this can be related "Linux on Hyper-V" ?
> It's not related.

 Are You shue?
Xen-team _think_ too what is not related, but has non-100% _full_ emulation of Hyper-V and, as result, create problems:

==
Xen emulates Hyper-V to host enlightened Windows. Looks like this
emulation may be turned on by default even for Linux guests. Check and
fail Hyper-V detection if we are on Xen.

[ hpa: the problem here is that Xen doesn't emulate Hyper-V well
  enough, and if the Xen support isn't compiled in, we end up stubling
  over the Hyper-V emulation and try to activate it -- and it fails. ]

 . . .

+ /*
+  * Xen emulates Hyper-V to support enlightened Windows.
+  * Check to see first if we are on a Xen Hypervisor.
+  */
+ if (xen_cpuid_base())
+  return false;
+
==
}}


 Question is very simple:  Hyper-V users/sysadmins need wait patch a-la this:

==
KVM emulates Hyper-V to host enlightened Windows. Looks like this
emulation may be turned on by default even for Linux guests. Check and
fail Hyper-V detection if we are on KVM.

[ hpa: the problem here is that KVM doesn't emulate Hyper-V well
  enough, and if the KVM support isn't compiled in, we end up stubling
  over the Hyper-V emulation and try to activate it -- and it fails. ]

 . . .

+ /*
+  * KVM emulates Hyper-V to support enlightened Windows.
+  * Check to see first if we are on a KVM Hypervisor.
+  */
+ if (KVM_cpuid_base())
+  return false;
+
==


Or  "KVM emulates Hyper-V" as  "Hyper-V emulates Hyper-V" ?


Best regards, Victor Miasnikov
Blog:  http://vvm.blog.tut.by/

P.S.



----- Original Message ----- 
From: "Michael S. Tsirkin"
To: "Victor Miasnikov"
Sent: Wednesday, April 17, 2013 10:07 AM

I'm not sure what are we talking about then, but please
use the mailing list appropriate for the subject.


----- Original Message ----- 
From: "Victor Miasnikov" vvm (a) tut (dot) by
To: "Michael S. Tsirkin"
Cc: "KY Srinivasan"
Sent: Tuesday, April 16, 2013 9:36 AM
Subject: Are You shue what is 100% _full_ emulation of Hyper-V? Re: It's not related Re: KVM "Hyper-V emulation" -- this 
can be related "Linux on Hyper-V" ?

Hi!


>> >> When KVM runs in Hyper-V emulation mode it expects to get Hyper-V hypercalls.
>> >>   Mixing KVM hypercalls and Hyper-V requires some tricks. It
>> KVM  "Hyper-V emulation"   -- this can be related "Linux on Hyper-V" ?
> It's not related.

 Are You shue?
Xen-team _think_ too what is not related, but has non-100% _full_ emulation of Hyper-V and, as result, create problems:

==
Xen emulates Hyper-V to host enlightened Windows. Looks like this
emulation may be turned on by default even for Linux guests. Check and
fail Hyper-V detection if we are on Xen.

[ hpa: the problem here is that Xen doesn't emulate Hyper-V well
  enough, and if the Xen support isn't compiled in, we end up stubling
  over the Hyper-V emulation and try to activate it -- and it fails. ]

 . . .

+ /*
+  * Xen emulates Hyper-V to support enlightened Windows.
+  * Check to see first if we are on a Xen Hypervisor.
+  */
+ if (xen_cpuid_base())
+  return false;
+
==

 ( full see ib P.S.)

Best regards, Victor Miasnikov
Blog:  http://vvm.blog.tut.by/

P.S.


==
----- Original Message ----- 
From: "tip-bot for K. Y. Srinivasan"

 . . .

Sent: Wednesday, February 13, 2013 3:57 AM
Subject: [tip:x86/hyperv] X86: Add a check to catch Xen emulation of Hyper-V


Commit-ID:  db34bbb767bdfa1ebed7214b876fe01c5b7ee457
Gitweb:     http://git.kernel.org/tip/db34bbb767bdfa1ebed7214b876fe01c5b7ee457
Author:     K. Y. Srinivasan
AuthorDate: Sun, 3 Feb 2013 17:22:38 -0800
Committer:  H. Peter Anvin
CommitDate: Tue, 12 Feb 2013 16:27:03 -0800

X86: Add a check to catch Xen emulation of Hyper-V

Xen emulates Hyper-V to host enlightened Windows. Looks like this
emulation may be turned on by default even for Linux guests. Check and
fail Hyper-V detection if we are on Xen.

[ hpa: the problem here is that Xen doesn't emulate Hyper-V well
  enough, and if the Xen support isn't compiled in, we end up stubling
  over the Hyper-V emulation and try to activate it -- and it fails. ]

Signed-off-by: K. Y. Srinivasan
Link: http://lkml.kernel.org/r/1359940959-32168-2-git-send-email-kys@microsoft.com
Signed-off-by: H. Peter Anvin
---
 arch/x86/kernel/cpu/mshyperv.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 646d192..4dab317 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -30,6 +30,13 @@ static bool __init ms_hyperv_platform(void)
  if (!boot_cpu_has(X86_FEATURE_HYPERVISOR))
   return false;

+ /*
+  * Xen emulates Hyper-V to support enlightened Windows.
+  * Check to see first if we are on a Xen Hypervisor.
+  */
+ if (xen_cpuid_base())
+  return false;
+
  cpuid(HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS,
        &eax, &hyp_signature[0], &hyp_signature[1], &hyp_signature[2]);

--
==







----- Original Message ----- 
From: "Michael S. Tsirkin"
To: "Victor Miasnikov" vvm (a) tut (dot) by
Sent: Tuesday, April 16, 2013 1:11 AM
Subject: Re: KVM "Hyper-V emulation" -- this can be related "Linux on Hyper-V" ? Fw: When KVM runs in Hyper-V emulation
mode it expects to get Hyper-V hypercalls.


> On Mon, Apr 15, 2013 at 04:00:34PM +0300, Victor Miasnikov wrote:
>>
>> ==
>> >> And hypercall has its own set of problems with Windows guests.
>> >> When KVM runs in Hyper-V emulation mode it expects to get Hyper-V hypercalls.
>> >>   Mixing KVM hypercalls and Hyper-V requires some tricks. It
>> >
>> >Can't we simply register a hypercall ID range with Microsoft?
>> >
>> >> may also affect WHQLing Windows drivers since driver will talk to HW
>> >> bypassing Windows interfaces.
>> >
>> >Then the WHQL'ed driver doesn't support the PV MMIO hcall?
>> ==
>>
>> KVM  "Hyper-V emulation"   -- this can be related "Linux on Hyper-V" ?
>>
>>
>
> It's not related.





----- Original Message ----- 
From: "Victor Miasnikov" vvm (a) tut (dot) by
To: "Michael S. Tsirkin"
Sent: Monday, April 15, 2013 4:00 PM
Subject: KVM "Hyper-V emulation" -- this can be related "Linux on Hyper-V" ? Fw: When KVM runs in Hyper-V emulation mode
it expects to get Hyper-V hypercalls.


Hi!


==
> > And hypercall has its own set of problems with Windows guests.
> > When KVM runs in Hyper-V emulation mode it expects to get Hyper-V hypercalls.
> >   Mixing KVM hypercalls and Hyper-V requires some tricks. It
>
> Can't we simply register a hypercall ID range with Microsoft?
>
> > may also affect WHQLing Windows drivers since driver will talk to HW
> > bypassing Windows interfaces.
>
> Then the WHQL'ed driver doesn't support the PV MMIO hcall?
==

KVM  "Hyper-V emulation"   -- this can be related "Linux on Hyper-V" ?


Best regards, Victor Miasnikov
Blog:  http://vvm.blog.tut.by/




