Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbaFYSxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 14:53:04 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37246 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbaFYSxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 14:53:01 -0400
Date: Wed, 25 Jun 2014 11:52:58 -0700 (PDT)
Message-Id: <20140625.115258.1446490446271879078.davem@davemloft.net>
To: davej@redhat.com
Cc: torvalds@linux-foundation.org, therbert@google.com,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tcp: fix setting csum_start in tcp_gso_segment
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140625141052.GA1096@redhat.com>
References: <alpine.DEB.2.02.1406242056330.29780@tomh.mtv.corp.google.com>
	<CA+55aFxyZP_jXT-bLyFjJMp4WfVZp5vFtpu+-6_qCi46xkceQg@mail.gmail.com>
	<20140625141052.GA1096@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Jun 2014 11:53:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Jones <davej@redhat.com>
Date: Wed, 25 Jun 2014 10:10:52 -0400

> On Tue, Jun 24, 2014 at 09:17:25PM -0700, Linus Torvalds wrote:
>  > On Tue, Jun 24, 2014 at 9:03 PM, Tom Herbert <therbert@google.com> wrote:
>  > >
>  > > It looks like a likely culprit is that SKB_GSO_CB()->csum_start is
>  > > not set correctly when doing non-scatter gather. We are using
>  > > offset as opposed to doffset.
>  > >
>  > > Reported-by: Dave Jones <davej@redhat.com>
>  > 
>  > DaveJ, I think you triggered this in five minutes on your box, and I
>  > don't recall seeing anybody else reporting the oops (and google
>  > doesn't find anything in the last month). So it's presumably somewhat
>  > hw-specific. Does this fix the problem?
> 
> It's survived routing ~1GB of packets overnight, so I'd call this good.

Tom, please adjust the Subject line as suggested by Eric Dumazet and add
a Tested-by: for Dave.

Thanks!
