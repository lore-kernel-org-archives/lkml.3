Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933403AbaJUUFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 16:05:46 -0400
Received: from mailsec111.isp.belgacom.be ([195.238.20.107]:45029 "EHLO
	mailsec111.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932529AbaJUUFn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 16:05:43 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=1oN0sfwJalOpr2aHay7Qy/p3C2/DrgK1QE5UNNaX0S8= c=1 sm=2
 a=IkcTkHD0fZMA:10 a=stkexhm8AAAA:8 a=dUc_3phmnXrYhPl9RqEA:9
 a=QEXdDO2ut3YA:10 a=DV8Pb4sAe4kA:10
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnMLAMC7RlTD7hTT/2dsb2JhbABcgw6BK4MGthABAQEBAQEGmysCgRYWAX2EAgEBAQMBI1YFCwUGGAICGA4CAlcGExGIJgyyE4cAjW0BAQEHAQEBAR6BLIR5iX8zB4J3gVQFqkCJP4I0gUY7L4JLAQEB
Date: Tue, 21 Oct 2014 22:05:41 +0200 (CEST)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>
Message-ID: <1473755457.212484.1413921941002.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <1413918366.1998.10.camel@jlt4.sipsolutions.net>
References: <1413908412-5177-1-git-send-email-fabf@skynet.be> <1413918366.1998.10.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 1/1 net-next] mac80211: remove unnecessary null test
 before debugfs_remove
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.2.2-Rev27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On 21 October 2014 at 21:06 Johannes Berg <johannes@sipsolutions.net> wrote:
>
>
> On Tue, 2014-10-21 at 18:20 +0200, Fabian Frederick wrote:
> > Fix checkpatch warnings:
> >
> >     WARNING: debugfs_remove(NULL) is safe this check is probably not
> >required
>
> I'll apply this; however, I think that checkpatch is a just tool, and
> the commit message should reflect why you're changing the code.
> Presumably you're not doing it to make the tool happy, but to address an
> issue that the tool pointed out, so I think in most cases the commit
> message should state the former, not the latter.
>
> Note that in this particular case the NULL check check could be there to
> avoid a memory write (which can be significant depending on the context)
> so blindly doing what the tool suggested wouldn't always be a good idea.
>
> johannes
>

Thanks Johannes,

Maybe you can replace commit message with:
"
This patch removes NULL check before debugfs_remove.
That function already does that check and is
only called during key management so we can add some memory writes.
"

I can also resubmit patch if necessary.

Regards,
Fabian
