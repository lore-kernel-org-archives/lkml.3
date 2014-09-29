Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbaI2SNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:13:18 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:38926 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbaI2SNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:13:16 -0400
MIME-Version: 1.0
In-Reply-To: <87ppefi29s.fsf@sejong.aot.lge.com>
References: <CAPp4yYwTHbXiypxR_1WJGS9DYQNJ24t_Ykdo_sfQ48Ak-K3Z7g@mail.gmail.com>
	<20140911150123.GH10158@kernel.org>
	<CAPp4yYzRwoTBzH1_TwcdvAOryZppV9-BwnX2bOtN1qrEqrdBww@mail.gmail.com>
	<20140911203806.GA25763@kernel.org>
	<CAPp4yYzT66+J_dHC5_0TiTEdSK874OS-PH9nAtcr5-Luj69+7w@mail.gmail.com>
	<CAPp4yYxripyJvr87TtVqNMi5=K+UQGeKTomQiJarFnVGyjtofA@mail.gmail.com>
	<87fvffj5o0.fsf@sejong.aot.lge.com>
	<CAPp4yYzPR-FozYeuDUFqR0hhE5tioSqNy22cZ7WjSdBXoxeNxw@mail.gmail.com>
	<87ppefi29s.fsf@sejong.aot.lge.com>
Date: Mon, 29 Sep 2014 11:13:13 -0700
Message-ID: <CAPp4yYxVSUMBBXdVPUETu=uM2K5P9GoeQjH0YgayVL2qco-gYg@mail.gmail.com>
Subject: Re: [PATCH 1/1] perf tools: Fix Symbol Address for ET_DYN
From: Tong Shen <endlessroad@google.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-perf-users@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2014 at 7:33 PM, Namhyung Kim <namhyung@kernel.org> wrote:
>
> Hmm.. IIUC for normal dso (ET_DYN), shdr->offset == shdr->sh_addr for
> text section right?  And we always adjust ET_EXEC and ET_REL..  What
> about always trying to adjust symbol address then?  We may precalculate
> adjust offset and subtracting it from symbol values.  And the offset of
> 0 effectively means no adjust.  This way we can simplify the logic IMHO.

Yeah I'd like to do that too; but (shdr->offset == shdr->sh_addr for
normal ET_DYN && shdr->offset != shdr->sh_addr for non-relocatable
ET_DYN) is only true for .text section. It does not hold for .data
section.


I didn't dig deep into the code; if we only care about symbols in
.text section (function names), we can do what you said. Otherwise we
may want to keep it the way it is...

-- 
Best Regards, Tong Shen
