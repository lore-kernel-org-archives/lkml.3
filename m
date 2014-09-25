Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601AbaIYA0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 20:26:49 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:35049 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbaIYA0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 20:26:48 -0400
MIME-Version: 1.0
In-Reply-To: <20140924094530.GC5811@mwanda>
References: <20140923002236.GA20782@devel>
	<20140924094530.GC5811@mwanda>
Date: Thu, 25 Sep 2014 09:26:47 +0900
Message-ID: <CAHb8M2A82yFT9dWqz=Ad_VoPY0c+UF5-VxbBOH-VNUjLnfJ1jA@mail.gmail.com>
Subject: Re: [PATCH 3/3] staging: dgap: use dgap_release_remap() in dgap_cleanup_board()
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

Hi,

2014-09-24 18:45 GMT+09:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Tue, Sep 23, 2014 at 09:22:36AM +0900, Daeseok Youn wrote:
>>  static void dgap_release_remap(struct board_t *brd)
>>  {
>> -     release_mem_region(brd->membase, 0x200000);
>> -     release_mem_region(brd->membase + PCI_IO_OFFSET, 0x200000);
>> -     iounmap(brd->re_map_membase);
>> -     iounmap(brd->re_map_port);
>> +     if (brd->re_map_membase) {
>
> I hate this if conditions.  Let's not complicate dgap_release_remap(),
> let's fix the callers instead.  Especially dgap_init_module() is a
> totally sucky function with bad unwinding.
ok. then,
   if (brd->re_map_membase && brd->re_map_port)
        dgap_release_remap(brd);

right?
>
> Let's not apply this patch.
oh.. this patch was already applied to staging tree.
I will make different patch for this.

thanks.

regards,
Daeseok Youn.
>
> regards,
> dan carpenter
>
