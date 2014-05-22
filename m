Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012AbaEVDI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 23:08:27 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:19302 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbaEVDIZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 23:08:25 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Christoph Hellwig <hch@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Righi <andrea@betterlinux.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Thorsten Diehl <thorsten.diehl@de.ibm.com>
Subject: RE: /proc/stat vs. failed order-4 allocation
Thread-Topic: /proc/stat vs. failed order-4 allocation
Thread-Index: AQHPdO/FYx0/7akS0US+xlPBqUhGOptLGRyAgADQC1A=
Date: Thu, 22 May 2014 03:05:35 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402956F33B6F@G9W0745.americas.hpqcorp.net>
References: <20140521122521.GB7471@osiris>
 <20140521143229.GA32011@infradead.org>
In-Reply-To: <20140521143229.GA32011@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [15.201.58.26]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Christoph Hellwig
> Sent: Wednesday, May 21, 2014 9:32 AM
> To: Heiko Carstens
> Cc: Andrew Morton; KAMEZAWA Hiroyuki; Andrea Righi; Eric Dumazet; linux-
> kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org; Hendrik Brueckner;
> Thorsten Diehl
> Subject: Re: /proc/stat vs. failed order-4 allocation
> 
> On Wed, May 21, 2014 at 02:25:21PM +0200, Heiko Carstens wrote:
> > Hi all,
> >
> > I'm just wondering why /proc/stat is a single_open() seq_file and not a
> > regular seq_file with an iterator (say 48 online cpus for each iteration
> > or something similar).
> 
> Probably because no one sent a patch for it. I'm pretty sure it used the
> even more horrible old proc ops before and was converted in batch with
> various other files.

https://lkml.org/lkml/2012/1/20/153 worried about performance and led to 
the current code; the reply in https://lkml.org/lkml/2012/1/23/41 
discussed using seq_file, but that idea was rejected at the time.

Be careful about losing consistency of the information for the CPUs.

