Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbaBQA57 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 19:57:59 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:52363 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbaBQA55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 19:57:57 -0500
MIME-Version: 1.0
In-Reply-To: <CAPXgP12ZUMqgAx6jJK1q7GkQ5r21zNLhLCCH-rN83vzgOsZFYQ@mail.gmail.com>
References: <1392352954-29905-1-git-send-email-dbanerje@akamai.com>
	<CA+55aFy7yrNuJaFLcLh5-DVFTzuFYeZ_K9s6CNGtemQDCO90mQ@mail.gmail.com>
	<CF26B239.2E7B4%dbanerje@akamai.com>
	<CA+55aFyiEcMBegoypWVTZXnb4aLj1PD4FRHWV83X2DY=8VHz7w@mail.gmail.com>
	<CF26BC6D.2E80E%dbanerje@akamai.com>
	<CA+55aFyywOm7pWrX4=04LTEJ6xYK4xDTxGRqes-MOT212PnWPw@mail.gmail.com>
	<CAPXgP12ZUMqgAx6jJK1q7GkQ5r21zNLhLCCH-rN83vzgOsZFYQ@mail.gmail.com>
Date: Sun, 16 Feb 2014 16:57:56 -0800
X-Google-Sender-Auth: vymOzSOTIa-o8DlmXqU1DM0Y6Cw
Message-ID: <CA+55aFxxPSdEkmvAP0fJ_3XN2udz=wCi+Yfeg9Kf-TpL349Srg@mail.gmail.com>
Subject: Re: [PATCH] printk: Fix discarding of records
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Kay Sievers <kay@vrfy.org>
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

On Sun, Feb 16, 2014 at 4:50 PM, Kay Sievers <kay@vrfy.org> wrote:
>
> That should avoid the overflow, yes. I expect it will not print the
> first line with a prefix, which we probably should.?

Well, it's not printing out the prefix, but it's also not printing out
the whole first part of the line, so quite frankly, I think that's
actually "more correct".

After all, it has already skipped the beginning of the line.
Prepending the prefix, then skipping part of the line, and then
printing the last part, that sounds truly insane, no?

This isn't even new behaviour - that's how it all worked back when it
was all a byte stream (except then it was *purely* about that byte
stream, so it could literally start anywhere in the line, including
partial prefixes etc).

Of course, an alternative approach - if we really want to always have
full lines - is to skip any partial lines at the beginning of the
output entirely.  So not just drop the prefix, but drop the LOG_CONT
parts too. But since (as mentioned), we've never really guaranteed
that the log starts at line boundaries, I'm not sure what the
advantage would really be..

         Linus
