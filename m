Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169Ab3E0Lwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 07:52:38 -0400
Received: from gate.crashing.org ([63.228.1.57]:43097 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932124Ab3E0Lwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 07:52:36 -0400
Message-ID: <1369655404.3557.33.camel@pasglop>
Subject: Re: [PATCH 1/2] ARM: kirkwood: proper retain MAC address workaround
 on DT ethernet
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: David Miller <davem@davemloft.net>, buytenh@wantstofly.org,
        jason@lakedaemon.net, andrew@lunn.ch, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org
Date: Mon, 27 May 2013 21:50:04 +1000
In-Reply-To: <51A33447.80305@gmail.com>
References: <1369253042-15082-1-git-send-email-sebastian.hesselbarth@gmail.com>
	 <20130525.210441.818472895703230779.davem@davemloft.net>
	 <51A26B62.4050009@gmail.com>
	 <20130527.022339.791886107453761860.davem@davemloft.net>
	 <1369647565.3557.28.camel@pasglop> <51A33447.80305@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-27 at 12:24 +0200, Sebastian Hesselbarth wrote:
> > There is an of_update_property(), we could change the name though,
> yours
> > is nicer :-)
> 
> Ben, David,
> 
> I had a quick look at sparc's of_set_property. Nothing special except
> it
> depends on OF_DYNAMIC at some place. Using of_update_property instead
> should be the correct function to use. Thanks for the hint, I'll
> update
> the patches accordingly and send v5 hopefully by today.

The only thing is that of_update_property() is a bit awkward to use,
requiring the caller to provide an allocated struct property with
associated allocated content. It also leaks the old property which
is annoying but we haven't sorted out how to deal with allocation
of properties and property content yet.

It would be handy to be able to just do something like

	of_set_property(node, name, ptr, len);

However, that wouldn't help much with the allocation/leak problem,
though at least it would be easier to use. It could also *try* to re-use
the current allocation if the new content is of smaller or equal size.

Cheers,
Ben.


