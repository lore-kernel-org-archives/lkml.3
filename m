Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbaEAXBM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 19:01:12 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:61516 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbaEAXBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 19:01:09 -0400
MIME-Version: 1.0
In-Reply-To: <20140501223432.GD18016@ZenIV.linux.org.uk>
References: <CALCETrUXbS4BMWMd0XXgFqyvmpu+WML840_mzbPiov8WmaA=Xw@mail.gmail.com>
 <20140501223432.GD18016@ZenIV.linux.org.uk>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 1 May 2014 16:00:49 -0700
Message-ID: <CALCETrXaXsVxaT3TH-CC8DKyDU7k=i9Y5PqBqaSDnH+2rr5E2A@mail.gmail.com>
Subject: Re: Connecting to sockets on MNT_READONLY mounts?
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 1, 2014 at 3:34 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Thu, May 01, 2014 at 03:20:00PM -0700, Andy Lutomirski wrote:
>> Is it supposed to work?
>
> Why the hell not?  Same as opening a device node on r/o filesystem for
> write, or doing the same with FIFO.

You can't bind a socket on a read-only fs, so I thought it was a fair question.

I'll write a patch to add MS_NOIPCCONNECT and MNT_NOIPCCONNECT to
block connect on unix sockets and open on fifos.  This will be useful
for sandboxes that want to prevent sandboxed programs from accessing
undesirable parts of the outside world.

--Andy
