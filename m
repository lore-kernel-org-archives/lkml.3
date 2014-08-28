Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936016AbaH1AWI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 20:22:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59735 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932305AbaH1AWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 20:22:06 -0400
Date: Wed, 27 Aug 2014 17:21:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Travis <travis@sgi.com>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, msalter@redhat.com,
        dyoung@redhat.com, riel@redhat.com, peterz@infradead.org,
        mgorman@suse.de, linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-mm@kvack.org, Alex Thorlton <athorlton@sgi.com>
Subject: Re: [PATCH 1/2] x86: Optimize resource lookups for ioremap
Message-Id: <20140827172128.93feef68.akpm@linux-foundation.org>
In-Reply-To: <53FE6FAA.6010806@sgi.com>
References: <20140827225927.364537333@asylum.americas.sgi.com>
	<20140827225927.602319674@asylum.americas.sgi.com>
	<20140827160515.c59f1c191fde5f788a7c42f6@linux-foundation.org>
	<53FE6515.6050102@sgi.com>
	<20140827161854.0619a04653b336d3adc755f3@linux-foundation.org>
	<53FE68E4.4090902@sgi.com>
	<20140827163745.774e9b5c591e8f9cf7542a4d@linux-foundation.org>
	<53FE6FAA.6010806@sgi.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014 16:54:18 -0700 Mike Travis <travis@sgi.com> wrote:

> > If we're still at 1+ hours then little bodges like this are nowhere
> > near sufficient and sterner stuff will be needed.
> > 
> > Do we actually need the test?  My googling turns up zero instances of
> > anyone reporting the "ioremap on RAM pfn" warning.
> 
> We get them more than we like, mostly from 3rd party vendors, and
> esp. those that merely port their windows drivers to linux.

Dang.  So wrapping the check in CONFIG_DEBUG_VM would be problematic?
