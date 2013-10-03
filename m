Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab3JCVqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 17:46:46 -0400
Received: from iona.labri.fr ([147.210.8.143]:38713 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755817Ab3JCVqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 17:46:44 -0400
X-Greylist: delayed 631 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Oct 2013 17:46:44 EDT
Message-ID: <524DE349.4050000@gmail.com>
Date: Thu, 03 Oct 2013 23:36:09 +0200
From: Brice Goglin <brice.goglin@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130821 Icedove/17.0.8
MIME-Version: 1.0
To: Stephan von Krawczynski <skraw@ithnet.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: NUMA processor numbering
References: <20131003120514.36128d85.skraw@ithnet.com> <20131003102255.GA2086@khazad-dum.debian.net> <20131003124619.09fe08a3.skraw@ithnet.com>
In-Reply-To: <20131003124619.09fe08a3.skraw@ithnet.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 03/10/2013 12:46, Stephan von Krawczynski a écrit :
> Ok, let me re-phrase the question a bit.
> Is it really possible what you see here:
>
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 45
> model name      : Intel(R) Xeon(R) CPU E5-2660 0 @ 2.20GHz
> stepping        : 7
> microcode       : 0x70d
> cpu MHz         : 2002.000
> cache size      : 20480 KB
> physical id     : 0
> siblings        : 16
> core id         : 0
> cpu cores       : 8
> apicid          : 0
> initial apicid  : 0
> [...]
>
> processor       : 1
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 45
> model name      : Intel(R) Xeon(R) CPU E5-2660 0 @ 2.20GHz
> stepping        : 7
> microcode       : 0x70d
> cpu MHz         : 1518.000
> cache size      : 20480 KB
> physical id     : 1
> siblings        : 16
> core id         : 0
> cpu cores       : 8
> apicid          : 32
> initial apicid  : 32
> [...]
>
> These are the first two in the cpu list. If you look at that they are both on
> core id 0, but have different physical ids. Up to now I thought that processor
> 1 is the HT of core id 0. But with a different physical id this would mean
> that they are different NUMA nodes, right? How can that be? Someone from Intel
> with a hint?

Such "unexpected" numberings are very common. The BIOS is free to number
processors in many different orders, including NUMA first, core first,
HT first, etc.

Having the two hyperthreads of the first core physically numbered 0 and
1 doesn't seem very common on current Intel platforms. Most Xeon E5
machines I've seen put the second hyperthreads of all cores at the end
of range. But there's no guarantee about this.

Use hwloc just like Henrique said, it will take care of virtually
reordering objects in a logical manner.

Brice

