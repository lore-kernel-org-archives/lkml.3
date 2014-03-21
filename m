Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964977AbaCUQnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 12:43:00 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:46514 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760765AbaCUQm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 12:42:57 -0400
Message-ID: <532C6C0E.3040608@bjorling.me>
Date: Fri, 21 Mar 2014 09:42:54 -0700
From: Matias Bjorling <m@bjorling.me>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Richard Weinberger <richard.weinberger@gmail.com>
CC: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com,
        NeilBrown <neilb@suse.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC v1 00/01] dm-lightnvm introduction
References: <1395383538-18019-1-git-send-email-m@bjorling.me> <CAFLxGvxVYZtXS+PAD4gzGHb6U8HbPOajqT_sF692S-kM5bNJ9A@mail.gmail.com>
In-Reply-To: <CAFLxGvxVYZtXS+PAD4gzGHb6U8HbPOajqT_sF692S-kM5bNJ9A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 08:32 AM, Richard Weinberger wrote:
> On Fri, Mar 21, 2014 at 7:32 AM, Matias Bjørling <m@bjorling.me> wrote:
<snip>
> 
> This sounds very interesting!
> 
> Is there also a way to expose the flash directly as MTD device?
> I'm thinking of UBI. Maybe both projects can benefit from each others.
> 

Hi Richard,

Yes, mostly. It's different from MTD, in that all flash is exposed
through a linear address space, from which the FTL is layered on top.
This allows the device to still do some work, such as ECC, RAID, etc. if
it choose to, but also allows the host to do it.

I think UBI could be a good choice for maintaining each of the flash
"partitions" as there's a lot of small subtle details that have to be
taken care of.

- Matias

