Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbaLIAJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 19:09:33 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:37770 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688AbaLIAJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 19:09:31 -0500
MIME-Version: 1.0
In-Reply-To: <1418079603.13358.12.camel@kernel.crashing.org>
References: <1418075552-26495-1-git-send-email-yinghai@kernel.org>
	<1418079372.13358.9.camel@kernel.crashing.org>
	<1418079603.13358.12.camel@kernel.crashing.org>
Date: Mon, 8 Dec 2014 16:09:30 -0800
X-Google-Sender-Auth: HPArGFfHi9shD7nidbKifBzMc9s
Message-ID: <CAE9FiQUhwMOKEXi8mVY_rMGEAmYr13m+Gr5id+rYTC0EiwEHgw@mail.gmail.com>
Subject: Re: [PATCH] PCI: Clear bridge MEM_64 flag if one child does not
 support it
From: Yinghai Lu <yinghai@kernel.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>,
        =?UTF-8?Q?Marek_Kord=C3=ADk?= <kordikmarek@gmail.com>,
        Alexey Voronkov <zermond@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2014 at 3:00 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:

>
> I think an option would be to keep track of whether the PCI host bridge
> can do 64-bit pref above 4G.

Yes, that could be enhancement.

That should fix the problem Marek's

But not on Zermond's, as his system is not using _CRS.

Or we can enforce new rule that no _CRS then only use under 4G ?

>
> If it can't then we know 64-bit pref is always fair game for 32-bit
> resources and we can thus downgrade all the bridges 64-pref to 32-perf.
>
> If it can, then we probably do need to leave it there do real 64-bit
> pref, and shoot anything that is 32-bit only down the non-pref windows.
>
> We *could* try to be smart and scan first to check if anything under the
> bridge actually has large/64-bit BARs but that's going to be a heuristic
> at best and isn't going to do any good with hotplug.
>
> I tend to think that treating anything 32-bit pref as non-pref is in
> fact the best solution unless we know that the platform doesn't do
>>32-bit pref anyway in which case we leave them alone.

Yes, but will need to enable pci=realloc automatically, so we can take
back control
of bridge mmio bar.

Thanks

Yinghai
