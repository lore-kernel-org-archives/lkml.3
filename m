Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbaGHNFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:05:14 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:43535 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600AbaGHNFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:05:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140708125138.GA4749@infradead.org>
References: <1404124096-21445-1-git-send-email-drysdale@google.com>
 <1404124096-21445-2-git-send-email-drysdale@google.com> <CALCETrU=HLmw9n-DxPkFV1xP5wtzQ7-YF3-uao6YiGZODA9kdw@mail.gmail.com>
 <20140630154928.GB10375@google.com> <CALCETrWJ-rqDo8OvSZWPUt1806gObNtwVHvC4M6kfQgvd3Eg9w@mail.gmail.com>
 <20140708120702.GB30459@infradead.org> <CAD=T17FQEZV+iy91wQAvAdd0PW2tsfjpU7atp-xeatm5sEGz5Q@mail.gmail.com>
 <20140708125138.GA4749@infradead.org>
From: Meredydd Luff <meredydd@senatehouse.org>
Date: Tue, 8 Jul 2014 14:04:45 +0100
Message-ID: <CAD=T17FcSKCkEwGMDtcss0Ye-EwuW4Gd2bmXiVj0YV2JG3xeWQ@mail.gmail.com>
Subject: Re: [PATCH 01/11] fs: add O_BENEATH_ONLY flag to openat(2)
To: Christoph Hellwig <hch@infradead.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        David Drysdale <drysdale@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        LSM List <linux-security-module@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Morris <james.l.morris@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 July 2014 13:51, Christoph Hellwig <hch@infradead.org> wrote:
> Yeah, it won't work for an explicit directory - I was thinking of
> working relative to $CWD.

I think that would sacrifice far too much flexibility. Even without
Capsicum, it would be worthwhile to be able to wire up a static
seccomp-bpf filter to enforce constraints such as "you can open files
under fd#5 for reading, but you can only write to files under fd#6,
and you can't do any global lookups."

Meredydd
