Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494AbbAUJ04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 04:26:56 -0500
Received: from canardo.mork.no ([148.122.252.1]:42058 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbbAUJ0q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 04:26:46 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Alexander Duyck <alexander.duyck@gmail.com>,
        "e1000-devel\@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "Choi\, Sy Jong" <sy.jong.choi@intel.com>,
        Hayato Momma <h-momma@ce.jp.nec.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] if_link: Add VF multicast promiscuous mode control
Organization: m
References: <7F861DC0615E0C47A872E6F3C5FCDDBD05E0734E@BPXM14GP.gisp.nec.co.jp>
	<874mrlu18e.fsf@nemi.mork.no>
	<7F861DC0615E0C47A872E6F3C5FCDDBD05E07B7C@BPXM14GP.gisp.nec.co.jp>
Date: Wed, 21 Jan 2015 10:26:15 +0100
In-Reply-To: <7F861DC0615E0C47A872E6F3C5FCDDBD05E07B7C@BPXM14GP.gisp.nec.co.jp>
	(Hiroshi Shimamoto's message of "Tue, 20 Jan 2015 23:40:05 +0000")
Message-ID: <87iog0scw8.fsf@nemi.mork.no>
User-Agent: Gnus/5.130011 (Ma Gnus v0.11) Emacs/24.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.9 (canardo.mork.no [IPv6:2001:4641::1]); Wed, 21 Jan 2015 10:26:23 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> writes:

>> Why can't the ixgbevf driver just automatically signal the ixgbe driver
>> to enable multicast promiscuous mode whenever the list grows past the
>> limit?
>
> I had submitted a patch to change ixgbe and ixgbevf driver for this issue.
> https://lkml.org/lkml/2014/11/27/269
>
> The previous patch introduces API between ixgbe and ixgbevf driver to
> enable multicast promiscuous mode, and ixgbevf enables it automatically
> if the number of addresses is over than 30.
>
> I got some comment and I would like to clarify the point, but there was no
> answer.
> That's the reason I submitted this patch.

Thanks.  Yes, now I understand why you want to have a policy knob.

I still think the policy could select between "automatic"/"disallowed"
instead of "enabled"/"disabled", but that's a minor detail. Likewise is
the actual implemention of "automatic".  I think you could do that
within the current VF-PF protocol by overloading the MC address "count".

But a more generic question for netdev is: Does this VF policy API
really scale?

How many different VF policy tunables can you imaging add up over a few
years and drivers.  Currently each policy flag require its own ndo hook.
I probably don't have much to say here, but IMHO this scheme had already
failed when .ndo_set_vf_spoofchk was added..


Bjørn
