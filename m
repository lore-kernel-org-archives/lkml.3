Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367AbaKSUk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 15:40:56 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:56865 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756482AbaKSUky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:40:54 -0500
MIME-Version: 1.0
In-Reply-To: <20141119.153136.867017618826698045.davem@davemloft.net>
References: <20141118084745.GT7996@ZenIV.linux.org.uk>
	<CA+55aFxK0wj2LLp0WmhRsBZch8XfoYbzmbEeJaMpt=SDh5GBvw@mail.gmail.com>
	<20141118212307.GU7996@ZenIV.linux.org.uk>
	<20141119.153136.867017618826698045.davem@davemloft.net>
Date: Wed, 19 Nov 2014 12:40:53 -0800
X-Google-Sender-Auth: ZtAx46F2WLnH4CFoJMB-AAtFfO4
Message-ID: <CA+55aFyQR2gOzEDROcWFcQzLvTjOxyJRjFJXJ03JB5knd-Gsgg@mail.gmail.com>
Subject: Re: [RFC] situation with csum_and_copy_... API
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 12:31 PM, David Miller <davem@davemloft.net> wrote:
>
> But that is just my opinion, and yes I do acknowledge that we've had
> serious holes in this area in the past.

The serious holes have generally been exactly in the "upper layers
already check" camp, and then it turns out that some odd ioctl or
other thing ends up doing something odd and interesting.

If Al has actual performance profiles showing that the access_ok() is
a real problem, then fine. As a low-level optimization, I agree with
it. But not as a "let's just drop them, and make the security rules be
non-local and subtle, and require people to know the details of the
whole call-chain".

Seeing a "__get_user()" and just being able to glance up in the same
function and seeing the "access_ok()" is just a good safety net. And
means that people don't have to waste time thinking about or looking
for where the hell the security net really is.

                    Linus
