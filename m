Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679AbaLEGZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 01:25:12 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:53305 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbaLEGZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 01:25:08 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1412041520270.14925@gentwo.org>
References: <547E3E57.3040908@ixiacom.com>
	<20141204175713.GE2995@htj.dyndns.org>
	<5480BFAA.2020106@ixiacom.com>
	<alpine.DEB.2.11.1412041426230.14577@gentwo.org>
	<20141204205202.GP29748@ZenIV.linux.org.uk>
	<alpine.DEB.2.11.1412041514250.14832@gentwo.org>
	<20141204211912.GG4080@htj.dyndns.org>
	<alpine.DEB.2.11.1412041520270.14925@gentwo.org>
Date: Fri, 5 Dec 2014 10:25:07 +0400
Message-ID: <CALYGNiNioi3qaRy8VOSBshWtCBJc_qq4FRVVX85F+_aA6QtfKg@mail.gmail.com>
Subject: Re: [RFC v2] percpu: Add a separate function to merge free areas
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Leonard Crestez <lcrestez@ixiacom.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sorin Dumitru <sdumitru@ixiacom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 5, 2014 at 12:20 AM, Christoph Lameter <cl@linux.com> wrote:
> On Thu, 4 Dec 2014, Tejun Heo wrote:
>
>> Docker usage is pretty wide-spread now, making what used to be
>> siberia-cold paths hot enough to cause actual scalability issues.
>> Besides, we're now using percpu_ref for things like aio and cgroup
>> control structures which can be created and destroyed quite
>> frequently.  I don't think we can say these are "weird" use cases
>> anymore.
>
> Well then lets write a scalable percpu allocator.

percpu allocator maybe be overkill but I think it's worth to make
kmem_cache-like thing with pool of objects.

>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
