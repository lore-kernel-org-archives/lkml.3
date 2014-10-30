Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197AbaJ3AHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 20:07:08 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:41785 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398AbaJ3AHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 20:07:07 -0400
MIME-Version: 1.0
In-Reply-To: <20141029041811.GA12382@htj.dyndns.org>
References: <1414249558-6677-1-git-send-email-zzhsuny@gmail.com>
	<20141027140826.GJ4436@htj.dyndns.org>
	<CADFvMYKRcqcZSbMz8sHGGknUC7p7i3MvGO5vKabrrzeWj+qUTw@mail.gmail.com>
	<20141028035651.GB4751@mtj.dyndns.org>
	<CADFvMY+VUNaLhsJaPjH_DC91uJ8Hdgnaj9D44QEm0qV3Rr2-kA@mail.gmail.com>
	<20141029041811.GA12382@htj.dyndns.org>
Date: Wed, 29 Oct 2014 20:07:06 -0400
Message-ID: <CADFvMY+qcNQMTKUgm3coGM6x_WGKJn-tv5XECBtOpTdVK1r1hw@mail.gmail.com>
Subject: Re: [PATCH] [percpu] Make the unit size of the first chunk the same
 as other chunks
From: Zhihui Zhang <zzhsuny@gmail.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see your point. Thanks.

-Zhihui

On Wed, Oct 29, 2014 at 12:18 AM, Tejun Heo <tj@kernel.org> wrote:
> Plesae restore lkml cc when replying.
>
> On Tue, Oct 28, 2014 at 08:12:30PM -0400, Zhihui Zhang wrote:
>> My patch just increases the dynamic area in the first chunk slightly
>> to cover the round up surplus. On my 64-bit laptop, it is 12288 bytes.
>
> As I wrote before, it's 12288 bytes on your laptop but it can be much
> larger on other setups.
>
>> It will mostly likely be used, and in fact, a second chunk will be
>> most likely needed as well.  So in theory you are right, but in
>> practice, it probably won't matter.
>
> If the initial dynamic reserve is too small, which could be the case
> given the overall increase in percpu memory, increase
> PERCPU_DYNAMIC_EARLY_SIZE.
>
> --
> tejun
