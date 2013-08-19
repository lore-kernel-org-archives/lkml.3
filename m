Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751264Ab3HSSEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 14:04:40 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:61336 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab3HSSEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 14:04:37 -0400
X-AuditID: cbfec7f4-b7f5f6d000000ff6-27-52125e3389aa
Message-id: <52125E31.6090207@samsung.com>
Date: Mon, 19 Aug 2013 20:04:33 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        jiada_wang@mentor.com, broonie@kernel.org, vapier@gentoo.org,
        ralf@linux-mips.org, lethal@linux-sh.org, kyungmin.park@samsung.com,
        shawn.guo@linaro.org, sebastian.hesselbarth@gmail.com,
        LW@KARO-electronics.de, t.figa@samsung.com, g.liakhovetski@gmx.de,
        laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] clk: implement clk_unregister
References: <1375804317-10576-1-git-send-email-s.nawrocki@samsung.com>
 <1375804317-10576-3-git-send-email-s.nawrocki@samsung.com>
 <20130816214841.4443.10515@quantum>
In-reply-to: <20130816214841.4443.10515@quantum>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsVy+t/xK7rGcUJBBvd/s1hMffiEzeL9xnlM
	Fj1/Ki3ONr1ht+icuITdYv/bn6wWmx5fY7W4vGsOm8WEqZPYLeb8mcJscfsyr8WBJ8vZLJ5O
	uMhmcWmPisX7n44WT9ctYbZYP+M1i8XChi/sFjcn/GB2EPZoae5h81g53dvj8vc3zB47Z91l
	9/jwMc5jdsdMVo/50x8xe2xa1cnmcefaHjaPoyvXMnmcfn+I1WPzknqP3V+bGD36tqxi9Pi8
	SS6AP4rLJiU1J7MstUjfLoEro2/pI/aCL9oVl/9lNTD2KXQxcnJICJhITNi8nR3CFpO4cG89
	WxcjF4eQwFJGib2757BAOJ8YJSZ9/AVWxSugJfFqZzeYzSKgKrHtXycriM0mYCjRe7SPEcQW
	FQiQWLzkHFS9oMSPyfdYQGwRoN5tB1rBNjALvGCWuPD2OzNIQljASmLF+XXsENtWMkr09i0H
	6+YUMJB48vMnWBGzgLrEpHmLoGx5ic1r3jJPYBSYhWTJLCRls5CULWBkXsUomlqaXFCclJ5r
	qFecmFtcmpeul5yfu4kRErdfdjAuPmZ1iFGAg1GJh9dAQShIiDWxrLgy9xCjBAezkgjvV3ag
	EG9KYmVValF+fFFpTmrxIUYmDk6pBsa5NhKnch6siFkYn1uRb8r2T6+7USPM1mLulaBAVlGf
	zEUmPAI83E/PB0Q1PUq896mis2GygrrW7+URFUfTfbWu3r9wdzEPVwxnDzPb14vLfR2FXkw8
	zJGmW3+Ua8q8lVnJFoEbuV9vNTVRe/v+/zLh46kZ770+LrFyWic0eV7M0nn7zobdC1JiKc5I
	NNRiLipOBADwVE71uQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2013 11:48 PM, Mike Turquette wrote:
> Quoting Sylwester Nawrocki (2013-08-06 08:51:57)
>> +/*
>> + * Empty clk_ops for unregistered clocks. These are used temporarily
>> + * after clk_unregister() was called on a clock and until last clock
>> + * consumer calls clk_put() and the struct clk object is freed.
>> + */
>> +static int clk_dummy_prepare_enable(struct clk_hw *hw)
>> +{
>> +       return -ENXIO;
>> +}
>> +
>> +static void clk_dummy_disable_unprepare(struct clk_hw *hw)
>> +{
>> +       WARN_ON(1);
>> +}
>> +
>> +static int clk_dummy_set_rate(struct clk_hw *hw, unsigned long rate,
>> +                                       unsigned long parent_rate)
>> +{
>> +       return -ENXIO;
>> +}
>> +
>> +static int clk_dummy_set_parent(struct clk_hw *hw, u8 index)
>> +{
>> +       return -ENXIO;
>> +}
>> +
>> +static const struct clk_ops clk_dummy_ops = {
>> +       .enable         = clk_dummy_prepare_enable,
>> +       .disable        = clk_dummy_disable_unprepare,
>> +       .prepare        = clk_dummy_prepare_enable,
>> +       .unprepare      = clk_dummy_disable_unprepare,
>> +       .set_rate       = clk_dummy_set_rate,
>> +       .set_parent     = clk_dummy_set_parent,
>> +};
> 
> Don't use "clk_dummy_*" here. The use of dummy often implies that
> operations will return success in the absence of actual hardware but
> these return an error, and rightly so. So maybe rename the functions and
> clk_ops instance to something like "clk_nodev_*" or "clk_missing_*"?

Hmm, this is more about a driver being removed rather than the device.
Then perhaps we could make it __clk_nodrv_* or clk_nodrv_* ?

>>  /**
>>   * clk_unregister - unregister a currently registered clock
>>   * @clk: clock to unregister
>> - *
>> - * Currently unimplemented.
>>   */
>> -void clk_unregister(struct clk *clk) {}
>> +void clk_unregister(struct clk *clk)
>> +{
>> +       unsigned long flags;
>> +
>> +       clk_prepare_lock();
>> +
>> +       if (!clk || IS_ERR(clk)) {
>> +               pr_err("%s: invalid clock: %p\n", __func__, clk);
>> +               goto out;
>> +       }
>> +
>> +       if (clk->ops == &clk_dummy_ops) {
>> +               pr_err("%s: unregistered clock: %s\n", __func__, clk->name);
>> +               goto out;
>> +       }
>> +       /*
>> +        * Assign dummy clock ops for consumers that might still hold
>> +        * a reference to this clock.
>> +        */
>> +       flags = clk_enable_lock();
>> +       clk->ops = &clk_dummy_ops;
>> +       clk_enable_unlock(flags);
>> +
>> +       if (!hlist_empty(&clk->children)) {
>> +               struct clk *child;
>> +
>> +               /* Reparent all children to the orphan list. */
>> +               hlist_for_each_entry(child, &clk->children, child_node)
>> +                       clk_set_parent(child, NULL);
>> +       }
> 
> This looks pretty good. A remaining problem is re-loading the clock
> provider module will have string name conflicts with the old
> unregistered clocks (but not yet released) clocks during calls to
> __clk_lookup.

But the clock is being dropped from the clock tree immediately in this
function. After the hlist_del_init() call below the clock is not present
on any clocks list. Upon clock release only the memory allocated for
the clock is freed.

> The best solution would be to refactor clk.c to not use string name
> lookups but that is probably too big of an issue for the purpose of this
> series (but it will happen some day).
> 
> A short term solution would be to poison the clock's string name here.
> Reallocate the clk->name string with some poison data so that name
> conflicts don't occur. What do you think?

This shouldn't be necessary, for the reason described above. I've tested
multiple registrations when a clock was being referenced by a consumer
driver and it worked well.

I'm still a bit unsure about the kref reference counting, but I'd would
assume it is good to have. It prevents the kernel to crash in some
situations. Many other subsystems/drivers crash miserably when a driver
gets unbound using the sysfs "unbind" attribute. However, if it is assumed
that user space needs to keep track of respective resource references
and should know what it does when unbinding drivers, then we could probably
do without the kref. I'm seriously sceptical though about letting user
space to crash the kernel in fairly simple steps, it just doesn't sound
right.

> Regards,
> Mike
> 
>> +
>> +       clk_debug_unregister(clk);
>> +
>> +       hlist_del_init(&clk->child_node);
>> +
>> +       if (clk->prepare_count)
>> +               pr_warn("%s: unregistering prepared clock: %s\n",
>> +                                       __func__, clk->name);
>> +
>> +       kref_put(&clk->ref, __clk_release);
>> +out:
>> +       clk_prepare_unlock();
>> +}
>>  EXPORT_SYMBOL_GPL(clk_unregister);
>>
>>  static void devm_clk_release(struct device *dev, void *res)
>> @@ -1861,6 +1973,7 @@ int __clk_get(struct clk *clk)
>>         if (!try_module_get(clk->owner))
>>                 return 0;
>>
>> +       kref_get(&clk->ref);
>>         return 1;
>>  }
>>  EXPORT_SYMBOL(__clk_get);
>> @@ -1870,6 +1983,10 @@ void __clk_put(struct clk *clk)
>>         if (!clk || IS_ERR(clk))
>>                 return;
>>
>> +       clk_prepare_lock();
>> +       kref_put(&clk->ref, __clk_release);
>> +       clk_prepare_unlock();
>> +
>>         module_put(clk->owner);
>>  }
>>  EXPORT_SYMBOL(__clk_put);

--
Regards,
Sylwester
