Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbaAJFqL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 00:46:11 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:49080 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaAJFqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 00:46:09 -0500
Message-ID: <1389332871.5567.358.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH] drivers: target: target_core_mod: use div64_u64_rem()
 instead of operator '%' for u64
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Hannes Reinecke <hare@suse.de>
Cc: Chen Gang <gang.chen.5i5j@gmail.com>, James Hogan <james.hogan@imgtec.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Date: Thu, 09 Jan 2014 21:47:51 -0800
In-Reply-To: <52CE7720.6060809@suse.de>
References: <52B4F837.1010403@gmail.com>
	 <1387680997.5567.91.camel@haakon3.risingtidesystems.com>
	 <52B6AE19.80401@gmail.com>
	 <1387781487.5567.147.camel@haakon3.risingtidesystems.com>
	 <52B90111.5050203@gmail.com> <52CCFF0C.7070704@suse.de>
	 <1389223117.5567.271.camel@haakon3.risingtidesystems.com>
	 <52CE7720.6060809@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-09 at 11:17 +0100, Hannes Reinecke wrote:
> On 01/09/2014 12:18 AM, Nicholas A. Bellinger wrote:
> > On Wed, 2014-01-08 at 08:32 +0100, Hannes Reinecke wrote:

<SNIP>

> >> Other than that the sector_div() patch is correct.
> >>
> >
> > <nod> Thanks for confirming that sector_div() is correct here vs. the
> > original code using modulo that Chen had pointed out.
> >
> Ah, _that_ was the issue.
> I was wondering why you kept on poking me ...
> 
> Well.
> No, that's actually _not_ correct.
> The correct fix would be
> 
> diff --git a/drivers/target/target_core_alua.c 
> b/drivers/target/target_core_alua.c
> index 54b1e52..12da9b3 100644
> --- a/drivers/target/target_core_alua.c
> +++ b/drivers/target/target_core_alua.c
> @@ -500,8 +500,7 @@ static inline int core_alua_state_lba_dependent(
> 
>                          if (segment_mult) {
>                                  u64 tmp = lba;
> -                               sector_div(tmp, segment_size * segment_mult);
> -                               start_lba = tmp;
> +                               start_lba = sector_div(tmp, segment_size * segment_mult);
> 
>                                  last_lba = first_lba + segment_size - 1;
>                                  if (start_lba >= first_lba &&
> (beware of line breaks ...)
> Thing is, we need to calculate the offset into the segment to figure out 
> which map entry to use.
> The actual number of the segment (as had been calculated with the 
> original fix) is immaterial here.
> 
> Sorry for this. The email thread just flew past me during Xmas
> with me not paying real attention.
> 

Applied + squashed.  Apologies for the initial pre-holiday BUG..

Thanks Hannes!

--nab

