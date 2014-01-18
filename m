Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727AbaARX5P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 18:57:15 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:40553 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbaARX5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 18:57:12 -0500
MIME-Version: 1.0
In-Reply-To: <20140118234611.GJ15466@pd.tnic>
References: <1390078081-26030-1-git-send-email-gurligebis@gentoo.org>
	<1390079163.25980.2.camel@x41>
	<CACPM=kVdNm+ZiZsfr1PTVzOBJi+ybOQVs5X=BycEeZxJLVEq_g@mail.gmail.com>
	<20140118221212.GB15543@pd.tnic>
	<CACPM=kUtm0i5qRWGs9yKBMDZ0fFEQ5-US6wdfa+bjh6ZB2ZhOQ@mail.gmail.com>
	<20140118223308.GH15466@pd.tnic>
	<CACPM=kVDpAFSWb3v8zS0+JE2U5C6pSNvqvL+aQ-npLtU05JGrA@mail.gmail.com>
	<20140118234611.GJ15466@pd.tnic>
Date: Sun, 19 Jan 2014 00:57:11 +0100
X-Google-Sender-Auth: 6SV3NDbMPf6yfMcdRgYKkUg7vjo
Message-ID: <CACPM=kXvNHA42yP9oBJX1OoH_c+v9mDX4UaYx9huKsk8FJZHwA@mail.gmail.com>
Subject: Re: [PATCH] Adding hyperv.h to uapi headers
From: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Paul Bolle <pebolle@tiscali.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014/1/19 Borislav Petkov <bp@alien8.de>:
> On Sun, Jan 19, 2014 at 12:24:10AM +0100, Bjarke Istrup Pedersen wrote:
>> I have submitted a v2 patch - does it look better?
>
> If you mean this:
>
>  include/linux/hyperv.h      | 321 +----------------------------------------
>  include/uapi/linux/Kbuild   |   1 +
>  include/uapi/linux/hyperv.h | 344 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 347 insertions(+), 319 deletions(-)
>  create mode 100644 include/uapi/linux/hyperv.h
>
> you've got the rough idea of uapi headers :-).

Yep, that one, thanks :-)

> Whether that makes sense at all in the hyperv case, you'll have to wait
> for the hyperv guys to say something.
>
> What makes me wonder is why do you need to export this now?

To be able to build the kvp deamon, which has been broken since the
UAPI split a few versions ago.

> Because if those userspace hyperv tools would really need the
> definitions in that header, then they never did build before. Which
> would be really stupid. Btw, which userspace hyperv tools do you mean?
> Where are they?

The tool located in tools/hv.
For some reason, this was never fixed, but now my machines started
complaining in dmesg that the kvp deamon should be updated, so I took
a look at it.

/Bjarke

> What am I missing?
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
