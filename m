Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbaJACft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 22:35:49 -0400
Received: from muin.pair.com ([209.68.1.55]:59863 "EHLO muin.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbaJACfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 22:35:48 -0400
Message-ID: <542B6882.9060801@tabi.org>
Date: Tue, 30 Sep 2014 21:35:46 -0500
From: Timur Tabi <timur@tabi.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:32.0) Gecko/20100101 Firefox/32.0 SeaMonkey/2.29.1
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: "J. German Rivera" <German.Rivera@freescale.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>,
        stuart.yoder@freescale.com, Kim Phillips <Kim.Phillips@freescale.com>,
        Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH 3/3 v2] drivers/bus: Device driver for FSL-MC DPRC devices
References: <1411166981-3610-1-git-send-email-German.Rivera@freescale.com>	 <1411166981-3610-4-git-send-email-German.Rivera@freescale.com>	 <CAOZdJXWqpPypHg1iw7Tg-d=2g=+qnHh-=BK_9_yJKzpooe0+YQ@mail.gmail.com> <1412130432.13320.342.camel@snotra.buserror.net>
In-Reply-To: <1412130432.13320.342.camel@snotra.buserror.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scott Wood wrote:
>>> > >+       if (num_child_objects_in_mc != 0) {
>> >
>> >Like here.  Just do "if (num_child_objects_in_mc) {"

> This seems to be a place that is testing for zero as a value rather than
> as a stand-in for NULL, so I'd argue it's better style to leave it as
> is.

But in this case, zero means "none left", so this is a perfectly valid 
use-case for omitting the !=.

strcmp() is the only time I can think of to put an explicit != 0, 
because this:

	if (!strcmp(s1, s2))

is counter-intuitive.
