Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbaIBTaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 15:30:25 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:35104 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106AbaIBTaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 15:30:22 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo5_WMUmnTHpPZt+j04VZoiW1pthQoGV90A5BDQpQgjwOQ@mail.gmail.com>
References: <53FFA54D.9000907@gmail.com>
	<CAErSpo5_WMUmnTHpPZt+j04VZoiW1pthQoGV90A5BDQpQgjwOQ@mail.gmail.com>
Date: Tue, 2 Sep 2014 12:30:21 -0700
X-Google-Sender-Auth: 3mkCnSy5UYSDm8OQR1z0jpezCso
Message-ID: <CA+55aFy63sEs2zvr0LzKSjxSRuH5paLG378qQ6_QyLmmJw=D3w@mail.gmail.com>
Subject: Re: [PATCH] pci/probe: Enable CRS for Intel Haswell root ports
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Rajat Jain <rajatxjain@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajat Jain <rajatjain@juniper.net>, Guenter Roeck <groeck@juniper.net>,
        Richard Yang <weiyang@linux.vnet.ibm.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 1, 2014 at 9:14 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>
> I'm not a fan of adding a whitelist for devices that work correctly.
> I don't think that's a maintainable solution.  Since we haven't had
> many systems yet that care about CRS, some kind of "enable CRS on
> machines newer than X" might work.

I'd suggest trying to just enable CRS unconditionally (ie revert my
old commit ad7edfe04908). We've done other changes in this area since,
and in particular, it's entirely possible that the original problem we
had doesn't even trigger any more.

In particular, looking at one of the old reports, I don't see that
"Device %04x:%02x:%02x.%d not responding" warning that we *should*
have triggered in pci_scan_device(). So I wonder if we had some case
that read the vendor ID without that whole loop, and that _that_ was
our fundamental problem.

It would be great if somebody could test with the old hardware that
triggered the problem originally, but those reports are from 2007, so
it might be hard to find anything relevant today. But trying to just
go back to unconditionally enabling CRS (say, in 3.18-rc1) and seeing
if anybody hollers, might just be the right approach.

            Linus
