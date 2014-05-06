Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678AbaEFOxY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 10:53:24 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:63714 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757129AbaEFOxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 10:53:22 -0400
MIME-Version: 1.0
In-Reply-To: <CAJfpegvWOzd01tW5nRfWKW7EoBgPD8rudODJJm5OqxPd5Pd7uA@mail.gmail.com>
References: <20140430023142.GN18016@ZenIV.linux.org.uk>
	<CA+55aFypNxsjJTq_rc2Jx4p_3scJo2VWdt=e8n-9eJ-ZQphnpQ@mail.gmail.com>
	<20140430091515.GB3113@tucsk.piliscsaba.szeredi.hu>
	<20140502055127.GH18016@ZenIV.linux.org.uk>
	<CAELBmZC9g91+8B6HsnbmwWJBmiYXgMW6QfdREJYyd8EP5RpRpQ@mail.gmail.com>
	<20140502210813.GB32527@tucsk.piliscsaba.szeredi.hu>
	<CA+55aFzbtGwxTf_d97pSLc4hAciErGDdkOSzLkpt_hP-UmLPWg@mail.gmail.com>
	<20140502224022.GJ18016@ZenIV.linux.org.uk>
	<20140503042604.GM18016@ZenIV.linux.org.uk>
	<20140503182110.GN18016@ZenIV.linux.org.uk>
	<20140504062915.GQ18016@ZenIV.linux.org.uk>
	<CAJfpegvWOzd01tW5nRfWKW7EoBgPD8rudODJJm5OqxPd5Pd7uA@mail.gmail.com>
Date: Tue, 6 May 2014 07:53:19 -0700
X-Google-Sender-Auth: pjNnxRQXpCOCX8pTdu1Tho5x4as
Message-ID: <CA+55aFxeVn2Xfa4Dwt2+GzAL7MxV3UK-jMf-+Nvm2HE9hETS9w@mail.gmail.com>
Subject: Re: dcache shrink list corruption?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 6, 2014 at 3:17 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> Patches look okay to me.
>
> Reviewed-by: Miklos Szeredi <mszeredi@suse.cz>
>
>>       dentry_kill(): don't try to remove from shrink list
>
> Backport of this to 3.12 was tested by IBM and apparently fixes the
> issue for them (I didn't backport the cleanup patches only the actual
> fix)

Ok, good.

>>       don't remove from shrink list in select_collect()
>
> I've also asked them to test this, although I think this is even
> harder to trigger.  But at least the non-racy codepaths need to be
> tested.

I'll be incommunicado all next week, so I think I should merge this
all now rather than later.

Al, mind doing a real pull request?

                Linus
