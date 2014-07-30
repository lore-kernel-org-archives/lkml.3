Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbaG3XBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 19:01:00 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:58021 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaG3XA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 19:00:59 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1407301550140.26018@chino.kir.corp.google.com>
References: <20140730035541.GD16537@localhost>
	<20140730111521.GB759@infradead.org>
	<alpine.DEB.2.02.1407301550140.26018@chino.kir.corp.google.com>
Date: Wed, 30 Jul 2014 16:00:58 -0700
Message-ID: <CAADnVQ+OwgG-RJQ7QwfW2qrvpV9XYySckTbNmcacW7K0KxQqvA@mail.gmail.com>
Subject: Re: [delayed_fput] BUG: unable to handle kernel paging request at ffff8800122a0ad0
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-fsdevel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 3:51 PM, David Rientjes <rientjes@google.com> wrote:
> On Wed, 30 Jul 2014, Christoph Hellwig wrote:
>
>> On Wed, Jul 30, 2014 at 11:55:41AM +0800, Fengguang Wu wrote:
>> > Greetings,
>> >
>> > 0day kernel testing robot got the below dmesg and the first bad commit is
>>
>> How does this manage to trip over a 2 year old commit now?

may be because all kernels are built with gcc 4.8.2 ?
Fengguang, did you recently switch to new compiler?
I think all older builds were with 4.6.3

> I think there's something weird going on with the testing of CONFIG_SLOB,
> same as http://permalink.gmane.org/gmane.linux.kernel/1759314 that
> identified a harmless commit that only initializes a field of
> struct mm_struct and then ended up exploded in slob freeing.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
