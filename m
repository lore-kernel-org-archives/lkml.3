Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761518Ab3LIVDj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 16:03:39 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:50767 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756037Ab3LIVDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 16:03:38 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1312092154350.24835@pobox.suse.cz>
References: <CAMe9rOo9sUQiusm8u=eFDnxYz37Cczd+97M9in=P2mNWXpH5pQ@mail.gmail.com>
	<alpine.LNX.2.00.1312092154350.24835@pobox.suse.cz>
Date: Mon, 9 Dec 2013 13:03:37 -0800
Message-ID: <CAMe9rOr06QeTGe4OC5_JYtfdziYj8NsRgS5=arEJY3BTqeLMVg@mail.gmail.com>
Subject: Re: [PATCH] binfmt_elf: fix PIE load with randomization disabled
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Boyer <jwboyer@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 9, 2013 at 12:57 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Mon, 9 Dec 2013, H.J. Lu wrote:
>
>> Normally, a PIE executable has zero virtual address on the first PT_LOAD
>> segment and kernel will load such executable at random address when
>> randomization is enabled.  If randomization is disabled, kernel will load
>> it at a fixed address.  But if a PIE executable has non-zero virtual
>> address on the first PT_LOAD segment, kernel will load such executable
>> at the non-zero virtual address when randomization is enabled. But when
>> randomization is disabled, kernel ignores the non-zero virtual address
>> at the non-zero virtual address when randomization is enabled.
>
> Hmm ... isn't actually this the thing that needs to be fixed instead?
>
> IOW, when randomization is enabled, is there a reason not to load on
> randomized address? (even if the first PT_LOAD segment has non-zero
> vaddr?)

No, please don't do that.  Normally, PIE has zero load address and kernel
can load it anywhere.  There are multiple reasons why PIE has non-zero
load address.  Saying you need to load a program above 4GB under x86-64,
you can't do that with normal dynamic executable.  PIE with non-zero load
address is the only way to do that on x86-64.

>> But when randomization is disabled, kernel ignores the non-zero virtual
>> address on the first PT_LOAD segment and loads it at the fixed address.
>> This patch makes kernel consistent by loading PIE executable with
>> non-zero virtual address at the non-zero virtual address, regardless if
>> randomization is enabled or disabled.
>


-- 
H.J.
