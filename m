Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635AbaJTP5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 11:57:39 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:35582 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbaJTP5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 11:57:35 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1410201018230.24954@ayla.of.borg>
References: <alpine.DEB.2.02.1410201018230.24954@ayla.of.borg>
Date: Mon, 20 Oct 2014 17:57:30 +0200
Message-ID: <CAADnVQJsbNHs-S9gMF7P6FwHvHTfFSTPGNTLXAo5tJ8mpB5t6Q@mail.gmail.com>
Subject: Re: v3.18-rc1 bloat-o-meter
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-embedded@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 10:37 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
>         Hi all,
>
> Below is the bloat-o-meter output when comparing an m68k/atari_defconfig
> kernel for v3.17 and v3.18-rc1.
>
> Major culprit seems to be bpf. Can this become modular or optional?
> Currently it's always included if CONFIG_NET=y.

yes, the plan is to get it its own CONFIG_BPF so that tracing wouldn't
need to depend on whole NET and so it can be stubbed out.
