Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab3FZPrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 11:47:17 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:53031 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab3FZPrN convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:7:2>);
	Wed, 26 Jun 2013 11:47:13 -0400
Message-Id: <51CB291E02000078000E0DFB@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 26 Jun 2013 16:47:10 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Ben Guthro" <benjamin.guthro@citrix.com>
Cc: "Gang Wei" <gang.wei@intel.com>, <tboot-devel@lists.sourceforge.net>,
        <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "Rafaell J . Wysocki" <rjw@sisk.pl>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] x86/tboot: Fail extended mode reduced
 hardware sleep
References: <1372255575-29567-1-git-send-email-benjamin.guthro@citrix.com>
 <1372255575-29567-3-git-send-email-benjamin.guthro@citrix.com>
 <51CB1A5902000078000E0D82@nat28.tlf.novell.com>
 <CAOvdn6UyPDBLPg5Q-RW-VZp5FBkj+qDWrNZV-HEY3oj05CovrQ@mail.gmail.com>
In-Reply-To: <CAOvdn6UyPDBLPg5Q-RW-VZp5FBkj+qDWrNZV-HEY3oj05CovrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 26.06.13 at 16:55, Ben Guthro <benjamin.guthro@citrix.com> wrote:
> On Wed, Jun 26, 2013 at 10:44 AM, Jan Beulich <JBeulich@suse.com> wrote:
>>>>> On 26.06.13 at 16:06, Ben Guthro <benjamin.guthro@citrix.com> wrote:
>>> --- a/arch/x86/kernel/tboot.c
>>> +++ b/arch/x86/kernel/tboot.c
>>> @@ -273,7 +273,8 @@ static void tboot_copy_fadt(const struct acpi_table_fadt 
> *fadt)
>>>               offsetof(struct acpi_table_facs, firmware_waking_vector);
>>>  }
>>>
>>> -static int tboot_sleep(u8 sleep_state, u32 pm1a_control, u32 pm1b_control)
>>> +static int tboot_sleep(u8 sleep_state, u32 pm1a_control, u32 pm1b_control,
>>> +                    u8 extended)
>>
>> I don't see why this couldn't remain "bool" - the only complain was
>> that ACPI CA shouldn't use it.
> 
> I changed it, in order to keep the prototypes consistent.
> Having the function pointer be defined with one signature in the
> acpica code, and another in the os implementation seems like a
> maintenance problem.

Of course the first patch would need adjustments too: The function
pointer would also want to use bool then. Again - it's only the ACPI
CA code that wants to get away without using bool/true/false.

Jan

