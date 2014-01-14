Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbaANAW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:22:58 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:39041 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbaANAWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:22:50 -0500
MIME-Version: 1.0
In-Reply-To: <20140113233006.GP10323@ZenIV.linux.org.uk>
References: <804857E1F29AAC47BF68C404FC60A1846542A6B2@ORSMSX105.amr.corp.intel.com>
	<20140113233006.GP10323@ZenIV.linux.org.uk>
Date: Tue, 14 Jan 2014 07:22:49 +0700
X-Google-Sender-Auth: U4znj5OJaTouNS5rfOcotlXspVI
Message-ID: <CA+55aFy_V8ze2CPmHY0Ga-K-DX_SATVu-Tb=_nKq_1Rb5WqaUQ@mail.gmail.com>
Subject: Re: bug in sscanf()?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>, Alexey Dobriyan <adobriyan@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 6:30 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Comments?

Do we have actual users of this? Because I'd almost be inclined to say
"we just don't support field widths on sscanf() and will warn" unless
there are users.

We've done that before. The kernel has various limited functions. See
the whole snprint() issue with %n, which we decided that supporting
the full semantics was actually a big mistake and we actively
*removed* code that had been misguidedly added just because people
thought we should do everything a standard user library does..

Limiting our problem space is a *good* thing, not a bad thing.

If it's possible, of course, and we don't have nasty users.

           Linus
