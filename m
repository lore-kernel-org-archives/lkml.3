Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438AbaGOJVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:21:34 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:27539 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757853AbaGOJVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:21:31 -0400
Date: Tue, 15 Jul 2014 12:21:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: DaeSeok Youn <daeseok.youn@gmail.com>
Cc: devel <devel@driverdev.osuosl.org>, Lidza Louina <lidza.louina@gmail.com>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 8/8] staging: dgap: fix memory leak in dgap_parsefile()
Message-ID: <20140715092059.GW25880@mwanda>
References: <20140715030456.GA14420@devel.8.8.4.4>
 <20140715065116.GS25880@mwanda>
 <CAHb8M2CS4wVKjP-Ur2UtkXA9KLMudS7+LbmnzpOFxq6hXqy2OQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHb8M2CS4wVKjP-Ur2UtkXA9KLMudS7+LbmnzpOFxq6hXqy2OQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 06:05:35PM +0900, DaeSeok Youn wrote:
> 2014-07-15 15:51 GMT+09:00 Dan Carpenter <dan.carpenter@oracle.com>:
> > On Tue, Jul 15, 2014 at 12:05:14PM +0900, Daeseok Youn wrote:
> >> The p->u.board.status is allocated and set a string as
> >> "No" once within allocating a node of BNODE type.
> >> But it also set again with kstrdup() in case of "STATUS"
> >> or "ID". If it is not allocated yet, use kstrdup().
> >> If not, use just memcpy().
> >
> > I don't think a 2 char buffer is always large enough to hold the new
> > strings.
> >
> > Just free it and allocate again.
> Yes, I will send this again.
> 

Actually, please just send the whole set again.  I really want Mark on
the CC list so he's reviewing these.

regards,
dan carpenter

