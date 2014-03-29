Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaC2QlX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 12:41:23 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:62996 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbaC2QlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 12:41:21 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWpprkp_dzviD8wRpqosJq5Oe+8UTwhL87fbzFm3OknUw@mail.gmail.com>
References: <CAOULuOY5eryuH1KgaqiuGXyYiQd2h=TZoPe2M2+juts9XuzW6Q@mail.gmail.com>
	<CAE9FiQXmO_sSCnd-0NvXKmyeLP0m4XGRRkAgqSiMkfeTcvXs+A@mail.gmail.com>
	<CAOULuOaeBPpuiYc_Aru+awBDf=Ahbok-UjgY9o7gfO4VMctoqg@mail.gmail.com>
	<CAE9FiQWpprkp_dzviD8wRpqosJq5Oe+8UTwhL87fbzFm3OknUw@mail.gmail.com>
Date: Sat, 29 Mar 2014 09:41:20 -0700
X-Google-Sender-Auth: YrAjPl5siPFrU3FHtOu9CJ_NMx0
Message-ID: <CA+55aFx_zAO0iJVi==4X-bYFTopgaOCopCdUBbqUwKfOrXRYqw@mail.gmail.com>
Subject: Re: BAR 14: can't assign mem (size 0x200000)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Parag Warudkar <parag.lkml@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 29, 2014 at 12:11 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>
> Later during resuming, kernel try to assign resource 02:00.0 but it will fail
> as parent bridge 00:1c.3 has no resource.
> (Not sure how pci_configure_slot get called with this resume path).

I think that last comment is the most pertinent one: why does resume
try to assign resources to PCI devices? It should be *restoring* them,
not re-assigning any resources.

Parag, can you add a WARN_ON_ONCE() to that message, so that we see
what the call chain is for it.

              Linus
