Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759960AbaJ1I2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 04:28:37 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:44765 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335AbaJ1I2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 04:28:32 -0400
MIME-Version: 1.0
In-Reply-To: <20141028051220.GE60814@vmdeb7>
References: <1414005163-3461-1-git-send-email-fransklaver@gmail.com>
	<1414005163-3461-4-git-send-email-fransklaver@gmail.com>
	<20141028051220.GE60814@vmdeb7>
Date: Tue, 28 Oct 2014 09:28:30 +0100
Message-ID: <CAH6sp9N0nrRHZ9GzdhKPEgUAqA58hY8NEjrpDxHQ9a-=ifCHeA@mail.gmail.com>
Subject: Re: [PATCH 3/8] eeepc-laptop: define rfkill notifier nodes only once
From: Frans Klaver <fransklaver@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        acpi4asus-user <acpi4asus-user@lists.sourceforge.net>,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 6:12 AM, Darren Hart <dvhart@infradead.org> wrote:
> On Wed, Oct 22, 2014 at 09:12:38PM +0200, Frans Klaver wrote:
>> The rfkill notifier node names are used in three different places. As a
>> matter of style, it is better to store them somewhere and have the
>> compiler warn us about typos in the function arguments.
>>
>> Signed-off-by: Frans Klaver <fransklaver@gmail.com>
>> ---
>>  drivers/platform/x86/eeepc-laptop.c | 22 +++++++++++++---------
>>  1 file changed, 13 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
>> index 6e3be01..e92ea41 100644
>> --- a/drivers/platform/x86/eeepc-laptop.c
>> +++ b/drivers/platform/x86/eeepc-laptop.c
>> @@ -819,11 +819,15 @@ static int eeepc_new_rfkill(struct eeepc_laptop *eeepc,
>>       return 0;
>>  }
>>
>> +static char EEEPC_RFKILL_NODE_1[] = "\\_SB.PCI0.P0P5";
>> +static char EEEPC_RFKILL_NODE_2[] = "\\_SB.PCI0.P0P6";
>> +static char EEEPC_RFKILL_NODE_3[] = "\\_SB.PCI0.P0P7";
>
> So, out of curiosity, any particular reason for static char[] instead of
> #define? I see both used frequently and didn't see any advice in CodingStyle.

My expectation is that this is more likely to produce a smaller
binary, but I have no measurements on that to back me up.

I was a bit annoyed by the fact that the acpi functions take a char*
instead of a const char*. I would have preferred static const char[]
in any case.

Thanks,
Frans
