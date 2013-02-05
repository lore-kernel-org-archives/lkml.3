Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab3BEGr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 01:47:59 -0500
Received: from cs-smtp-2.Stanford.EDU ([171.64.64.26]:54413 "EHLO
	cs-smtp-2.Stanford.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab3BEGr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 01:47:58 -0500
X-Greylist: delayed 2379 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Feb 2013 01:47:58 EST
From: Ben Pfaff <blp@cs.stanford.edu>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Cong Wang <xiyou.wangcong@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Jesse Gross <jesse@nicira.com>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: No sysfs directory for openvswitch module when built-in
References: <CAM_iQpVgEchb8UsxUP=w6OMbYx=zuP2yv=QwFhe8rPCbNBreVg@mail.gmail.com>
	<20130204081920.00e9f22e@nehalam.linuxnetplumber.net>
Reply-To: blp@cs.stanford.edu
Date: Mon, 04 Feb 2013 22:08:13 -0800
In-Reply-To: <20130204081920.00e9f22e@nehalam.linuxnetplumber.net> (Stephen
	Hemminger's message of "Mon, 4 Feb 2013 08:19:20 -0800")
Message-ID: <87lib3gunm.fsf@blp.benpfaff.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Spam-Score: -1.0
X-Scan-Signature: 6bee508a35d8245455fa42c2dd36c733
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger <stephen@networkplumber.org> writes:

> On Tue, 29 Jan 2013 22:15:18 +0800
> Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
>> Hello, Rusty, Jesse,
>> 
>> I met an interesting problem when I compile openvswitch module as a
>> built-in (actually I compile ALL kernel modules as built-in), there is
>> no /sys/module/openvswitch/ directory created by the kernel in this
>> case.
>> 
>> What's worse, the user-space init script thinks openvswitch module is
>> not loaded by checking the exist of this directory, therefore refuses
>> to start.
>
> Shouldn't the OVS init script be testing for some other API.

I agree that's a bug in the OVS init script.  I will fix it.
