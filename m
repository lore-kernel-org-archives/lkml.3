Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab3JNHtF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 03:49:05 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:55680 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab3JNHtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 03:49:04 -0400
Date: Mon, 14 Oct 2013 09:49:00 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org,
        sebastien.dugue@bull.net, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
Message-ID: <20131014074900.GA20095@gmail.com>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
 <87siw4xy9i.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87siw4xy9i.fsf@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> Neil Horman <nhorman@tuxdriver.com> writes:
> 
> > Sébastien Dugué reported to me that devices implementing ipoib (which 
> > don't have checksum offload hardware were spending a significant 
> > amount of time computing
> 
> Must be an odd workload, most TCP/UDP workloads do copy-checksum 
> anyways. I would rather investigate why that doesn't work.

There's a fair amount of csum_partial()-only workloads, a packet does not 
need to hit user-space to be a significant portion of the system's 
workload.

That said, it would indeed be nice to hear which particular code path was 
hit in this case, if nothing else then for education purposes.

Thanks,

	Ingo
