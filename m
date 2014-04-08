Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436AbaDHWRw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 18:17:52 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:33686 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaDHWRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 18:17:51 -0400
MIME-Version: 1.0
In-Reply-To: <1396964636.26672.66.camel@sauron.fi.intel.com>
References: <1396339305-16005-1-git-send-email-tlinder@codeaurora.org>
	<1396964546.26672.65.camel@sauron.fi.intel.com>
	<1396964636.26672.66.camel@sauron.fi.intel.com>
Date: Wed, 9 Apr 2014 00:17:50 +0200
Message-ID: <CAFLxGvxDpggGAPu2rVz-KLkHS1KoQNqU-DOJ=xubVinFn68VEw@mail.gmail.com>
Subject: Re: [RFC/PATCH] mtd: ubi: Free peb's synchronously for fastmap
From: Richard Weinberger <richard.weinberger@gmail.com>
To: "Bityutskiy, Artem" <artem.bityutskiy@intel.com>
Cc: "tlinder@codeaurora.org" <tlinder@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2014 at 3:44 PM, Bityutskiy, Artem
<artem.bityutskiy@intel.com> wrote:
> On Tue, 2014-04-08 at 16:42 +0300, Artem Bityutskiy wrote:
>> On Tue, 2014-04-01 at 11:01 +0300, Tanya Brokhman wrote:
>> > At first mount it's possible that there are not enough free PEBs since
>> > there are PEB's pending to be erased. In such scenario, fm_pool (which is
>> > the pool from which user required PEBs are allocated) will be empty.
>> > Try fixing the above described situation by synchronously performing
>> > pending erase work, thus produce another free PEB.
>> >
>> > Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
>>
>> Pushed to linux-ubifs.git / master, thanks!
>
> Oh, sorry, this one I actually _dropped_. Would you please rather
> re-structure the code to avoid duplication. E.g., do what Richard
> suggested.

Tatyana, can you also please find out how many PEBs you need?
Strictly speaking we need only one (which should be produced by __wl_get_peb().
I want to make sure that we're not just papering over an issue. :-)

-- 
Thanks,
//richard
