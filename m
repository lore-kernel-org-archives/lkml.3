Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab3L1M5i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 07:57:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755356Ab3L1M5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 07:57:36 -0500
Date: Sat, 28 Dec 2013 12:57:25 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Shaohua Li <shli@kernel.org>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk,
        agk@redhat.com, snitzer@redhat.com
Subject: Re: [dm-devel] [PATCG]DM: dm-compression: a compressed DM target
	for SSD
Message-ID: <20131228125725.GA16613@agk-dp.fab.redhat.com>
Mail-Followup-To: Shaohua Li <shli@kernel.org>,
	linux-kernel@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk,
	agk@redhat.com, snitzer@redhat.com
References: <20131227062421.GA21053@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131227062421.GA21053@kernel.org>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've not looked at this in any depth, but here are some first
impressions:

On Fri, Dec 27, 2013 at 02:24:21PM +0800, Shaohua Li wrote:
> This is a simple DM target supporting compression for SSD only.

Presumably there'll be other disk layouts and other types of compression
in future, so if you want to grab the generic name "compression" then
please make sure the interface to the code supports such extensions.
Use of the term "SSD" may also be too narrow as there could be other
technologies that are not labelled "SSD" that could benefit from the
target.  At best, we say "for example, ssd" leaving things open for
other uses.

IOW EITHER you should make it modular and supply a name to the ctr that
tells it to use this specific combination OR if you don't think there'll
need to be shared code with other compression types/disk layouts, rename
this particular one to something more specific.

For this naming, focus on the key feature of the code, which seems to me
to be the "in-place" or "in situ" nature of the so-called compression.
- If you don't have some form of thin provisioning underneath, why would
you use this?  
  => dm-compress-inplace / insitu
  => dm-compinsitu
  => dm-compress-thin  (sub-module loaded from dm-compress)
  => dm-compressthin   (standalone target)
     -lzo ?

To use this compression target above dm-thin (likely to prefer larger
block sizes), for example, could the block sizes be adapatable /
configurable?

Please use dm_ / DM_ prefixes - with underscore - and choose one prefix
to use consistently.  I see "cp" (makes me think "copy") as well as
"comp".

We don't label the fields in the STATUSTYPE_INFO output.

Do write Documentation/device-mapper/<target_name_without_leading_dm>.txt.
E.g. what you wrote in the patch header should be moved into that file
instead.  (Use a recent documentation file as a model for the format of
the file, such as verity or thin-provisioning.)

And don't be afraid to include more comments in the code for the benefit
of people who are unfamiliar with the nuances of device-mapper
targets:)

Alasdair

