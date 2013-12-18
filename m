Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780Ab3LRTNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 14:13:40 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:61885 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754Ab3LRTNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 14:13:39 -0500
MIME-Version: 1.0
In-Reply-To: <52B16533020000780010E890@nat28.tlf.novell.com>
References: <52AF1EBC020000780010DBF9@nat28.tlf.novell.com>
	<3908561D78D1C84285E8C5FCA982C28F31D8A4C2@ORSMSX106.amr.corp.intel.com>
	<52B013E8020000780010E009@nat28.tlf.novell.com>
	<3908561D78D1C84285E8C5FCA982C28F31D8B8CE@ORSMSX106.amr.corp.intel.com>
	<52B16533020000780010E890@nat28.tlf.novell.com>
Date: Wed, 18 Dec 2013 11:13:38 -0800
X-Google-Sender-Auth: effPggzh9KVeHPg9TBRlMHREbJI
Message-ID: <CA+8MBb+7e03UxmJCnXSDh=8m+9LFT2R3h0v6g-wDWnn=N8vFWg@mail.gmail.com>
Subject: Re: [PATCH] don't select EFI from certain special ACPI drivers
From: Tony Luck <tony.luck@intel.com>
To: "mingo@kernel.org" <mingo@kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 12:04 AM, Jan Beulich <JBeulich@suse.com> wrote:
>>>> On 17.12.13 at 23:34, "Luck, Tony" <tony.luck@intel.com> wrote:
>>>  No, it hasn't. But I explicitly checked the relevant EFI=n and EFI=y
>>> cases.
>>
>> I pushed your patch into my "next" tree - the robots will notice soon and
>> send us e-mail if they find any issues.
>
> Thanks, Tony. I'm afraid though that fixing this only in 3.14 would
> be a little late: Any "select" in a Kconfig results in the user not being
> asked again when that "select" goes away, so people having got EFI
> forcibly enabled in 3.13 and updating their configs to 3.14 would
> then need to remember to manually disable CONFIG_EFI again (of
> course that's already true for anyone using 3.13-rc?, but those
> should mostly be people more knowledgeable than folks just
> consuming final releases).
>
> I think it should generally be the exception to "select" options that
> have visible prompts (i.e. are user configurable).

Ingo: Jan makes a good point that people running "make oldconfig"
may get suckered into selecting CONFIG_EFI when they don't really
need it.  I've not seen any complaints from the robot randconfig testers,
so this patch is:

Acked-by: Tony Luck <tony.luck@intel.com>

Can you push it to Linus before 3.13-final releases?

-Tony
