Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbaKCRFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:05:54 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:57897 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391AbaKCRFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:05:52 -0500
MIME-Version: 1.0
In-Reply-To: <20141103083447.GA8617@infradead.org>
References: <4e8f7a1abcf5e0527ef8968143b2d0fcae48f5f4.1414658968.git.e@nanocritical.com>
	<5452B241.5010603@amacapital.net>
	<CA+55aFw5xL4jk_=oJK1tTwpGG5Y_cibK3y9L=VvYx9jugqrUuQ@mail.gmail.com>
	<CA+55aFw5GqoTF3r=OK+pmdbvm_sdDvkeZMdwk_3TdSg2eyr7MQ@mail.gmail.com>
	<CALCETrUpMOX-0=7Pdv_etjzOjZVH4nrtiqCdWYqtM-ECKFrsYA@mail.gmail.com>
	<20141031084220.GA29085@infradead.org>
	<CALCETrXdPV5+qJ438Ky=tfBiEmqeeTYNuukQS7TcjbEwDgzwGQ@mail.gmail.com>
	<CA+55aFxUdjsm0gC0ULaOq_RhDLjWp=RDOE_O9qXdQRPqJUrZVA@mail.gmail.com>
	<20141103083447.GA8617@infradead.org>
Date: Mon, 3 Nov 2014 09:05:51 -0800
X-Google-Sender-Auth: -rmga4xqMM-gn50RAiEzDCNsi24
Message-ID: <CA+55aFz_C4nVX580nvvAngsB3U9oMnCGPDs8Yo1Qpx=XagcpMA@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow open(dir, O_TMPFILE|..., 0) with mode 0
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Rannaud <e@nanocritical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2014 at 12:34 AM, Christoph Hellwig <hch@infradead.org> wrote:
>
> That doesn't help because we explicitly reject O_RDONLY when combined
> with O_TMPFILE.

You obviously cannot actually have a read-only file descriptor with
O_TMPFILE, unless all you care about is a zero-sized file with no
contents.

That's why people are talking about things like downgrading the file
*after* filling it, using sealing.

                  Linus
