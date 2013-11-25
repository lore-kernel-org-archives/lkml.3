Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346Ab3KYTpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 14:45:52 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:56707 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab3KYTpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 14:45:50 -0500
MIME-Version: 1.0
In-Reply-To: <2098030.vsbrD30xN4@vostro.rjw.lan>
References: <1384866598-19716-1-git-send-email-mika.westerberg@linux.intel.com>
	<53283503.VcSP9RLiFc@vostro.rjw.lan>
	<CAE9FiQXfhK9k8j0jQ_aHt=+frrhcHZH7DQdKK3_OFo97eEAA4w@mail.gmail.com>
	<2098030.vsbrD30xN4@vostro.rjw.lan>
Date: Mon, 25 Nov 2013 11:45:50 -0800
X-Google-Sender-Auth: fL8BxVGveKur-t4d39L5kTKpQ9o
Message-ID: <CAE9FiQUuZO2BtjnG-XVoFMO5kqd97bEt9sNKzh3VZ2BJkvVnLg@mail.gmail.com>
Subject: Re: [PATCH] PCI: Move device_del() from pci_stop_dev() to pci_destroy_dev()
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tejun Heo <tj@kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 3:22 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>
> Well, is_removed is only used by pci_destroy_dev() in your patch, right?
>
> That means its only role is to protect the device from being destroyed
> twice (or more times) in a row, but that surely would be a bug?  I don't
> see how that can legitimately happen at least, so what exactly is the
> scenario?

The thread:
https://patchwork.kernel.org/patch/3119001/
