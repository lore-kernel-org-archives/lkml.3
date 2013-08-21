Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab3HUSgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 14:36:09 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:42864 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab3HUSgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 14:36:07 -0400
MIME-Version: 1.0
In-Reply-To: <521504D7.7090204@wwwdotorg.org>
References: <20130820224032.GA20491@kroah.com>
	<521504D7.7090204@wwwdotorg.org>
Date: Wed, 21 Aug 2013 11:36:05 -0700
X-Google-Sender-Auth: QJdwc7yZV9irGT48uBkcwtJYs98
Message-ID: <CA+55aFxMkQoJAJd2=XyJu0NX2dG3mX=obx=YL6YXatLg4S=-Vw@mail.gmail.com>
Subject: Re: Proposed stable release changes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        Guenter Roeck <linux@roeck-us.net>, Hugh Dickins <hughd@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Borislav Petkov <bp@alien8.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 11:20 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 08/20/2013 04:40 PM, Greg KH wrote:
>
> Presumably the idea is that much useful testing only happens on -rc
> kernels rather than linux-next or arbitrary points in Linus' tree.

Linux-next gets little to no testing outside of compiles.

And I don't think the -rc releases are all that important either. The
important part is to _wait_. Not "wait for an -rc". There are
reasonable number of developers and users who actually run git
kernels, just because they want to help. At rc points, you tend to get
a few more of those.

In contrast, when patches get moved from the development tree to
stable within a day or two, that patch has gotten basically _no_
testing in some cases (or rather, it's been tested to fix the thing it
was supposed to fix, but then there are surprising new problems that
it introduces that nobody even though about, and wasn't tested for).

So I don't think "is in an rc release" is the important thing. I think
"has been in the standard git tree for at least a week" is what we
should aim for.

Will it catch all cases? Hell no. We don't have *that* many people who
run git kernels, and even people who do don't tend to update daily
anyway. But at least this kind of embarrassing "We found a bug within
almost minutes of it hitting mainline" should not make it into stable.

              Linus
