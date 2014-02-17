Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbaBQBUI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 20:20:08 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:40118 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716AbaBQBUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 20:20:05 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFxxPSdEkmvAP0fJ_3XN2udz=wCi+Yfeg9Kf-TpL349Srg@mail.gmail.com>
References: <1392352954-29905-1-git-send-email-dbanerje@akamai.com>
 <CA+55aFy7yrNuJaFLcLh5-DVFTzuFYeZ_K9s6CNGtemQDCO90mQ@mail.gmail.com>
 <CF26B239.2E7B4%dbanerje@akamai.com> <CA+55aFyiEcMBegoypWVTZXnb4aLj1PD4FRHWV83X2DY=8VHz7w@mail.gmail.com>
 <CF26BC6D.2E80E%dbanerje@akamai.com> <CA+55aFyywOm7pWrX4=04LTEJ6xYK4xDTxGRqes-MOT212PnWPw@mail.gmail.com>
 <CAPXgP12ZUMqgAx6jJK1q7GkQ5r21zNLhLCCH-rN83vzgOsZFYQ@mail.gmail.com> <CA+55aFxxPSdEkmvAP0fJ_3XN2udz=wCi+Yfeg9Kf-TpL349Srg@mail.gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Mon, 17 Feb 2014 02:19:43 +0100
Message-ID: <CAPXgP13oJt5CT=YswPNNM8m9fNOeLLkAmqJF_gVtcg_i=Rk6FA@mail.gmail.com>
Subject: Re: [PATCH] printk: Fix discarding of records
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Banerjee, Debabrata" <dbanerje@akamai.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeff Mahoney <jeffm@suse.com>,
        "dbavatar@gmail.com" <dbavatar@gmail.com>,
        "Hunt, Joshua" <johunt@akamai.com>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 1:57 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sun, Feb 16, 2014 at 4:50 PM, Kay Sievers <kay@vrfy.org> wrote:
>>
>> That should avoid the overflow, yes. I expect it will not print the
>> first line with a prefix, which we probably should.?
>
> Well, it's not printing out the prefix, but it's also not printing out
> the whole first part of the line, so quite frankly, I think that's
> actually "more correct".
>
> After all, it has already skipped the beginning of the line.
> Prepending the prefix, then skipping part of the line, and then
> printing the last part, that sounds truly insane, no?

Yeah, it depends on the idea of what a "line" is; being it a single
printk() call or a reconstructed continuation line, which happens when
printk calls could not be merged for some reason into a single record.

But sure, your patch, it sounds fine to just skip the prefix.

The syslog() dump interface never made any promises, and it is not
used that much anymore today (even dmesg switched away from it since
quite a while).

For the dumpers, who might use that interface to "page" through the
data, not printing the prefix sounds actually like the better option
looking at the stream of pages they ask for.

Kay
