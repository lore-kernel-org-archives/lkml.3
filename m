Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab3H0SDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 14:03:25 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:56684 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab3H0SDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 14:03:22 -0400
MIME-Version: 1.0
In-Reply-To: <521CCF9B.9000004@wwwdotorg.org>
References: <1376911241-27720-1-git-send-email-Julia.Lawall@lip6.fr>
 <1376911241-27720-2-git-send-email-Julia.Lawall@lip6.fr> <20130819120249.GA5740@ulmo>
 <CAErSpo5oOnfhi+aRi-Z3kCwS1VpYSO6FX5O_MOZmWNLcfhhA9w@mail.gmail.com>
 <20130819201224.GC5191@mithrandir> <CAErSpo6U9i16gdaYGpWqgLaFteXpy1erCUw55SqkHLcbypP=vA@mail.gmail.com>
 <20130827081443.GI8686@ulmo> <521CCF9B.9000004@wwwdotorg.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 27 Aug 2013 12:03:01 -0600
Message-ID: <CAErSpo461H=3qD5Xb7rKkMcQ1_ipyAQ5Tv2VhZD4j578A+Bd9w@mail.gmail.com>
Subject: Re: [PATCH 1/7] PCI: tegra: replace devm_request_and_ioremap by devm_ioremap_resource
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>, kernel-janitors@vger.kernel.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 10:11 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 08/27/2013 02:14 AM, Thierry Reding wrote:
>> On Mon, Aug 19, 2013 at 02:49:07PM -0600, Bjorn Helgaas wrote:
>>> On Mon, Aug 19, 2013 at 2:12 PM, Thierry Reding
>>> <thierry.reding@gmail.com> wrote:
>>>> On Mon, Aug 19, 2013 at 02:04:24PM -0600, Bjorn Helgaas wrote:
>>>>> On Mon, Aug 19, 2013 at 6:02 AM, Thierry Reding
>>>>> <thierry.reding@gmail.com> wrote:
>>>>>
>>>>>> Bjorn, how do you want to handle patches to the Tegra PCIe
>>>>>> driver in the future? Do you want me to prepare a branch
>>>>>> and pull from that or would you rather just take simple
>>>>>> patches?
>>>>>
>>>>> I'm in the habit of applying patches from email, so that's
>>>>> easy for me.  But a branch would be OK, too.
>>>>
>>>> Patches work for me too. Is this cleanup patch something that
>>>> you'd be comfortable with applying after 3.12-rc1 or would you
>>>> rather defer it to 3.13?
>>>
>>> I'm not really sure how we should manage drivers/pci/host/*.
>>> Those files are mostly arch code, and I'm not sure it's useful
>>> for me to be in the middle of managing them.
>>>
>>> I assume Stephen or somebody has a tree with the pci-tegra.c
>>> stuff that's in -next right now; it seems like it'd be simplest
>>> to just add this patch there and merge in during the v3.12 merge
>>> window.
>>
>> If Stephen's fine with it I suppose we could take pci-tegra.c
>> driver changes through the Tegra tree. But I think it'd be good if
>> we could still Cc you on patches so you're aware of what we're
>> doing (that is the same for all drivers drivers/pci/host/*). And
>> we're going to need your Acked-by on the patches as well.

I think you have my Acked-by for this case already (from Aug 20).  And
feel free to copy me on anything you like; my delete key works well :)

> I can push Tegra PCIe patches through the arm-soc tree before
> 3.12-rc1, but after that point, I think it's best if they go through
> the PCIe tree, unless there's some cross-subsystem dependency for a
> specific patch, and with the new PCIe driver, that's less likely.

I'm OK with merging things through my tree.  It just seemed like there
was a lot of recent Tegra activity that included a few Tegra PCI
changes, and no benefit to trying to split the PCI stuff from the
non-PCI stuff.  Hopefully it will calm down, because I don't have time
to be in the middle of major Tegra stuff.

Bjorn
