Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751143Ab3HSJ36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 05:29:58 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:63538 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab3HSJ35 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 05:29:57 -0400
MIME-Version: 1.0
In-Reply-To: <5211DD5C.1080306@inria.fr>
References: <51F8F14C.8060507@inria.fr>
	<CAA9_cmcvssPaatgHe8jCaDTfWe4X2GkWVorvMRxaX7tz2s131w@mail.gmail.com>
	<5211DD5C.1080306@inria.fr>
Date: Mon, 19 Aug 2013 02:29:55 -0700
X-Google-Sender-Auth: 0A3heuhLTEzoZUia4sqAkVJpBEE
Message-ID: <CAA9_cmdLDxtmFJ=UM6jykWp25Eff4e=6m=vTVeDAkLxEj4YitQ@mail.gmail.com>
Subject: Re: dmaengine: make dma_channel_rebalance() NUMA aware
From: Dan Williams <djbw@fb.com>
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Vinod Koul <vinod.koul@intel.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 1:54 AM, Brice Goglin <Brice.Goglin@inria.fr> wrote:
> Le 19/08/2013 10:19, Dan Williams a écrit :
>>>   * @cap: capability to match
>>> - * @n: nth channel desired
>>> + * @cpu: cpu index which the channel should be close to
>>>   *
>>> - * Defaults to returning the channel with the desired capability and the
>>> - * lowest reference count when 'n' cannot be satisfied.  Must be called
>>> - * under dma_list_mutex.
>>> + * If some channels are close to the given cpu, the one with the lowest
>>> + * reference count is returned. Otherwise, cpu is ignored and only the
>>> + * reference count is taken into account.
>> I think we can drop these comments and the distinction, see below.
>
> I understand that we can remove the cpu==-1 case, but I don't see why we
> would remove the 3 last lines above. The code still looks for a
> NUMA-local channels first.

Ah yes, it still handles the "none local" case.

>
> Here's an updated patch with all your comments applied, except the
> removal of these 3 comment lines.

Thanks!
