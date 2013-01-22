Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab3AVQTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 11:19:17 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:60702 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab3AVQTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 11:19:14 -0500
Message-ID: <50FEBBFC.30604@gmail.com>
Date: Wed, 23 Jan 2013 00:19:08 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [RFC PATCH v5 7/8] PCI/PCIe: add "pci=nopciehp" to disable PCIe
 native hotplug
References: <1358525267-14268-1-git-send-email-jiang.liu@huawei.com> <CAErSpo6E0SrY8_JOU6pmrCt9opfKe_jJ6b0E0daNAbpX5KtFuQ@mail.gmail.com> <CAE9FiQU6K1M=rbnhPLsAkhK5dZw8CAoQzAi=YLjtz722jCix-w@mail.gmail.com> <1449960.YISN9L5GZD@vostro.rjw.lan>
In-Reply-To: <1449960.YISN9L5GZD@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai and Rafael,
	Thanks for your comments, seems you all don't like the proposed solution,
Then how about this solution:
1) keep acpiphp and pciehp as modules
2) introduce a new interface pci_for_each_bus() to walk all PCI buses.
3) use pci_for_each_bus()  to replace ACPI PCI subdriver for acpiphp.
4) use PCI bus notifier chain to support PCI device and host bridge hotplug.
5) add some quirks to handle PCIe bridges having issues with native PCIe hotplug.

Regards!
Gerry

On 01/19/2013 06:08 AM, Rafael J. Wysocki wrote:
> On Friday, January 18, 2013 09:50:59 AM Yinghai Lu wrote:
>> On Fri, Jan 18, 2013 at 9:35 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>> If you want "pci=nopciehp" as a way for users to deal with this
>>> problem by forcing the use of acpiphp, I object.  Windows manages to
>>> make these slots work without having users do anything special, so we
>>> should be able to do it, too.
>>
>> Agreed.
>>
>> We need to think that more.
>>
>> I think that we should fix acpiphp, and should follow first come and
>> first serve for acpiphp and pciehp.
> 
> That would introduce regressions for some users, though.
> 
> I actually think we should merge acpiphp with pciehp and make one driver that
> can use both types of signalling.  There would be a problem with getting
> notifications for the same event from both sources, but that doesn't seem to
> be unsolvable.
> 
> And I don't think that that one combined driver should be modular.
> 
> Thanks,
> Rafael
> 
> 

