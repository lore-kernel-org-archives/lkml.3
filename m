Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbaJFKuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 06:50:08 -0400
Received: from mail.lang.hm ([64.81.33.126]:37795 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbaJFKuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 06:50:05 -0400
Date: Mon, 6 Oct 2014 03:49:44 -0700 (PDT)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: Thomas Gleixner <tglx@linutronix.de>
cc: Christoph Lameter <cl@linux.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Why do we still have 32 bit counters? Interrupt counters overflow
 within 50 days
In-Reply-To: <alpine.DEB.2.11.1410052331420.4383@nanos>
Message-ID: <alpine.DEB.2.02.1410060347300.26324@nftneq.ynat.uz>
References: <alpine.DEB.2.11.1410030435260.8324@gentwo.org> <alpine.DEB.2.11.1410031231420.4383@nanos> <alpine.DEB.2.11.1410030653040.8496@gentwo.org> <20141003120345.GA6652@localhost.localdomain> <alpine.DEB.2.11.1410030706220.8990@gentwo.org>
 <alpine.DEB.2.11.1410052331420.4383@nanos>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Oct 2014, Thomas Gleixner wrote:

>>
>> 64 bit counters on 32 bit machines are not an easy thing and could be
>
> Whats so hard about 64bit counters on 32bit machines?
>
>> expensive to handle in particular because these counters are used in
>> performance critical hotpaths.
>
> The expensive overhead is a single "adcl" instruction.

As I understand it, since the 64 bit math cannot be made atomic, it requires 
protecting the counter with a lock so that it can't be read while half updated. 
Aquiring a lock on every update is an expensive thing to do. It's not something 
people like to see in a fast path, especially for something of as low an 
importance as the counters.

David Lang
