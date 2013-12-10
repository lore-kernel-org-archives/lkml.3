Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842Ab3LJGIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 01:08:34 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:53086 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab3LJGIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 01:08:30 -0500
MIME-Version: 1.0
X-Originating-IP: [218.164.103.91]
In-Reply-To: <CAFRkauCX+dLNiuoy7bPWO_ZE06OhorqYkkGh5pc8L3XyqNA-rg@mail.gmail.com>
References: <1384589723.7840.1.camel@phoenix>
	<1386125959.1974.309@driftwood>
	<CAFRkauAzR=BqJGrMzN0i-tvi5mcQvyB9Kihk0YvxMpk=SWGvFA@mail.gmail.com>
	<20131209064654.GA20485@kroah.com>
	<CAFRkauCQdOyWbck+WtmNxtnenKyPAFNcqqUgcGSb1kAqj56sYA@mail.gmail.com>
	<20131209090530.GA4586@kroah.com>
	<CAFRkauCX+dLNiuoy7bPWO_ZE06OhorqYkkGh5pc8L3XyqNA-rg@mail.gmail.com>
Date: Tue, 10 Dec 2013 14:08:29 +0800
Message-ID: <CAFRkauBwUoE9109Oq9cgG71uOw5Uc+zZyDWsuCf47oLk-a2ngQ@mail.gmail.com>
Subject: Re: [PATCH] devtmpfs: Calling delete_path() only when necessary
From: Axel Lin <axel.lin@ingics.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>
Cc: Rob Landley <rob@landley.net>, Al Viro <viro@zeniv.linux.org.uk>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/12/9 Axel Lin <axel.lin@ingics.com>:
> 2013/12/9 Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
>> On Mon, Dec 09, 2013 at 04:54:29PM +0800, Axel Lin wrote:
>>> 2013/12/9 Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
>>> > On Wed, Dec 04, 2013 at 02:44:14PM +0800, Axel Lin wrote:
>>> >> 2013/12/4 Rob Landley <rob@landley.net>:
>>> >> > On 11/16/2013 02:15:23 AM, Axel Lin wrote:
>>> >> >>
>>> >> >> The deleted variable is always 1 in current code.
>>> >> >> Initialize deleted variable to be 0, so delete_path() will be called only
>>> >> >> when
>>> >> >> necessary.
>>> >> >>
>>> >> >> Signed-off-by: Axel Lin <axel.lin@ingics.com>
>>> >> >
>>> >> >
>>> >> > I'm not seeing this in linux-next, or a reply on the web archive. Assuming
>>> >> > nobody's objected to this, you might want to forward it to
>>> >> > trivial@kernel.org.
>>> >> >
>>> >> > That said, you could describe what it _does_ a little more?
>>> >>
>>> >> I was expecting Greg to pick up this patch.
>>> >>
>>> >> I thought the description is pretty clear.
>>> >> What the patch does is changing the init value of deleted variable to 0.
>>> >> The intention of this change is to avoid unnecessary delete_path() call.
>>> >
>>> > I agree the logic is a bit odd here, but are you seeing an "unnecessary"
>>> > delete_path() call happening?  The code has always been like this from
>>> > what I can tell...
>>>
>>> Honestly, I havn't see the "unnecessary" delete_path() call happening druing my
>>> test. I look at the code when I was debugging a hangup issue.
>>> (In the end, I think the issue is not related to the devtmpfs code.)
>>> But I found the logic for the deleted variable looks odd.
>>> There are below possible (unlikely) case:
>>> When strchr(nodename, '/') != 0 and
>>> 1. If dentry->d_inode is NULL
>>> 2. vfs_getattr returns error
>>> 3. vfs_unlink returns error except -ENOENT.
>>>
>>> In these cases, delete_path() will fail anyway.
>>>
>>> Although this is a unlikely case, and I know the code is there since initial
>>> commit. But I think it's still good to fix it.
>>
>> Have you tested your patch to verify nothing breaks?
> Yes. I have this patch in my local build image since the day I sent the patch.
Hi Greg,
If you want more testing for this patch to ensure nothing break,
I think maybe Fengguang can also help to test it.

Hi, Fengguang
Can you help to add this patch to your test systems?
It's a one-line change, you can find the patch at
https://patchwork.kernel.org/patch/3192361/

Regards,
Axel
