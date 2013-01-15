Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255Ab3AOVq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 16:46:59 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:41428 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754976Ab3AOVq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 16:46:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v8 02/22] PCI: Add root bus children dev's res to fail list
Date: Tue, 15 Jan 2013 22:52:47 +0100
Message-ID: <10292702.MPeC4p1tfP@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQV1pvteSymLp=pHi=fNjHcfGe+TA84s2Ob9Tfne54fOmg@mail.gmail.com>
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org> <5313709.Qx2p1IPKbV@vostro.rjw.lan> <CAE9FiQV1pvteSymLp=pHi=fNjHcfGe+TA84s2Ob9Tfne54fOmg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 15, 2013 07:44:21 AM Yinghai Lu wrote:
> On Tue, Jan 15, 2013 at 3:21 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Monday, January 14, 2013 10:23:47 PM Yinghai Lu wrote:
> >> On Sat, Jan 12, 2013 at 1:37 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> > On Friday, January 11, 2013 02:40:29 PM Yinghai Lu wrote:
> >> >> We can stop trying according to try number now and do not need to use
> >> >> root_bus checking as stop sign anymore.
> >> >>
> >> >> In extreme case we could need to reallocate resource for device just
> >> >> under root bus.
> >> >
> >> > Well, the above says that we _can_ do the change, but it doesn't explain why it
> >> > is needed.  So what's the reason why we need to do that?
> >>
> >> In extreme case we could need to reallocate resource for device just
> >> under root bus.
> >>
> >> otherwise, those devices just under root bus will not be assigned
> >> resources again.
> >
> > IOW, our current code will not cover the case when we hot plug a host bridge
> > and need to reassign resources for devices integrated into it?
> 
> yes. in extreme case if _CRS range is not big enough.

It would be good to say that in the changelog too.  It's a clear justification
for the change if we're going to support root bridge hotplug (which we are).

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
