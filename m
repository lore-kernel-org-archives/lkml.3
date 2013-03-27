Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab3C0L5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 07:57:42 -0400
Received: from void.printf.net ([89.145.121.20]:50284 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643Ab3C0L5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 07:57:40 -0400
From: Chris Ball <cjb@laptop.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Sergey Yanovich <ynvich@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Namjae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH v2] wait while adding MMC host to ensure root mounts
References: <1363223183-3772-1-git-send-email-ynvich@gmail.com>
	<1363224194-7366-1-git-send-email-ynvich@gmail.com>
	<87620jmkoe.fsf@octavius.laptop.org>
	<CAPDyKFp27MUOjhydLXf92vN3cua=XcX4oTJnMGfOJPpBhtwM8Q@mail.gmail.com>
Date: Wed, 27 Mar 2013 07:57:34 -0400
In-Reply-To: <CAPDyKFp27MUOjhydLXf92vN3cua=XcX4oTJnMGfOJPpBhtwM8Q@mail.gmail.com>
	(Ulf Hansson's message of "Wed, 27 Mar 2013 12:13:12 +0100")
Message-ID: <87ppylf429.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Mar 27 2013, Ulf Hansson wrote:
> I noticed you merged this. I thought the idea was to use the rootwait
> or rootdelay?

That's necessary before the patch, but it would be better if we didn't
have to pass rootwait, all else being equal.

> Moreover, this patch will have bad impact on booting the kernel, since
> every host device that has scheduled a detect work from it's probe
> function will also wait for it to finish. Even if it is the boot
> device of not. If this is needed, I would prefer that a host cap is
> used.

I see, you're worried about a performance regression where every boot
takes longer than it used to while MMC quiesces.  That's fair.  Do you
think you could tell me how much delay this adds to a boot for you, so
that we can consider whether the usability improvement is worth it?

If the delay's significant, I agree with you and will revert this patch.

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
