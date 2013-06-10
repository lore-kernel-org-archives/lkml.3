Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511Ab3FJGly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 02:41:54 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:33619 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab3FJGlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 02:41:53 -0400
MIME-Version: 1.0
In-Reply-To: <20130610000446.GA2928@katana>
References: <1370291306-3276-1-git-send-email-wsa@the-dreams.de>
	<CAHp75Vcvhz892D4gytneptB4wLWPjfKmf5OXgnChXw338nLBAA@mail.gmail.com>
	<20130610000446.GA2928@katana>
Date: Mon, 10 Jun 2013 09:41:52 +0300
Message-ID: <CAHp75Vfb7Evhf6yMNd4nzcL9TM5Svu6Z1_MPPAWkmBjhgeDJ8A@mail.gmail.com>
Subject: Re: [PATCH] pwm: devm: alloc correct pointer size
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@avionic-design.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 3:04 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
> On Thu, Jun 06, 2013 at 10:43:41PM +0300, Andy Shevchenko wrote:
>> On Mon, Jun 3, 2013 at 11:27 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
>> > The allocated object should be the size of what the pointer is pointing
>> > to and not the size of the pointer itself.
>>
>> All devm_* functions in this module use **ptr as a parameter (except
>> allocation).
>> May be we first should understand why it so?
>
> Huh? **ptr is already created on the stack, but assigned the alloced
> memory. Later, the mem it points to is set to 'pwm' which is then added
> to devres. So, the alloced memory must be able to contain '*ptr' (or
> *pwm which would be more readable IMO, but other subsystems also stick
> to *ptr), no?

Yes, you right.
Take my Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

--
With Best Regards,
Andy Shevchenko
