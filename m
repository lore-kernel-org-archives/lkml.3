Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbaLIXNw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 18:13:52 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:51962 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbaLIXNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 18:13:50 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo5tZU=zBKNDt2UtUE_AMG3zzrdq2CX2A4ZL7tdLELXgqA@mail.gmail.com>
References: <1418160871-5605-1-git-send-email-yinghai@kernel.org>
	<CAErSpo5tZU=zBKNDt2UtUE_AMG3zzrdq2CX2A4ZL7tdLELXgqA@mail.gmail.com>
Date: Tue, 9 Dec 2014 15:13:49 -0800
X-Google-Sender-Auth: oQl5-n9IT7G053HyEcTsdGhcnZE
Message-ID: <CAE9FiQWLaNSsFTWEpWRFR4xTd0hKOwENdQR7N6T=K65VM+vDQg@mail.gmail.com>
Subject: Re: [PATCH] PCI: Clear all bridge res MEM_64 if host bridge has non mem64
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?Q?Marek_Kord=C3=ADk?= <kordikmarek@gmail.com>,
        Alexey Voronkov <zermond@gmail.com>,
        Wei Yang <weiyang@linux.vnet.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 9, 2014 at 1:53 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Tue, Dec 9, 2014 at 2:34 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> +       list_for_each_entry(window, &bridge->windows, list) {
>> +               res = window->res;
>> +               if (resource_type(res) == IORESOURCE_MEM ||
>> +                   res->end > 0xffffffff) {
>> +                       bridge->has_mem64_res = true;
>
> This is an interesting idea, but I think you're checking CPU addresses
> here, and you need to check PCI bus addresses.

Looks like those IBM platforms have res > 4g, but pci bus address < 4g.
If we check pci bus address, and then we would break those platforms.

Yinghai
