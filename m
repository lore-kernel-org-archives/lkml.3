Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965557Ab3DRDZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 23:25:38 -0400
Received: from mx2.parallels.com ([199.115.105.18]:33231 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965363Ab3DRDZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 23:25:37 -0400
Message-ID: <516F67AE.9070109@parallels.com>
Date: Wed, 17 Apr 2013 20:25:34 -0700
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: Kirill Korotaev <dev@parallels.com>, Pavel Emelianov <xemul@parallels.com>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        Brian Foster <bfoster@redhat.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>, <devel@openvz.org>,
        Anand Avati <anand.avati@gmail.com>
Subject: Re: [PATCH 0/5] fuse: close file synchronously
References: <20121220122702.4101.80042.stgit@maximpc.sw.ru> <CAJfpegsD2iyP2=Z3zL-yb_TjjQxipOBKV7yqpdPPTH9oobQ=bA@mail.gmail.com> <CAJfpegtvfunCV4cjezQuWji3PoJRpXXKWgH+y55tYMi0O+TdkQ@mail.gmail.com> <CAJfpegvJGBuOpYi=W3rzzu4Jwa46e_9SxDC4fa-PPmCQs2K3rg@mail.gmail.com>
In-Reply-To: <CAJfpegvJGBuOpYi=W3rzzu4Jwa46e_9SxDC4fa-PPmCQs2K3rg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [69.38.217.3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/17/13 1:53 PM, Miklos Szeredi wrote:
> On Mon, Apr 15, 2013 at 5:30 PM, Miklos Szeredi<miklos@szeredi.hu>  wrote:
>> Let's approach it from the other direction:  what if you give back the
>> write lease on the first flush?  It will probably work fine for 99% of
>> cases, since no other writes are going to happen after the first
>> flush.  For the remaining cases you'll just have to reacquire the
>> lease when a write happens after the flush.  I guess performance-wise
>> that will not be an issue, but I may be wrong.
> What about this?

We'd like to do it, but we can't. Firstly because we rely on the fact 
that the file cannot be modified by someone else while we hold exclusive 
write lease. By the time we decide to reacquire the lease, the file can 
be re-used by someone else and become completely different comparatively 
with its state at the moment of first flush. Secondly, we can't sensibly 
handle a case when the lease is already acquired by someone else by the 
time of attempt to reacquire it.

Thanks,
Maxim
