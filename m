Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab3JCKqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 06:46:25 -0400
Received: from mail-a04.ithnet.com ([217.64.83.99]:49576 "HELO ithnet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751710Ab3JCKqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 06:46:24 -0400
X-Sender-Authentication: SMTP AUTH verified <skraw>
Date: Thu, 3 Oct 2013 12:46:19 +0200
From: Stephan von Krawczynski <skraw@ithnet.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: NUMA processor numbering
Message-Id: <20131003124619.09fe08a3.skraw@ithnet.com>
In-Reply-To: <20131003102255.GA2086@khazad-dum.debian.net>
References: <20131003120514.36128d85.skraw@ithnet.com>
	<20131003102255.GA2086@khazad-dum.debian.net>
Organization: ith Kommunikationstechnik GmbH
X-Mailer: Sylpheed 3.1.2 (GTK+ 2.24.18; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Oct 2013 07:22:55 -0300
Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:

> On Thu, 03 Oct 2013, Stephan von Krawczynski wrote:
> > Does the above output mean that the cores are numbered right across the two
> > physical cpus? Does this mean one has to pin processes to 0,2,4,... to stay in
> > "short distance" to node 0 RAM?
> 
> ...
> 
> > If so, it would be a lot better to have them numbered 0-15 and 16-31 for pinning.
> > Is there a way to achieve this?
> 
> Yes, use hwloc to get the pinning masks for whatever property you want (e.g.
> all threads in a given core, all threads in a given node, all threads that
> share a given L3 cache...).
> 
> http://www.open-mpi.org/projects/hwloc/

Ok, let me re-phrase the question a bit.
Is it really possible what you see here:

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 45
model name      : Intel(R) Xeon(R) CPU E5-2660 0 @ 2.20GHz
stepping        : 7
microcode       : 0x70d
cpu MHz         : 2002.000
cache size      : 20480 KB
physical id     : 0
siblings        : 16
core id         : 0
cpu cores       : 8
apicid          : 0
initial apicid  : 0
[...]

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 45
model name      : Intel(R) Xeon(R) CPU E5-2660 0 @ 2.20GHz
stepping        : 7
microcode       : 0x70d
cpu MHz         : 1518.000
cache size      : 20480 KB
physical id     : 1
siblings        : 16
core id         : 0
cpu cores       : 8
apicid          : 32
initial apicid  : 32
[...]

These are the first two in the cpu list. If you look at that they are both on
core id 0, but have different physical ids. Up to now I thought that processor
1 is the HT of core id 0. But with a different physical id this would mean
that they are different NUMA nodes, right? How can that be? Someone from Intel
with a hint?

-- 
Regards,
Stephan

