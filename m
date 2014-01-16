Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985AbaAPRO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 12:14:57 -0500
Received: from www.sr71.net ([198.145.64.142]:42537 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678AbaAPROz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 12:14:55 -0500
Message-ID: <52D81331.5080209@sr71.net>
Date: Thu, 16 Jan 2014 09:13:21 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, penberg@kernel.org
Subject: Re: [RFC][PATCH 2/9] mm: slub: abstract out double cmpxchg option
References: <20140114180042.C1C33F78@viggo.jf.intel.com> <20140114180046.C897727E@viggo.jf.intel.com> <alpine.DEB.2.10.1401141346310.19618@nuc> <52D5AEF7.6020707@sr71.net> <alpine.DEB.2.10.1401161045180.29778@nuc>
In-Reply-To: <alpine.DEB.2.10.1401161045180.29778@nuc>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2014 08:45 AM, Christoph Lameter wrote:
> On Tue, 14 Jan 2014, Dave Hansen wrote:
>> With the current code, if you wanted to turn off the double-cmpxchg abd
>> get a 56-byte 'struct page' how would you do it?  Can you do it with a
>> .config, or do you need to hack the code?
> 
> Remove HAVE_ALIGNED_STRUCT_PAGE from a Kconfig file.

SLUB 'selects' it, so it seems to pop back up whenever SLUB is on:

$ grep STRUCT_PAGE ~/build/64bit/.config
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
$ vi ~/build/64bit/.config
... remove from Kconfig file
$ grep STRUCT_PAGE ~/build/64bit/.config
$ make oldconfig
... no prompt
$ grep STRUCT_PAGE ~/build/64bit/.config
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y


