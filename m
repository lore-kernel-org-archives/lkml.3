Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab3IIQmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:42:23 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:33301 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571Ab3IIQmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:42:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAG-2HqWaoovz+-pY2JnA4BSTULa4Hq=_5Oy4hzWOdQbrkijQKw@mail.gmail.com>
References: <CAG-2HqWaoovz+-pY2JnA4BSTULa4Hq=_5Oy4hzWOdQbrkijQKw@mail.gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Mon, 9 Sep 2013 18:41:48 +0200
Message-ID: <CAPXgP11XKqsQB96t=NPB1sQT5ppxUOnz4FZyFtXsE0PyF2jArA@mail.gmail.com>
Subject: Re: [BUG?] staging: zram: Add auto loading of module if user opens /dev/zram.
To: Tom Gundersen <teg@jklm.no>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Minchan Kim <minchan@kernel.org>, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 9, 2013 at 5:58 PM, Tom Gundersen <teg@jklm.no> wrote:
> Hi Konrad,
>
> The above commit (c70bda9 in mainline) doesn't appear to work for me.
> I.e., depmod does not create an entry in modules.devname and hence no
> device node is created on boot.
>
> If I understand correctly, you'd also need to create the correct
> "char-major-<MAJOR>-<MINOR>" alias. But I don't really see how this is
> meant to work as I thought zram only created /dev/zramX type device
> nodes, and not /dev/zram, or am I missing something?

Please just remove it. "devname" is meant to be used for
single-instance devices with a static dev_t, never for things like
zramX.

It will not do anything useful here, it does nothing really without a
statically assigned dev_t, and it should not be used for devices of
this kind anyway.

Thanks,
Kay
