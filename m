Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506Ab3C3BFA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 21:05:00 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:47153 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214Ab3C3BE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 21:04:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Len Brown <len.brown@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI, ACPI: Don't query OSC support with all possible controls
Date: Sat, 30 Mar 2013 02:12:29 +0100
Message-ID: <11307583.LtSeEfeXbs@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQWM=egh3OPcWMD+bJv2FtSsGopk_Pq0JUpQCy+pvja-6A@mail.gmail.com>
References: <1364444938-19801-1-git-send-email-yinghai@kernel.org> <2045510.EK2WTuFZxV@vostro.rjw.lan> <CAE9FiQWM=egh3OPcWMD+bJv2FtSsGopk_Pq0JUpQCy+pvja-6A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 29, 2013 06:02:45 PM Yinghai Lu wrote:
> On Fri, Mar 29, 2013 at 5:36 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> -             /* Run _OSC query for all possible controls. */
> >> -             capbuf[OSC_CONTROL_TYPE] = OSC_PCI_CONTROL_MASKS;
> >> +             /* Run _OSC query only with existing controls. */
> >> +             capbuf[OSC_CONTROL_TYPE] = root->osc_control_set;
> >
> > I suppose we can do that, but then why this should be root->osc_control_set and
> > not just 0?
> 
> in case query support and set control are called in mixed sequence.

OK, that's a good enough reason I think.

I'm kind of afarid of regressions that may result from this, though, so I'm
going to queue it up for 3.10.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
