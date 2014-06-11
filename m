Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbaFKTqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 15:46:46 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:36804 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaFKTqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 15:46:44 -0400
MIME-Version: 1.0
In-Reply-To: <20140611194452.GA25049@ravnborg.org>
References: <37910a32e3d223a688a2743376bdde8fbdc8ef5c.1402515662.git.luto@amacapital.net>
 <20140611194452.GA25049@ravnborg.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 11 Jun 2014 12:46:23 -0700
Message-ID: <CALCETrUsmvPkJ=FvU=UcZXwuoQMXcKA3fGoofsjZ3U-gZrDtJw@mail.gmail.com>
Subject: Re: [PATCH] x86,build: Fix make -jN modules_install install
To: Sam Ravnborg <sam@ravnborg.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        Michal Marek <mmarek@suse.cz>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 12:44 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Wed, Jun 11, 2014 at 12:41:57PM -0700, Andy Lutomirski wrote:
>> Every few months, I forget why I type:
>>
>> $ sudo make -j12 modules_install && sudo make -j12 install
>>
>> instead of just:
>>
>> $ sudo make -j12 modules_install install
>>
>> I try the latter, it appears to work, and then my machine won't boot
>> because dracut got confused.  This fixes it once and for all: if you
>> ask make to install modules and a kernel, you almost certainly want
>> the modules installed *first* so that your initramfs scripts can
>> find the modules.
>
> Is this problem x86 specific?

I don't know.  But I also don't want to have 'make modules_install
install' on an arch without an install target appear to work, so I
don't know how to do it in the kbuild core.  That is, I don't want to
define an install target; I just want to add a dependency if the
target is already there.

Also, this patch has a repeated ifneq.  I'll fix it in v2.

>
>         Sam



-- 
Andy Lutomirski
AMA Capital Management, LLC
