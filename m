Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbaKERKN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:10:13 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:53149 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaKERKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:10:11 -0500
MIME-Version: 1.0
In-Reply-To: <CALCETrXDq_k+7w0RXJMpPv36w_Jf+3rJiihfMxS=TFo8rq95ew@mail.gmail.com>
References: <CA+55aFw5xL4jk_=oJK1tTwpGG5Y_cibK3y9L=VvYx9jugqrUuQ@mail.gmail.com>
	<CA+55aFw5GqoTF3r=OK+pmdbvm_sdDvkeZMdwk_3TdSg2eyr7MQ@mail.gmail.com>
	<CALCETrUpMOX-0=7Pdv_etjzOjZVH4nrtiqCdWYqtM-ECKFrsYA@mail.gmail.com>
	<20141031084220.GA29085@infradead.org>
	<CALCETrXdPV5+qJ438Ky=tfBiEmqeeTYNuukQS7TcjbEwDgzwGQ@mail.gmail.com>
	<CA+55aFxUdjsm0gC0ULaOq_RhDLjWp=RDOE_O9qXdQRPqJUrZVA@mail.gmail.com>
	<20141103083447.GA8617@infradead.org>
	<CALCETrUjbfSiPUvTzTfOVAbxy5dy3PpKnnC+h4P_+FOeibTgDw@mail.gmail.com>
	<CAH_=xobsXZq9M-vXDN_+cQmvRLtgPOzHMbrnzsEToMgLD5CoxA@mail.gmail.com>
	<CA+55aFw29MUj+w46yneut2yxXOH1RQmDud5KL8V-SPyPWm1WqA@mail.gmail.com>
	<20141105082721.GB19607@infradead.org>
	<CAH_=xoa36gKcEpi8mSE9cedghqE4FhBCVMQNPV_1qDyk1Bb2ng@mail.gmail.com>
	<CALCETrXDq_k+7w0RXJMpPv36w_Jf+3rJiihfMxS=TFo8rq95ew@mail.gmail.com>
Date: Wed, 5 Nov 2014 09:10:10 -0800
X-Google-Sender-Auth: 3XpXZXjUDjUUMHe3VN3clnwr0kg
Message-ID: <CA+55aFx6iqZJNz08yu=nB-drU0Z2D4KM7d1T9zcz3N3NQFEjbQ@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow open(dir, O_TMPFILE|..., 0) with mode 0
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Eric Rannaud <e@nanocritical.com>, Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2014 at 7:32 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> I have no idea whether it's a security risk, but it's a serious "wtf?!?" risk.

Yeah. And considering that the only apparently user of this read-only
O_TMPFILE interface doesn't actually need it anyway because it carries
around the whole "read-only to the client" information independently,
I think the issue is moot. We don't need zero-sized read-only
O_TMPFILE files.

                      Linus
