Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbaF0MDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 08:03:18 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:46039 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621AbaF0MDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 08:03:16 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7fac6d000006cfe-80-53ad5d82fa86
Content-transfer-encoding: 8BIT
Message-id: <1403870594.3872.0.camel@AMDC1943>
Subject: Re: [PATCH] clk: s2mps11: Fix double free corruption during driver
 unbind
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Yadwinder Singh Brar <yadi.brar01@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Tushar Behera <tushar.behera@linaro.org>
Date: Fri, 27 Jun 2014 14:03:14 +0200
In-reply-to: <CAKew6eWEnQkfWJfhNXnHGbDc5j8nmGBsKb48DvdS-jud-sKLBA@mail.gmail.com>
References: <1403865264-29062-1-git-send-email-k.kozlowski@samsung.com>
 <CAKew6eWEnQkfWJfhNXnHGbDc5j8nmGBsKb48DvdS-jud-sKLBA@mail.gmail.com>
X-Mailer: Evolution 3.10.4-0ubuntu1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t/xa7pNsWuDDT7f5rDYOGM9q8XZpjfs
	Fpd3zWGzWHvkLrvF0wkX2SzWz3jNYtH+dy+bxdzfjawWc6a/Y3Lg9Ng56y67x51re9g8+ras
	YvT4vEkugCWKyyYlNSezLLVI3y6BK2PHtw7Wghb2ioata9gbGC+ydjFyckgImEgcPL2BEcIW
	k7hwbz1bFyMXh5DAUkaJtk1bWUASvAKCEj8m3wOyOTiYBeQljlzKBgkzC6hLTJq3iBmi/jOj
	xOQLk1gh6vUkNi2YAmYLC4RItOxZygRiswkYS2xevoQNxBYRMJCYuGQeK0gzs8BbJom2Y5fA
	lrEIqErsPL8VrIhTIFji1vIeVogNfYwSB8//ZoI4VVli3v5jTBMYBWYhOXAWwoGzkBy4gJF5
	FaNoamlyQXFSeq6hXnFibnFpXrpecn7uJkZIwH/Zwbj4mNUhRgEORiUe3h371wQLsSaWFVfm
	HmKU4GBWEuGd7LE2WIg3JbGyKrUoP76oNCe1+BAjEwenVAMjh+P67Oc3V6/8st7k6e/na4Q3
	ZfkaOy9Ulbl398Ckf1M23jy6OvJw7JQjKzUnVGVk/jpwrFTN4uSu0thp23447t2wRVDfYnvd
	gZ/+5cJJQWEbXy3jSngcV8rwaN6PKT1Pv5254HD/md4kM7vmec1Ma6b/WsSzvaJthgv/gpn5
	RZf/X+qf/UB/6VclluKMREMt5qLiRADek/zhVgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2014-06-27 at 17:19 +0530, Yadwinder Singh Brar wrote:
> Hi Krzystof,
> 
> On Fri, Jun 27, 2014 at 4:04 PM, Krzysztof Kozlowski
> <k.kozlowski@samsung.com> wrote:
> > After unbinding the driver memory was corrupted by double free of
> > clk_lookup structure. This lead to OOPS when re-binding the driver
> > again.
> >
> > The driver allocated memory for 'clk_lookup' with devm_kzalloc. During
> > driver removal this memory was freed twice: once by clkdev_drop() and
> > second by devm code.
> >
> 
> Ideally memory should be allocated and deallocated in same place
> either driver or framework, so in this case if framework(clkdev_drop)
> deallocates memory, framework itself should also allocate it.
> So IMO this bug should be fixed using clkdev_alloc() instead of kzalloc().
> 

You're right, I'll send fixed version. Thanks for idea.

Best regards,
Krzysztof

