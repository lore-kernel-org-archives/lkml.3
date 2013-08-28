Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab3H1SNn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 14:13:43 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:44567 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901Ab3H1SNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 14:13:42 -0400
Message-ID: <521E3DD5.6020409@tilera.com>
Date: Wed, 28 Aug 2013 14:13:41 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Tejun Heo <tj@kernel.org>, <akpm@linuxfoundation.org>,
        <linux-arch@vger.kernel.org>, Steven Rostedt <srostedt@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [guv v2 23/31] tile: Replace __get_cpu_var uses
References: <20130826204351.725357339@linux.com> <00000140bc69acdb-3b2967b0-e224-424b-ad08-973515704be6-000000@email.amazonses.com> <521BD523.3040706@tilera.com> <00000140c03f13d6-07480caf-b5b0-440b-af95-04878ee9f46c-000000@email.amazonses.com> <521E312C.2050004@tilera.com> <00000140c60fe2a0-aff878d7-06b3-4fe8-b97f-b319183f3f52-000000@email.amazonses.com>
In-Reply-To: <00000140c60fe2a0-aff878d7-06b3-4fe8-b97f-b319183f3f52-000000@email.amazonses.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/28/2013 1:54 PM, Christoph Lameter wrote:
> On Wed, 28 Aug 2013, Chris Metcalf wrote:
>> In addition, I applied the following commit to clean up the remaining
>> uses that are currently only being carried in the linux-tile tree.
> You are going to merge these changes right? I can drop the tile patch from
> my series?

Yes, I am, so please feel free to drop it.

> One small issue below:
>
>> diff --git a/arch/tile/kernel/time.c b/arch/tile/kernel/time.c
>> index a7a41a1..30c2c34 100644
>> --- a/arch/tile/kernel/time.c
>> +++ b/arch/tile/kernel/time.c
>> @@ -286,7 +286,7 @@ static int _set_clock_rate_barrier;
>>  static int _set_clock_rate(void *arg)
>>  {
>>         struct _set_clock_rate_args *args = arg;
>> -       struct clock_event_device *evt = &__get_cpu_var(tile_timer);
>> +       struct clock_event_device *evt = get_cpu_ptr(&tile_timer);
> 					^^^^ this_cpu_ptr

Thanks, good catch.  Annoying to have preemption disabled forever otherwise :-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

