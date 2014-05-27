Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbaE0RUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 13:20:48 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:53601 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbaE0RUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 13:20:47 -0400
MIME-Version: 1.0
In-Reply-To: <20140527102728.GD20436@moon>
References: <20140527091335.GC20436@moon>
	<20140527102013.3BF61E009B@blue.fi.intel.com>
	<20140527102728.GD20436@moon>
Date: Tue, 27 May 2014 10:20:46 -0700
Message-ID: <CAM_iQpXsJO+VNc9yearpQE19HQkF4bM9PibbQ6bwW=OCZn1FQg@mail.gmail.com>
Subject: Re: [linux-next] splice call weird results
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 3:27 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Tue, May 27, 2014 at 01:20:13PM +0300, Kirill A. Shutemov wrote:
>> Cyrill Gorcunov wrote:
>> > Hi! While been trying to run criu on linux-next (due to recent Kirill's patch related
>> > to /proc/pid/clear_refs with THP enabled) I noticed that it fails dumping programs when
>> > moves data from memory pages into an image file. So I wrote pretty idiotic test and
>> > run it on current fedora 20 kernel and then on linux-next.
>> >
>>
>> +Al. He reworked splice code in linux-next.
>
> Thanks Kirill. Al, it looks like iter_file_splice_write no longer honor @len while
> building kiocb vector but pushes as much as it can.


I guess this should fix your problem:
https://lkml.org/lkml/2014/5/27/353
