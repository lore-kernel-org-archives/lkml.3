Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbaHLA2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 20:28:16 -0400
Received: from mail-oi0-f51.google.com ([209.85.218.51]:63263 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbaHLA2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 20:28:14 -0400
MIME-Version: 1.0
In-Reply-To: <20140811105640.GN4856@mwanda>
References: <20140809053644.GA14630@devel.8.8.4.4>
	<20140811105640.GN4856@mwanda>
Date: Tue, 12 Aug 2014 09:28:13 +0900
Message-ID: <CAHb8M2Dz5iWFcW8WNZkA_ikD0uKJqTuLQtkw4h6+7QCJ-3dL1A@mail.gmail.com>
Subject: Re: [PATCH 1/7] staging: dgap: remove useless variable
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Lidza Louina <lidza.louina@gmail.com>, Mark Hounschell <markh@compro.net>,
        devel <devel@driverdev.osuosl.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Dan

2014-08-11 19:56 GMT+09:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Sat, Aug 09, 2014 at 02:36:44PM +0900, Daeseok Youn wrote:
>> dgap_major_serial_registered and dgap_major_transparent_print_registered
>> could be checked whether a board is initialized.
>> But it doesn't need to check that variables becasue dgap module
>> isn't calling the dgap_cleanup_tty() without initializing
>> for a board completely.
>
> I don't understand.  What about the call to dgap_cleanup_module() in
> dgap_init_module()?
I think the call of dgap_cleanup_tty()
in dgap_cleanup_module() from dgap_init_module() is not reached.
Because dgap_init_module() is called when driver is loaded, at this
point of time,
there are no boards that are initialized.(dgap_numboards is zero)

And the change log of this is needed to modify for clearing message.

Thanks.

regards,
Daeseok Youn.
>
> regards,
> dan carpenter
>
