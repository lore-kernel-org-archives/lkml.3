Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933332Ab3HNXUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 19:20:09 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:46849 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933153Ab3HNXUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 19:20:07 -0400
MIME-Version: 1.0
In-Reply-To: <20130814215253.GC17423@variantweb.net>
References: <1376508705-3188-1-git-send-email-sjenning@linux.vnet.ibm.com>
	<20130814194348.GB10469@kroah.com>
	<520BE30D.3070401@sr71.net>
	<20130814203546.GA6200@kroah.com>
	<CAE9FiQUz6Ev0nbCoSbH7E=+zeJr6GKwR4B-z8+zJTRDPeF=jeA@mail.gmail.com>
	<20130814215253.GC17423@variantweb.net>
Date: Wed, 14 Aug 2013 16:20:06 -0700
X-Google-Sender-Auth: lrLM662TmDFXmXX9FxvlCgPm1kM
Message-ID: <CAE9FiQXJ85Nr6F=mn5DgfanwNA2s55=_LyQKbXLrxfTc6yZcAQ@mail.gmail.com>
Subject: Re: [RFC][PATCH] drivers: base: dynamic memory block creation
From: Yinghai Lu <yinghai@kernel.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Hansen <dave@sr71.net>,
        Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 2:52 PM, Seth Jennings
<sjenning@linux.vnet.ibm.com> wrote:
> On Wed, Aug 14, 2013 at 02:37:26PM -0700, Yinghai Lu wrote:

> If I am understanding you correctly, you are suggesting we make the block size
> a boot time tunable.  It can't be a runtime tunable since the memory blocks are
> currently created a boot time.

yes.

If could make it to be tunable at run-time, could be much better.

>
> On ppc64, we can't just just choose a memory block size since it must align
> with the underlying LMB (logical memory block) size, set in the hardware ahead
> of time.

assume for x86_64, it now support 46bits physical address. so if we
change to 2G, then
big system will only need create (1<<15) aka 32k entries in /sys at most.

Thanks

Yinghai
