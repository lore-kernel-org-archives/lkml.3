Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978Ab3CUJOE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 05:14:04 -0400
Received: from na3sys010aog111.obsmtp.com ([74.125.245.90]:34157 "HELO
	na3sys010aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756702Ab3CUJOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 05:14:00 -0400
MIME-Version: 1.0
In-Reply-To: <20130321085107.GE28328@redhat.com>
References: <20130321061838.GA28319@redhat.com> <CAL1RGDUcMj9QVsuQgK+ozw64L6-cGehL7YBUJ1_ckni6TD=Kcg@mail.gmail.com>
 <20130321070357.GD28328@redhat.com> <CAG4TOxPkhOhGmzeA1K4a0Zw8HxS-QkOr-PCx7mJgA+KkuH3ZiQ@mail.gmail.com>
 <20130321085107.GE28328@redhat.com>
From: Roland Dreier <roland@kernel.org>
Date: Thu, 21 Mar 2013 02:13:38 -0700
X-Google-Sender-Auth: 4ZRHNxO1nkdCdcKromBee6KgSmM
Message-ID: <CAL1RGDVnkLZU2Vge4o3BwDxnAfGv7TQRMqE6ha3MUt39CVp5NQ@mail.gmail.com>
Subject: Re: [PATCH] rdma: don't make pages writeable if not requiested
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Michael R. Hines" <mrhines@linux.vnet.ibm.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Yishai Hadas <yishaih@mellanox.com>, Christoph Lameter <cl@linux.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, qemu-devel@nongnu.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 1:51 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
>> In that case, no, I don't see any reason for LOCAL_WRITE, since the
>> only RDMA operations that will access this memory are remote reads.
>
> What is the meaning of LOCAL_WRITE then? There are no local
> RDMA writes as far as I can see.

Umm, it means you're giving the local adapter permission to write to
that memory.  So you can use it as a receive buffer or as the target
for remote data from an RDMA read operation.

> OK then what we need is a new flag saying "I really do not
> intend to write into this memory please do not break
> COW or do anything else just in case I do".

Isn't that a shared read-only mapping?

 - R.
