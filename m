Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642AbaAaSpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 13:45:53 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:33103 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236AbaAaSpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 13:45:52 -0500
MIME-Version: 1.0
In-Reply-To: <52EBE62E.70102@linux.intel.com>
References: <20140131025453.B594B660CA3@gitolite.kernel.org>
	<20140131175009.GA27231@redhat.com>
	<52EBE62E.70102@linux.intel.com>
Date: Fri, 31 Jan 2014 10:45:51 -0800
X-Google-Sender-Auth: qePET27NBqnfk2iW85UmEk425vM
Message-ID: <CA+55aFwcgGPb=5cTnkKpP4vH2kqCCvxGteZT58efHhg3aJjcfQ@mail.gmail.com>
Subject: Re: x86, x32: Correct invalid use of user timespec in the kernel
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 10:06 AM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>
> My feeling is that {get,put}_compat_timespec() should at the very least
> have leading underscores to flag it as a low-level function, but better
> suggestions would be appreciated.

Why not just remove it entirely, and change all users to
compat_[get|set]_timespec (same for timeval etc, of course).

After all, compat_*_time*() does fall back cleanly for non-x32 cases.
And sure, maybe that particular code is never *needed* for x32
support, but the overhead is generally zero (since in most cases X32
isn't even configured), or very low anyway. So the upside of having
two subtly incompatible interfaces is very dubious, no?

                Linus
