Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbaBDCsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 21:48:55 -0500
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:43704 "HELO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752326AbaBDCsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 21:48:52 -0500
MIME-Version: 1.0
In-Reply-To: <20140131181857.GA25034@glanzmann.de>
References: <20140130204424.GB19093@glanzmann.de> <CAEP_g=-rshMcq6spFZQJMMA77bgtsETO56CfH0uY26qgAm1fdw@mail.gmail.com>
 <20140131023307.GD19871@glanzmann.de> <CAEP_g=8nzs+bRwoF99akReFO46SFa4KJ9Bw=UL0LpwbqwHvO+w@mail.gmail.com>
 <20140131181857.GA25034@glanzmann.de>
From: Jesse Gross <jesse@nicira.com>
Date: Mon, 3 Feb 2014 18:48:31 -0800
Message-ID: <CAEP_g=8Fr15BC8a910q3bXh8reeid6Bn3rKL91KPh2K8OwiwZA@mail.gmail.com>
Subject: Re: [ovs-discuss] Linus GIT Head OOPs reproducable in open vswitch
 when running mininet topology
To: Thomas Glanzmann <thomas@glanzmann.de>, Jesse Gross <jesse@nicira.com>,
        "discuss@openvswitch.org" <discuss@openvswitch.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 10:18 AM, Thomas Glanzmann <thomas@glanzmann.de> wrote:
>> Do you know if this happens with an older kernel or with a simpler topology?
>
> No, I don't. I just verified that the Ubuntu Mininet uses the
> openvswitch kernel module from openvswitch and not the one that is
> shipped with the kernel. Ubuntu precise does not crash with the exact same
> topology.

The kernel from Precise doesn't call the function that is triggering
the problem, so it's not too surprising that it doesn't have the same
issue.

It's not clear that this is actually a bug in the OVS code since it
happens in a different function and that function accesses data that
OVS doesn't really touch. Do you know if this happens with the bridge?
Or can you try bisecting? Or use gdb to track down the faulting
address?
