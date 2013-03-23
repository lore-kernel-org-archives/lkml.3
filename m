Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819Ab3CWRrP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 13:47:15 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:51296 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab3CWRrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 13:47:14 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.02.1303231537190.2097@blackhole.lst.de>
References: <alpine.LNX.2.02.1303231531520.2097@blackhole.lst.de>
	<alpine.LNX.2.02.1303231537190.2097@blackhole.lst.de>
Date: Sat, 23 Mar 2013 10:47:13 -0700
X-Google-Sender-Auth: W_5F4wjUGTE2QvnSyUxYRc6HQ-Q
Message-ID: <CA+55aFx_6_dwYNGkZHvtZ=HgCjECrj-9nSWMJsH8VSHtfVMp7A@mail.gmail.com>
Subject: Re: [PATCH 1/2] KMS: fix EDID detailed timing vsync parsing
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Torsten Duwe <torsten@lst.de>
Cc: David Airlie <airlied@linux.ie>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 23, 2013 at 7:38 AM, Torsten Duwe <torsten@lst.de> wrote:
>
> EDID spreads some values across multiple bytes; bit-fiddling is needed
> to retrieve these. The current code to parse "detailed timings" has a
> cut&paste error that results in a vsync offset of at most 15 lines
> instead of 63.

Yeah, it clearly just mixes the bits together with that bitwise rather
than actually spreading them out correctly.

Applied.

                  Linus
