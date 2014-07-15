Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211AbaGOJFk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:05:40 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:52936 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbaGOJFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:05:37 -0400
MIME-Version: 1.0
In-Reply-To: <20140715065116.GS25880@mwanda>
References: <20140715030456.GA14420@devel.8.8.4.4>
	<20140715065116.GS25880@mwanda>
Date: Tue, 15 Jul 2014 18:05:35 +0900
Message-ID: <CAHb8M2CS4wVKjP-Ur2UtkXA9KLMudS7+LbmnzpOFxq6hXqy2OQ@mail.gmail.com>
Subject: Re: [PATCH 8/8] staging: dgap: fix memory leak in dgap_parsefile()
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Lidza Louina <lidza.louina@gmail.com>, devel <devel@driverdev.osuosl.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-15 15:51 GMT+09:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Tue, Jul 15, 2014 at 12:05:14PM +0900, Daeseok Youn wrote:
>> The p->u.board.status is allocated and set a string as
>> "No" once within allocating a node of BNODE type.
>> But it also set again with kstrdup() in case of "STATUS"
>> or "ID". If it is not allocated yet, use kstrdup().
>> If not, use just memcpy().
>
> I don't think a 2 char buffer is always large enough to hold the new
> strings.
>
> Just free it and allocate again.
Yes, I will send this again.

Thanks.

regards,
Daeseok Youn.
>
> regards,
> dan carpenter
>
