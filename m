Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbaESVYv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 17:24:51 -0400
Received: from longford.logfs.org ([213.229.74.203]:43345 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaESVYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 17:24:49 -0400
Date: Mon, 19 May 2014 17:23:20 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: mix all saved registers into entropy pool
Message-ID: <20140519212320.GB14563@logfs.org>
References: <20140519211719.GA14563@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140519211719.GA14563@logfs.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2014 17:17:19 -0400, Jörn Engel wrote:
> 
> Experimentation show this to be an excellent entropy source.  Doing 1000
> boottests with kvm and dumping a hash of the registers for the first
> 1024 interrupts each, >40% of all hashes were unique and >80% of all
> hashes occurred less than once 1% of the time.

And since I previously claimed the opposite, the negative result was
caused by a kvm oddity.  When starting kvm in the background, it will
run just fine.  But when starting kvm with "-nographic" in the
background, the process gets stopped.  No output is generated and the
output file is not even truncated before kvm is stopped.  Therefore
every single run will have identical kernel output - that of the
previous run.

With that embarrassment out of the way, I find this approach hugely
valuable.  Even if you disagree with some detail of this patch, we
should definitely merge something roughly related.

Jörn

--
A defeated army first battles and then seeks victory.
-- Sun Tzu
