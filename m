Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760353AbaCUPcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 11:32:43 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:57877 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbaCUPcl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 11:32:41 -0400
MIME-Version: 1.0
In-Reply-To: <1395383538-18019-1-git-send-email-m@bjorling.me>
References: <1395383538-18019-1-git-send-email-m@bjorling.me>
Date: Fri, 21 Mar 2014 16:32:40 +0100
Message-ID: <CAFLxGvxVYZtXS+PAD4gzGHb6U8HbPOajqT_sF692S-kM5bNJ9A@mail.gmail.com>
Subject: Re: [PATCH RFC v1 00/01] dm-lightnvm introduction
From: Richard Weinberger <richard.weinberger@gmail.com>
To: =?ISO-8859-1?Q?Matias_Bj=F8rling?= <m@bjorling.me>
Cc: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com,
        NeilBrown <neilb@suse.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 7:32 AM, Matias Bjørling <m@bjorling.me> wrote:
> Hi,
>
> Users that have custom firmware SSDs, may choose to expose their flash directly.
> This allows the host to control logical to physical address mappings, garbage
> collection strategy, wear-leveling, and so on.
>
> This is beneficial when you either want to strip the cost of a costly controller
> or want detailed control over an SSD. Such as implementing key-value stores,
> object-stored, atomic I/Os, etc.
>
> LightNVM implements the host-side core. It supports two modes. Users that
> doesn't have hardware available and want to emulate an SSD, and users with a
> physical SSD, that has a LightNVM compatible firmware.
>
> The behavior of the core can be exposed through the various components that make
> up an FTL. Thus, it is not single implementation, but instead possible to
> mix the best algorithms for the user-space application workloads.
>
> Currently, LightNVM implements a page-based FTL, cost-based GC and simple
> wear-leveling. Additionally, it allows simulation of flash timings when hardware
> isn't available. There's work on getting it to the OpenSSD platform with a
> custom firmware and getting it stable for broad use.
>
> There is still much work to do. I'm looking for feedback on the approach, dm
> integration, and more. Any feedback is greatly appreciated.
>
> A presentation was given at the recent Non-Volatile Memory Workshop (NVMW)
> workshop. Slides are available at: http://bjorling.me/NVMW2014-LightNVM.pdf
>
> Major todo's:
>  * Patch has TODO and FIXME in places that needs to be cleaned.
>  * LightNVM compatible firmware for the OpenSSD platform and integration.
>  * Performance regressions during GC.
>  * Durability during power failure.

This sounds very interesting!

Is there also a way to expose the flash directly as MTD device?
I'm thinking of UBI. Maybe both projects can benefit from each others.

-- 
Thanks,
//richard
