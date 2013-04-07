Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934219Ab3DGRsO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 13:48:14 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:57723 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934193Ab3DGRsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 13:48:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAB=NE6UgJoQzwrCzdc0P04vSRHGK4FtNEcJTBnN0nsQSKDviEw@mail.gmail.com>
References: <1365302138-19736-1-git-send-email-mcgrof@do-not-panic.com> <CAB=NE6UgJoQzwrCzdc0P04vSRHGK4FtNEcJTBnN0nsQSKDviEw@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Sun, 7 Apr 2013 10:47:49 -0700
X-Google-Sender-Auth: AEbp0c4FHpUsGquvsOQpMtkk1eE
Message-ID: <CAB=NE6XLzzm8fDL=UznJGARHGsAT1OMTpmV4vtD6j5JoHQiv6g@mail.gmail.com>
Subject: Re: [PATCH 0/3] backports: adds regulator and media susbsystems
To: "backports@vger.kernel.org" <backports@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 6, 2013 at 7:37 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> On Sat, Apr 6, 2013 at 7:35 PM, Luis R. Rodriguez
> <mcgrof@do-not-panic.com> wrote:
>> Segmentation fault
>> make[8]: *** [/home/mcgrof/tmp/build/compat/core.o] Error 139

I've narrowed the segfault to a core.c file with just:

#include <linux/async.h>
#include <linux/module.h>

void poo(void)
{
}
EXPORT_SYMBOL_GPL(poo);

Removing asynch.h fixes it. Doing this on an standalone module works

  Luis
