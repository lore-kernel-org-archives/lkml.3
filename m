Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbaFYER2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 00:17:28 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:33886 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbaFYER0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 00:17:26 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1406242056330.29780@tomh.mtv.corp.google.com>
References: <alpine.DEB.2.02.1406242056330.29780@tomh.mtv.corp.google.com>
Date: Tue, 24 Jun 2014 21:17:25 -0700
X-Google-Sender-Auth: RDgEQ4IzWD_tN9TioVI48wzL4M4
Message-ID: <CA+55aFxyZP_jXT-bLyFjJMp4WfVZp5vFtpu+-6_qCi46xkceQg@mail.gmail.com>
Subject: Re: [PATCH] tcp: fix setting csum_start in tcp_gso_segment
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tom Herbert <therbert@google.com>
Cc: David Miller <davem@davemloft.net>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 9:03 PM, Tom Herbert <therbert@google.com> wrote:
>
> It looks like a likely culprit is that SKB_GSO_CB()->csum_start is
> not set correctly when doing non-scatter gather. We are using
> offset as opposed to doffset.
>
> Reported-by: Dave Jones <davej@redhat.com>

DaveJ, I think you triggered this in five minutes on your box, and I
don't recall seeing anybody else reporting the oops (and google
doesn't find anything in the last month). So it's presumably somewhat
hw-specific. Does this fix the problem?

               Linus
