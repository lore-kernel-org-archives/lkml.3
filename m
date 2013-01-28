Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab3A1Hi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 02:38:28 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:4300 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166Ab3A1Hi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 02:38:26 -0500
Message-ID: <51062ADA.6080903@huawei.com>
Date: Mon, 28 Jan 2013 15:38:02 +0800
From: Jiang Liu <jiang.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>, Gu Zheng <guz.fnst@cn.fujitsu.com>,
        Lin Feng <linfeng@cn.fujitsu.com>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>,
        <laijs@cn.fujitsu.com>, <wency@cn.fujitsu.com>,
        <izumi.taku@jp.fujitsu.com>, Don Dutile <ddutile@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] pci-sysfs: replace mutex_lock with mutex_trylock to avoid
 potential deadlock situation
References: <1356594177-29453-1-git-send-email-linfeng@cn.fujitsu.com> <CAErSpo7EmvDaK11P6r-PKxPBqHQBPaGvZj=zvNZ8w=KFbdFgYA@mail.gmail.com> <5102583E.4030109@cn.fujitsu.com> <CAErSpo58qUuwd+8bGMWQHQ6KrfQMvHGb+REVkpJqQdrfAQe3Qw@mail.gmail.com> <CAE9FiQUP71TJgP21SRre4Mb2PrnUg+7KLzXnxHUviqCuNSL44w@mail.gmail.com> <CAErSpo4_iz29b9Tj8W4D9YqdGPV4P+rFZ463eZ1S4J2gL_6qyw@mail.gmail.com> <CAE9FiQVV20XktXTfQ2OKQeprL1V2rGORpUf8VBOyDB4Y+VOCNQ@mail.gmail.com>
In-Reply-To: <CAE9FiQVV20XktXTfQ2OKQeprL1V2rGORpUf8VBOyDB4Y+VOCNQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.108.108.229]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
	I have worked out a draft patch set to serialize hotplug operations,
but encountered some obstacles when dealing with PCI root buses. I will
try to rebase the patch set onto "PCI: Iterate pci host bridge instead of
pci root bus" from Yinghai. And also need to fix bugs reported by Lin Feng
too.

Regards!
Gerry

On 2013-1-26 4:59, Yinghai Lu wrote:
> On Fri, Jan 25, 2013 at 12:30 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> 
>> If we're going to fix the sysfs deadlock (and we should), I want to
>> either see an argument for why we don't have a problem outside of
>> sysfs, or I want to fix sysfs and non-sysfs at the same time.
> 
> Sure.
> 
> Jiang should have one patches to address that?
> 
> Yinghai
> 
> 


