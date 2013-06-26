Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab3FZBfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 21:35:04 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:51822 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab3FZBfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 21:35:03 -0400
MIME-Version: 1.0
In-Reply-To: <20130625091201.GW27646@sirena.org.uk>
References: <1371713467-3256-1-git-send-email-chao.xie@marvell.com>
	<20130621152416.GC27646@sirena.org.uk>
	<CADApbeigFTQNhxR-CVBGUhXvg+jVtt7ZVvEHuKqeSA80CFz-dQ@mail.gmail.com>
	<20130624101454.GG27646@sirena.org.uk>
	<CADApbeh7upEmy7URYvoMdU0jUR4qC-a+AErH5ND5QG5xwVdAdg@mail.gmail.com>
	<20130625091201.GW27646@sirena.org.uk>
Date: Wed, 26 Jun 2013 09:35:01 +0800
Message-ID: <CADApbehiFuom7DJ8L9upE3yawHmreqGovCFeLuXoVhzLXsLENQ@mail.gmail.com>
Subject: Re: [PATCH V2] regulator: 88pm800: add regulator driver for 88pm800
From: Chao Xie <xiechao.mail@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Chao Xie <chao.xie@marvell.com>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        yizhang@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 5:12 PM, Mark Brown <broonie@kernel.org> wrote:
> On Tue, Jun 25, 2013 at 10:13:38AM +0800, Chao Xie wrote:
>> On Mon, Jun 24, 2013 at 6:14 PM, Mark Brown <broonie@kernel.org> wrote:
>
>> > If you really need to have platform data for all the regulators then
>> > just embed the array inside the platform data so there's no possibility
>> > of any confusion.
>
>> Some regulators will not be exported to kernel depending on boards which are
>> for special usage. So i do not use a array inside the platform data.
>
> Remember that the regulator API won't do anything except read from a
> regulator unless it's got constraints saying it's OK to do so.  Are you
> saying that even reading the hardware state is a problem?
The regulator driver does not only work for 88pm805 but also for the
next lite version 88pm822.
88pm822 only have 14 LDOes. So i defined array of points in pdata.
When user define pdata for 88pm805, it can fill all 19 LDOes, while
for 88pm822, it only fill 14 LDOes, and set
others to be NULL, and do not need fill some dummy data into the left 5 LDOes.
The 88pm822 is just tape out, and we are debugging at it. So the
detection of 88pm822 is not added to this driver yet.
