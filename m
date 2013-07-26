Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678Ab3GZQzR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 12:55:17 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:38755 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756835Ab3GZQzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 12:55:13 -0400
MIME-Version: 1.0
In-Reply-To: <20130726102240.GA30786@mtj.dyndns.org>
References: <1374749531-16423-1-git-send-email-laijs@cn.fujitsu.com>
	<20130725153121.GF26107@mtj.dyndns.org>
	<51F1DB45.90905@cn.fujitsu.com>
	<20130726030711.GA30195@mtj.dyndns.org>
	<51F1F138.2060902@cn.fujitsu.com>
	<20130726102240.GA30786@mtj.dyndns.org>
Date: Sat, 27 Jul 2013 00:55:12 +0800
Message-ID: <CACvQF52TC4L58WwvhJ9sYiBj2vFdLG2iCb5Fvs2a8Ti19DpAWA@mail.gmail.com>
Subject: Re: [PATCH] workqueue: clear workers of a pool after the CPU is offline
From: Lai Jiangshan <eag0628@gmail.com>
To: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 6:22 PM, Tejun Heo <tj@kernel.org> wrote:
> On Fri, Jul 26, 2013 at 11:47:04AM +0800, Lai Jiangshan wrote:
>> any worker can't kill itself.
>> managers always tries to leave 2 workers.
>>
>> so the workers of the offline cpu pool can't be totally destroyed.
>
> But we *do* want to keep them around as CPUs taken offline are likely
> to come online at some point and destroying all of them saves only
> ~16k of memory while adding more work while CPUs are on/offlined which

4 threads, (normal and high priority wq)
~32k
it is still small.

> can be very frequent on mobile devices.  The change was *intentional*.

but sometimes the cpu is offline for long time.
and maybe the adminstrator want to reclaim the resource..

Add a boot option or sysfs switch?

>
> Thanks.
>
> --
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
