Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932958Ab3LIULE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 15:11:04 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:48958 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440Ab3LIUK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 15:10:59 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo5+jY-P-9iUj0RVqyZzXwQcq9m9PqWKzZDU0yjK=4gAeQ@mail.gmail.com>
References: <1386546869-31900-1-git-send-email-yinghai@kernel.org>
	<1386546869-31900-3-git-send-email-yinghai@kernel.org>
	<CAErSpo6VvV21DyHuHLcsA+_KPQcYdAWXtaVbZGUA-M9+iji0fw@mail.gmail.com>
	<CAE9FiQUWFoyg_7TPaBVftpojCocNu0=1yWtqKTBvkQkRhNOnhg@mail.gmail.com>
	<CAErSpo5+jY-P-9iUj0RVqyZzXwQcq9m9PqWKzZDU0yjK=4gAeQ@mail.gmail.com>
Date: Mon, 9 Dec 2013 12:10:58 -0800
X-Google-Sender-Auth: _sbkmBAYC0UjpE5oIzjzt2UC0lQ
Message-ID: <CAE9FiQXf6w0u+JLu-JHd45ofSTShaB0MoMNbck9EE-y3u6B98w@mail.gmail.com>
Subject: Re: [PATCH 2/2] PCI: Only enable realloc auto when root bus has 64bit mmio
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 9, 2013 at 11:42 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> That doesn't answer my question at all.
>
> I understand that this change makes it so Joseph doesn't have to use
> "pci=realloc=off".  But why should auto-reallocation be limited to
> buses that have resources above 4GB?  That doesn't make any sense.
>
> We should fix the reallocation code so it can deal with this case.  If
> there's not enough space for everything, obviously we have to leave
> something unassigned.  A ROM BAR is a good candidate for leaving
> unassigned, because most of the time we can get along without it.

Yes, that is ideal and not that simple.
but that would be hard to backport to old kernels.

BTW, Joseph, can you try
git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
for-pci-3.14
with pci=realloc=on

on that system?

Thanks

Yinghai
