Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbbAKTeN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 14:34:13 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45188 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751044AbbAKTeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 14:34:05 -0500
X-Sasl-enc: cUIv3p6tOLbbT7QhDPzX1GYFAJzHMLvqyHG5kTINGTiS 1421004844
Date: Sun, 11 Jan 2015 14:34:04 -0500
From: Christoph Jaeger <cj@linux.com>
To: Joe Perches <joe@perches.com>
Cc: Alan <alan@linux.intel.com>, davem@davemloft.net, willemb@google.com,
        edumazet@google.com, dborkman@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] packet: bail out of packet_snd() if L2 header
 creation fails
Message-ID: <20150111193404.GN1513@betelgeuse.hsd1.ma.comcast.net>
References: <1420999276-28225-1-git-send-email-cj@linux.com>
 <1421002345.9233.1.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421002345.9233.1.camel@perches.com>
X-Homepage: http://christophjaeger.info
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2015 at 10:52:25AM -0800, Joe Perches wrote:
> On Sun, 2015-01-11 at 13:01 -0500, Christoph Jaeger wrote:
> > Due to a misplaced parenthesis, the expression
> > 
> >   (unlikely(offset) < 0),
> > 
> > which expands to
> > 
> >   (__builtin_expect(!!(offset), 0) < 0),
> 
> Here's another one:
> 
> drivers/platform/goldfish/goldfish_pipe.c:285:	if (unlikely(bufflen) == 0)

Well, the conditional statement works as intended. Of course, the branch
prediction doesn't.

Coccinelle should be able to check for this kind of likely()/unlikely() usage,
shouldn't it?

~Christoph
