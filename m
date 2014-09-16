Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbaIPGwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 02:52:20 -0400
Received: from mail-ob0-f194.google.com ([209.85.214.194]:59575 "EHLO
	mail-ob0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbaIPGwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 02:52:18 -0400
Date: Tue, 16 Sep 2014 01:38:45 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Hansen <dave@sr71.net>, linux-kernel@vger.kernel.org,
        borislav.petkov@amd.com, andreas.herrmann3@amd.com, mingo@kernel.org,
        hpa@linux.intel.com, ak@linux.intel.com
Subject: Re: [PATCH] x86: Consider multiple nodes in a single socket to be
 "sane"
Message-ID: <20140916013845.390833b9@as>
In-Reply-To: <20140916032920.GH2840@worktop.localdomain>
References: <20140915222641.D640BD8A@viggo.jf.intel.com>
	<20140916032920.GH2840@worktop.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Sep 2014 05:29:20 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, Sep 15, 2014 at 03:26:41PM -0700, Dave Hansen wrote:
> > 
> > I'm getting the spew below when booting with Haswell (Xeon
> > E5-2699) CPUs and the "Cluster-on-Die" (CoD) feature enabled in
> > the BIOS. 
> 
> What is that cluster-on-die thing? I've heard it before but never could
> find anything on it.
> 

Each CPU has 2.5MB of L3 connected together in a ring that makes it all act
like a single shared cache. The HW tries to place the data so it's closest to
the CPU that uses it. On the larger processors there are two rings with an
interconnect between them that adds latency if a cache fetch has to cross that.
CoD breaks that connection and effectively gives you two nodes on one die.
