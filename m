Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761559Ab3LITn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 14:43:27 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:52965 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759848Ab3LITmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 14:42:50 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQUWFoyg_7TPaBVftpojCocNu0=1yWtqKTBvkQkRhNOnhg@mail.gmail.com>
References: <1386546869-31900-1-git-send-email-yinghai@kernel.org>
 <1386546869-31900-3-git-send-email-yinghai@kernel.org> <CAErSpo6VvV21DyHuHLcsA+_KPQcYdAWXtaVbZGUA-M9+iji0fw@mail.gmail.com>
 <CAE9FiQUWFoyg_7TPaBVftpojCocNu0=1yWtqKTBvkQkRhNOnhg@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 9 Dec 2013 12:42:29 -0700
Message-ID: <CAErSpo5+jY-P-9iUj0RVqyZzXwQcq9m9PqWKzZDU0yjK=4gAeQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] PCI: Only enable realloc auto when root bus has 64bit mmio
To: Yinghai Lu <yinghai@kernel.org>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 9, 2013 at 12:20 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Dec 9, 2013 at 9:54 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> I don't see how the question of whether the host bridge has an
>> aperture above 4G is related to whether we should automatically
>> reassign resources.  They seem orthogonal to me.  No doubt it "fixes"
>> the current problem, but it doesn't make sense conceptually.
>
> the BIOS has problem to have two functions point to same position.
>
> During realloc first try: standard+two rom_bar+sriov will be fail at first as
> pci root bus does not have enough mmio range,
> later try will standard+two rom_bar it will fail too as root bus mmio range will
> still only fit standard+one rom_bar.
>
> My thoughts is limit use realloc auto in those systems that does not have mmio64
> above 4g...
> so old system will never have to specify "pci=realloc=off" to disable it.

That doesn't answer my question at all.

I understand that this change makes it so Joseph doesn't have to use
"pci=realloc=off".  But why should auto-reallocation be limited to
buses that have resources above 4GB?  That doesn't make any sense.

We should fix the reallocation code so it can deal with this case.  If
there's not enough space for everything, obviously we have to leave
something unassigned.  A ROM BAR is a good candidate for leaving
unassigned, because most of the time we can get along without it.

Bjorn
