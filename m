Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567AbaKMKWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 05:22:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932241AbaKMKWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 05:22:50 -0500
Message-ID: <1415874150.15503.5.camel@localhost>
Subject: Re: randconfig build error with next-20141112, in net/sched
From: Hannes Frederic Sowa <hannes@redhat.com>
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, jhs@mojatatu.com,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Date: Thu, 13 Nov 2014 11:22:30 +0100
In-Reply-To: <CA+r1ZhjMGJVSdp71pQ5aHjAvDDxDYBsgzmwcnt5oNyZTmdZDiw@mail.gmail.com>
References: <CA+r1ZhjMGJVSdp71pQ5aHjAvDDxDYBsgzmwcnt5oNyZTmdZDiw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mi, 2014-11-12 at 15:33 -0700, Jim Davis wrote:
> Building with the attached random configuration file,
> 
> ERROR: "reciprocal_value" [net/sched/sch_sfq.ko] undefined!
> ERROR: "reciprocal_value" [net/sched/sch_netem.ko] undefined!

Thanks for the report. I think moving reciproval_div.o from lib-y to
obj-y should resolve the problem. On it...

The problem with lib-y is, if vmlinux itself doesn't use the symbol,
even if it is EXPORT_SYMBOLED, it won't be linked into the kernel. You
seem to hit a configuration where reciproval_divide wasn't used in the
kernel at all but only in modules, as such it got purged from vmlinux
during linking.

Thanks,
Hannes


