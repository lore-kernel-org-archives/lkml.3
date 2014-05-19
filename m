Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbaESXUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 19:20:20 -0400
Received: from longford.logfs.org ([213.229.74.203]:43351 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaESXUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 19:20:19 -0400
Date: Mon, 19 May 2014 19:18:48 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: mix all saved registers into entropy pool
Message-ID: <20140519231848.GD14563@logfs.org>
References: <20140519211719.GA14563@logfs.org>
 <20140519212320.GB14563@logfs.org>
 <537A8319.5010100@zytor.com>
 <20140519223943.GC14563@logfs.org>
 <537A8E22.4030400@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <537A8E22.4030400@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2014 16:05:06 -0700, H. Peter Anvin wrote:
> On 05/19/2014 03:39 PM, Jörn Engel wrote:
> > 
> > I would feel fairly confident giving this .25 bits of entropy per
> > event.  With 40% unique hashes and assuming at most 1 bit of entropy
> > for a unique hash, that is a fairly conservative underestimate.
> 
> Sure, but that is for a specific workload.

The workload is called boot.  That is one of the two critical ones -
the other being a cloned VM.  If we can gather enough entropy during
boot and somehow avoid the cloned VM problem, we have won.  No more
need to feed in entropy from the previous run, which on many embedded
systems won't happen anyway.

If you complained about the limited selection of hardware I tested on,
you would be right.  So far it has been x86 kvm and an x86 notebook.
It would be great to get numbers for some embedded system with arm or
mips as well.

Jörn

--
When in doubt, punt.  When somebody actually complains, go back and fix it...
The 90% solution is a good thing.
-- Rob Landley
