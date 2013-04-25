Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525Ab3DYOiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 10:38:25 -0400
Received: from mail-vb0-f47.google.com ([209.85.212.47]:50090 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084Ab3DYOiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 10:38:24 -0400
MIME-Version: 1.0
In-Reply-To: <1366777569-23192-3-git-send-email-hpa@zytor.com>
References: <1366777569-23192-1-git-send-email-hpa@zytor.com>
	<1366777569-23192-3-git-send-email-hpa@zytor.com>
Date: Thu, 25 Apr 2013 07:38:23 -0700
X-Google-Sender-Auth: obGpENhVg-gv366N4ydkdm6WJv8
Message-ID: <CA+55aFwkEMAkvZFdeQm2PKQD1xgFBfVa+kTwJXGmWXoDqDp7xQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] random: Account for entropy loss due to overwrites
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, DJ Johnston <dj.johnston@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This doesn't work AT ALL. You even hint at the reason why in your message.

On Tue, Apr 23, 2013 at 9:26 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> As such, this conservatism seems more than justified.  Note, however,
> that attempting to add one bit of entropy will never succeed; nor will
> two bits unless the pool is completely empty.  These roundoff
> artifacts could be improved by using fixed-point arithmetic and adding
> some number of fractional entropy bits.

Take a look at "add_interrupt_randomness()". Hmm..

                Linus
