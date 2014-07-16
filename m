Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916AbaGPA4F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 20:56:05 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:38290 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295AbaGPA4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 20:56:03 -0400
MIME-Version: 1.0
In-Reply-To: <53C5BF46.3070604@zytor.com>
References: <CADpTngUm7d88RJS9OV=64t6QrJU4r3M_Z8eV1QYWPeeB5SX5-w@mail.gmail.com>
	<CABPqkBTu9vk_wsmYVrO6OOxgbwsLDG-A8f7dzutKwYXmoGsqnw@mail.gmail.com>
	<20140710200527.GA15190@google.com>
	<3524198.dm6HbYTJqK@calvin>
	<CAErSpo4xH2hpPMhm-4F+jNGKeMPjA2Tr8bQEkbWQGXpbwX6W4g@mail.gmail.com>
	<CAErSpo5u_KAfZL0EDVGCZ5nfvmiyv+V3+5Lw6aYoXvTouv_MeQ@mail.gmail.com>
	<CAE9FiQVN1WLigYt7YGHsd1f+BreApubYbjC9j9tzrCe-p5f=HA@mail.gmail.com>
	<53C5BF46.3070604@zytor.com>
Date: Tue, 15 Jul 2014 17:56:02 -0700
X-Google-Sender-Auth: 2zFiHl64h8gIk-UuZOGuca0sFao
Message-ID: <CAE9FiQW3eWkds12GSg2TStREEeAmAYmZ=ZRieOTZBOB3Z56iQA@mail.gmail.com>
Subject: Re: WARNING: CPU: 2 PID: 1 at arch/x86/mm/ioremap.c:171 __ioremap_caller+0x290/0x2fa()
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Fabio Coatti <fabio.coatti@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 4:54 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/15/2014 04:40 PM, Yinghai Lu wrote:

> We could quirk it, but we would have to make bloody darn sure that we
> don't break any systems because of unusual configuration and so on.
>
> I agree that we need to treat fixed resources as equivalent to reserved.
>  This is also a BIOS bug (it should reserve the whole region), but that
> happens far too frequently.  I don't know if we have any way to do that
> without massive surgery to the current code, though.

Should be similar to early_gart_iommu_check(), even less code.

Yinghai
