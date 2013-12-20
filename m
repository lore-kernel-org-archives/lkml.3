Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab3LTGPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 01:15:44 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:64774 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab3LTGPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 01:15:42 -0500
MIME-Version: 1.0
In-Reply-To: <20131219221019.GB15201@google.com>
References: <1387465612-3673-33-git-send-email-levex@linux.com>
	<20131219221019.GB15201@google.com>
Date: Thu, 19 Dec 2013 22:15:41 -0800
X-Google-Sender-Auth: 8A_fO5IInwObu2KNsqU2yHLrBQ4
Message-ID: <CAE9FiQUrjCX=YzSni8YsbH-aFKtOLZ_v3-A6EcHzFY3esRb0Rw@mail.gmail.com>
Subject: Re: [PATCH 32/38] pcie: add missing put_device call
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Levente Kurusa <levex@linux.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Murray <amurray@embedded-bits.co.uk>,
        Myron Stowe <myron.stowe@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 2:10 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> [+cc Greg, Yinghai]
>
> On Thu, Dec 19, 2013 at 04:06:46PM +0100, Levente Kurusa wrote:
>> This is required so that we give up the last reference to the device.
>> Removed the kfree() as put_device will result in release_pcie_device being
>> called and hence the container of the device will be kfree'd.
>>
>> Signed-off-by: Levente Kurusa <levex@linux.com>
>
> Thanks, I applied a slightly modified version of this to my pci/deletion
> branch for v3.14.
>
> I think the get_device() after device_register() succeeds and the
> put_device() before device_unregister() are superfluous, so I propose the
> series included below.  Any comments?

Nice cleanup.

Thanks

Yinghai
