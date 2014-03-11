Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbaCKXy7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 19:54:59 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:49079 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755535AbaCKXy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 19:54:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo5Xxr96hsNxO5HrxV31B4Uh=oTsTgfQ-CfHNXP+quM+kg@mail.gmail.com>
References: <20140311173556.23084.57635.stgit@bhelgaas-glaptop.roam.corp.google.com>
	<20140311174243.23084.77689.stgit@bhelgaas-glaptop.roam.corp.google.com>
	<CAE9FiQVdk6Tg4tNPQihm2YJ5BQO8jrQXfQfgVOSXTaK3o76yqg@mail.gmail.com>
	<CAErSpo5Xxr96hsNxO5HrxV31B4Uh=oTsTgfQ-CfHNXP+quM+kg@mail.gmail.com>
Date: Tue, 11 Mar 2014 16:54:57 -0700
X-Google-Sender-Auth: uHtGSEzRfTIysD98AdJhvjMxwvw
Message-ID: <CAE9FiQVVEbHQGV0i_kXVFZFZLFH4sv0OsKLOVnDYDg30S9NrDA@mail.gmail.com>
Subject: Re: [PATCH 1/5] PCI: Don't check resource_size() in pci_bus_alloc_resource()
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Paul Bolle <pebolle@tiscali.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 3:02 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Tue, Mar 11, 2014 at 3:39 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> how about replacing that with:
>>
>>         if (avail.start > avail.end)
>>                   continue;
>>
>> so we do not need to go deep into allocate_resource()
>
> We could, but why bother?  This isn't a performance path, so there's
> no need to add more code to optimize it.  Adding code means there's
> more for human readers to look at and understand, so I prefer not to
> add it unless it's needed.

oh, i did not look further, if the code path could handle strange
constraints properly.
like min > max.

Thanks

Yinghai
