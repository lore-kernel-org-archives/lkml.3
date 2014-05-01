Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbaEAX5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 19:57:35 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:55977 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbaEAX5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 19:57:34 -0400
MIME-Version: 1.0
In-Reply-To: <20140501235135.GE18016@ZenIV.linux.org.uk>
References: <CALCETrUXbS4BMWMd0XXgFqyvmpu+WML840_mzbPiov8WmaA=Xw@mail.gmail.com>
 <20140501223432.GD18016@ZenIV.linux.org.uk> <CALCETrXaXsVxaT3TH-CC8DKyDU7k=i9Y5PqBqaSDnH+2rr5E2A@mail.gmail.com>
 <20140501235135.GE18016@ZenIV.linux.org.uk>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 1 May 2014 16:57:13 -0700
Message-ID: <CALCETrXhVKq33-KWLMVxPtCZgHddKsxCOQX9F-LGerXsCrLH5Q@mail.gmail.com>
Subject: Re: Connecting to sockets on MNT_READONLY mounts?
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 1, 2014 at 4:51 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Thu, May 01, 2014 at 04:00:49PM -0700, Andy Lutomirski wrote:
>> On Thu, May 1, 2014 at 3:34 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> > On Thu, May 01, 2014 at 03:20:00PM -0700, Andy Lutomirski wrote:
>> >> Is it supposed to work?
>> >
>> > Why the hell not?  Same as opening a device node on r/o filesystem for
>> > write, or doing the same with FIFO.
>>
>> You can't bind a socket on a read-only fs, so I thought it was a fair question.
>>
>> I'll write a patch to add MS_NOIPCCONNECT and MNT_NOIPCCONNECT to
>> block connect on unix sockets and open on fifos.  This will be useful
>> for sandboxes that want to prevent sandboxed programs from accessing
>> undesirable parts of the outside world.
>
> Sigh...  Don't expose those FIFOs et.al. to them, then.
> mount --bind /dev/null <pathname>
> as part of setting the sucker up.  And if you *are* blindly exposing the
> host filesystems to them wholesale, sockets and fifos are the least of your
> problems, even if you do that read-only.

Why?

Suppose I bind-mount /usr into a private namespace with
nosuid,nodev,ro.  How can you use it to attack anything?  The only
thing I've thought of is to open fifos and connect to sockets.  I'm
assuming that there's a pid namespace blocking ptrace and such and a
network namespace blocking abstract sockets.

--Andy
