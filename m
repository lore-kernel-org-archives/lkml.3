Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068AbaKSQht (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:37:49 -0500
Received: from mail-oi0-f45.google.com ([209.85.218.45]:55637 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398AbaKSQhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:37:46 -0500
MIME-Version: 1.0
In-Reply-To: <20141117214305.GC30324@mail.corp.redhat.com>
References: <1416149064-25655-1-git-send-email-borneo.antonio@gmail.com>
	<20141117214305.GC30324@mail.corp.redhat.com>
Date: Thu, 20 Nov 2014 00:37:45 +0800
Message-ID: <CAAj6DX0ePC_3WpMeqEfH0LGaEXThBWJ4pt-h_Rgtb_71L3XAAw@mail.gmail.com>
Subject: Re: [PATCH] HID: i2c-hid: fix race condition reading reports
From: Antonio Borneo <borneo.antonio@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

On Tue, Nov 18, 2014 at 5:43 AM, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
> Hey Antonio,
>
> On Nov 16 2014 or thereabouts, Antonio Borneo wrote:
>> From: Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
>>
>> From: Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
>>
>> Current driver uses a common buffer for reading reports either
>> synchronously in i2c_hid_get_raw_report() and asynchronously in
>> the interrupt handler.
>> There is race condition if an interrupt arrives immediately after
>> the report is received in i2c_hid_get_raw_report(); the common
>> buffer is modified by the interrupt handler with the new report
>> and then i2c_hid_get_raw_report() proceed using wrong data.
>>
>> Fix it by using a separate buffers for asynchronous reports.
>>
>> Signed-off-by: Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
>> [Antonio Borneo: cleanup and rebase to v3.17]
>> Signed-off-by: Antonio Borneo <borneo.antonio@gmail.com>
>> Cc: stable@vger.kernel.org
>
> For your next submission, when you want a patch to go in stable, put CC
> here, but please do not CC the actual mail to stable@. Stable should receive
> either mails which are already in Linus' tree, or which refer a commit
> in Linus' tree in case it does not applies smoothly.
>
> [keeping stable@ here to show them that this one should not get picked
> right now]

I agree with you to lower the noise in -stable, even if Greg does not
feel annoyed.
I'll take care in the future.

>
>> ---
>>
>> Hi Jiri, Benjamin,
>>
>> I think this patch should also go through linux-stable.
>> Confirmation from our side is welcome.
>
> I think the patch is definitively valuable. However, my personal taste
> would go for having a new .rawbuf buffer and use it in
> i2c_hid_get_raw_report(). The rationale would be that it's actually
> i2c_hid_get_raw_report() which is problematic, not the generic irq
> handling. Also I prefer rawbuf to irqinbuf.
>
> I am perfectly aware that this is just bikeshedding, so if changing the
> patch is too cumbersome (looks like Jean-Baptiste is involved), and if
> Jiri agree, this can go into the hid tree with my reviewed-by.
>
> I am fine having this version or the rawbuf one in stable BTW.

No major issue changing the patch in line with your suggestion; just
some offline work to get also Jean-Baptiste check and approve it.
I'll send shortly a V2 that adds rawbuf instead of irqinbuf.
I will not add your "reviewed-by" since the code in V2 is quite
different than V1.

Thanks!
Antonio
