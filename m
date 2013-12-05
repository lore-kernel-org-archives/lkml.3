Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab3LEPQq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 10:16:46 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:20745 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756431Ab3LEPQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 10:16:45 -0500
Message-ID: <1386256309.1791.253.camel@misato.fc.hp.com>
Subject: Re: [PATCH] mm, x86: Skip NUMA_NO_NODE while parsing SLIT
From: Toshi Kani <toshi.kani@hp.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, mingo@kernel.org, hpa@zytor.com,
        tglx@linutronix.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        x86@kernel.org
Date: Thu, 05 Dec 2013 08:11:49 -0700
In-Reply-To: <52A054A0.6060108@jp.fujitsu.com>
References: <1386191348-4696-1-git-send-email-toshi.kani@hp.com>
	 <52A054A0.6060108@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-05 at 19:25 +0900, Yasuaki Ishimatsu wrote:
> (2013/12/05 6:09), Toshi Kani wrote:
> > When ACPI SLIT table has an I/O locality (i.e. a locality unique
> > to an I/O device), numa_set_distance() emits the warning message
> > below.
> > 
> >   NUMA: Warning: node ids are out of bound, from=-1 to=-1 distance=10
> > 
> > acpi_numa_slit_init() calls numa_set_distance() with pxm_to_node(),
> > which assumes that all localities have been parsed with SRAT previously.
> > SRAT does not list I/O localities, where as SLIT lists all localities
> 
> > including I/Os.  Hence, pxm_to_node() returns NUMA_NO_NODE (-1) for
> > an I/O locality.  I/O localities are not supported and are ignored
> > today, but emitting such warning message leads unnecessary confusion.
> 
> In this case, the warning message should not be shown. But if SLIT table
> is really broken, the message should be shown. Your patch seems to not care
> for second case.

In the second case, I assume you are worrying about the case of SLIT
table with bad locality numbers.  Since SLIT is a matrix of the number
of localities, it is only possible by making the table bigger than
necessary.  Such excessive localities are safe to ignore (as they are
ignored today) and regular users have nothing to concern about them.
The warning message in this case may be helpful for platform vendors to
test their firmware, but they have plenty of other methods to verify
their SLIT table.

Thanks,
-Toshi



