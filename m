Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab3LBVi4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:38:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46298 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab3LBVix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 16:38:53 -0500
Message-ID: <529CFDE4.9070409@canonical.com>
Date: Mon, 02 Dec 2013 16:38:44 -0500
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Tim Gardner <tim.gardner@canonical.com>
Subject: Re: [REGRESSION][v3.4-rc1] PCI: add a PCI resource reallocation config
 option
References: <52965493.8060208@canonical.com> <CAE9FiQV104AgXC+EaSvBzuRg7WTLEDvQZETPeWHY4gdpg2eY_w@mail.gmail.com>
In-Reply-To: <CAE9FiQV104AgXC+EaSvBzuRg7WTLEDvQZETPeWHY4gdpg2eY_w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2013 02:17 AM, Yinghai Lu wrote:
> On Wed, Nov 27, 2013 at 12:22 PM, Joseph Salisbury
> <joseph.salisbury@canonical.com> wrote:
>> Hi Yinghai,
>>
>> A kernel bug was opened against Ubuntu [0].  After a kernel bisect, it
>> was found that the following commit introduced the bug:
>>
>> commit b07f2ebc109b607789f648dedcff4b125f9afec6
>> Author: Yinghai Lu <yinghai@kernel.org>
>> Date:   Thu Feb 23 19:23:32 2012 -0800
>>
>>     PCI: add a PCI resource reallocation config option
>>
>>
>>
>> The regression was introduced as of v3.4-rc1 and also exists in current
>> mainline.
>>
>> The bug seems platform specific since we have not had allot of other
>> reports.  The bug is preventing ixgbe to probe Intel x520 NIC's.
>>
>> It would be easy enough to disable the PCI_REALLOC_ENABLE_AUTO config
>> option, but I wanted to get your feedback since you are the author.  It
>> looks like the bug reporter may also be able to work around the problem
>> with the pci=realloc=.
> The bios has problem to have two functions rom bar to same place, and
> root bus does
> not enough mmio range and confuse realloc logic.
>
> Please try attached patches to top of linus's tree, or your internal tree.
>
> Thanks
>
> Yinghai

Hi Yinghai,

Your patches were tested against the 3.5 tree.  The patches did fix the
bug, and allowed the Intel x520 NIC's to work properly.  We were unable
to test this with Linus' tree due to another bug, which prevents the
system from booting.  We are looking deeper into that bug and should be
able to test the mainline tree at some point.

Testing against the 3.5 tree required that I cherry-pick the following
commits: ff35147, 55ed83a, 967260c and 223d96f.  However, that shouldn't
affect the test results of your patches.

Thanks for your assistance with this!


Joe

