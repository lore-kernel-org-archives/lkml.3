Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab3END4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 23:56:55 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:55977 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755606Ab3END4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 23:56:53 -0400
MIME-Version: 1.0
In-Reply-To: <5191AD65.7090105@huawei.com>
References: <1368498506-25857-1-git-send-email-yinghai@kernel.org>
	<1368498506-25857-3-git-send-email-yinghai@kernel.org>
	<5191AD65.7090105@huawei.com>
Date: Mon, 13 May 2013 20:56:53 -0700
X-Google-Sender-Auth: bRegfUiIK-2dlbHp2TiizZ_DsyE
Message-ID: <CAE9FiQWty+iSv3RdfesoyDZ3q15QeX4fJGFcXS8PxTCese-XzQ@mail.gmail.com>
Subject: Re: [PATCH 2/7] PCI: move resources and bus_list releasing to pci_release_dev
From: Yinghai Lu <yinghai@kernel.org>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Gu Zheng <guz.fnst@cn.fujitsu.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 8:20 PM, Yijing Wang <wangyijing@huawei.com> wrote:
> On 2013/5/14 10:28, Yinghai Lu wrote:
>> We should not release resource in pci_destroy that is too early
>
> Hi Yinghai,
>    "too early" means that after pci_stop_dev(), if someone else
> hold the device reference, it still care the device resource ? e.g.?

I don't mean that.

>
>> as there could be still other use hold reference.

purpose is:
move res releasing as late as possible. so pci_stop_and_remove_bus_device
could be called several times for nested removing via sys.

Yinghai
