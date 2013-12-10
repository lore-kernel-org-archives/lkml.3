Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab3LJPCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:02:17 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:38132 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693Ab3LJPB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:01:56 -0500
MIME-Version: 1.0
In-Reply-To: <1386658724.1752.19.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
References: <1386614601-9453-1-git-send-email-natg@google.com>
	<1386615608.1752.4.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
	<CAGmqidkxoi9EEe0uC18QQUXwjFP1e_1MXL7VPk+NtU-Ta6FGUg@mail.gmail.com>
	<52A633B4.9000307@cogentembedded.com>
	<1386623253.1752.6.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
	<1386658724.1752.19.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
Date: Tue, 10 Dec 2013 07:01:55 -0800
Message-ID: <CAGmqidnusPSYt9GHfQVs7SP620jyEN=Aicr1jS3Esb9C5Ov2wA@mail.gmail.com>
Subject: Re: [PATCH] net-tg3: Initialize REG_BASE_ADDR at PCI config offset
 120 to 0
From: Natarajan Gurumoorthy <natg@google.com>
To: Michael Chan <mchan@broadcom.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>, nsujir@broadcom.com,
        netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael,
     The only time I see crashes is after the tg3 driver has been
loaded into the system. I our use case we are poking around
/sys/devices/pcixxxx/......../config.
     I guess you will incorporate the original patch into the driver
and we can abandon this patch.

Regards
Nat


On Mon, Dec 9, 2013 at 10:58 PM, Michael Chan <mchan@broadcom.com> wrote:
> On Mon, 2013-12-09 at 13:07 -0800, Michael Chan wrote:
>> On Tue, 2013-12-10 at 00:18 +0300, Sergei Shtylyov wrote:
>> > >        We had crashes when the PCI config space got scanned via
>> > > /sys/devices/pcixxxx/....../config.
>> >
>> > > I agree that this fix will not help if the scan happens before the tg3
>> > > driver gets loaded.
>> >
>> >     Then perhaps a better place for such fixup would be a PCI quirk?
>> >
>> Yes, I agree.  Thanks.
>>
>
> On second thought, I think your original patch should be sufficient and
> we don't need to add the PCI quirk to cover so many devices.  The reason
> is that indirect access needs to be explicitly enabled in the
> MISC_HOST_CTRL (0x68) register.  The default value for register 0x68
> should have indirect access disabled.
>
> Nat, does this match what you're seeing?  Did you ever see any system
> crash before tg3 loads?
>



-- 
Regards
Nat Gurumoorthy AB6SJ
