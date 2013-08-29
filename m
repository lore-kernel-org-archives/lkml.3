Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab3H2WqN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 18:46:13 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:35928 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab3H2WqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 18:46:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo4qEPQq==rmzy+8a2FHgaKmWbG7BvopKqbBZC551kgdcg@mail.gmail.com>
References: <CAErSpo4cC7XKQn+2Pg9r+VDrcqKP4M4KQFRqQAvegTbnkUWf+A@mail.gmail.com>
	<CAE9FiQX9gU-S9X_eeB=JwqS8130CONKgrv+mGj1cEgShmxgS-Q@mail.gmail.com>
	<CAErSpo4qEPQq==rmzy+8a2FHgaKmWbG7BvopKqbBZC551kgdcg@mail.gmail.com>
Date: Thu, 29 Aug 2013 15:46:10 -0700
X-Google-Sender-Auth: bhGh-V3Ou4rvmHw8SsNo0hEvL2E
Message-ID: <CAE9FiQVXri56BzLviVjSPnqQvo25Q36AA26V_28kfy_=9EunjA@mail.gmail.com>
Subject: Re: [PATCH v8 6/6] PCI: update device mps when doing pci hotplug
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yijing Wang <wangyijing@huawei.com>, Jon Mason <jdmason@kudzu.us>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        Jin Feng <joe.jin@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 3:22 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>
> Note that I think Linux *should* eventually actively manage MPS, and
> when it does, case 3 should "just work".  I just don't understand what
> the point of the BIOS using case 3 is.
>
> I suppose other OSes must get better performance in this "auto" mode?

Yes.

> (What exactly is that mode, anyway?)  That means the other OS must be
> smart enough to deal with hotplug device replacement, but not smart
> enough to configure MPS all by itself starting from scratch.  I don't
> know what rules would tell us "this MPS must be configured by the BIOS
> and the OS should leave it alone" and "the OS must configure MPS on
> this device for hotplug."  How can we make sense out of that?

So my suggestion:
We scan mps of in the bridges to find out if any is set to other than 128.
if there is any bridge that mps is not 128 and it is hotplug slot.
We change to PCI_BUS_TUNE_PERF for that system.

Yinghai
