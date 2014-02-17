Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbaBQAvD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 19:51:03 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:44371 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbaBQAvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 19:51:00 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyywOm7pWrX4=04LTEJ6xYK4xDTxGRqes-MOT212PnWPw@mail.gmail.com>
References: <1392352954-29905-1-git-send-email-dbanerje@akamai.com>
 <CA+55aFy7yrNuJaFLcLh5-DVFTzuFYeZ_K9s6CNGtemQDCO90mQ@mail.gmail.com>
 <CF26B239.2E7B4%dbanerje@akamai.com> <CA+55aFyiEcMBegoypWVTZXnb4aLj1PD4FRHWV83X2DY=8VHz7w@mail.gmail.com>
 <CF26BC6D.2E80E%dbanerje@akamai.com> <CA+55aFyywOm7pWrX4=04LTEJ6xYK4xDTxGRqes-MOT212PnWPw@mail.gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Mon, 17 Feb 2014 01:50:39 +0100
Message-ID: <CAPXgP12ZUMqgAx6jJK1q7GkQ5r21zNLhLCCH-rN83vzgOsZFYQ@mail.gmail.com>
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

On Mon, Feb 17, 2014 at 1:41 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sun, Feb 16, 2014 at 4:19 PM, Banerjee, Debabrata
> <dbanerje@akamai.com> wrote:

> The third loop does *not* start again from the first line! It
> *continues* from where the second loop ended. Which is exactly why
> clearing "prev" is *wrong*. Because the *last* line that the second
> loop processes is indeed the previous line before the *first* line
> that the third loop starts processing.
>
> No, I haven't tested my patch, and maybe it's broken for some subtle
> reason I'm missing too.

That should avoid the overflow, yes. I expect it will not print the
first line with a prefix, which we probably should.?

Kay
