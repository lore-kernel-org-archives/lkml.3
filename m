Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938AbaAVTuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 14:50:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53572 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbaAVTuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 14:50:03 -0500
Date: Wed, 22 Jan 2014 11:50:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Ric Wheeler <rwheeler@redhat.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Chris Mason <clm@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "mgorman@suse.de" <mgorman@suse.de>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "lsf-pc@lists.linux-foundation.org" 
	<lsf-pc@lists.linux-foundation.org>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] really large storage sectors - going
 beyond 4096 bytes
Message-Id: <20140122115002.bb5d01dee836b567a7aad157@linux-foundation.org>
In-Reply-To: <1390419019.2372.89.camel@dabdike.int.hansenpartnership.com>
References: <20131220093022.GV11295@suse.de>
	<52DF353D.6050300@redhat.com>
	<20140122093435.GS4963@suse.de>
	<52DFD168.8080001@redhat.com>
	<20140122143452.GW4963@suse.de>
	<52DFDCA6.1050204@redhat.com>
	<20140122151913.GY4963@suse.de>
	<1390410233.1198.7.camel@ret.masoncoding.com>
	<1390411300.2372.33.camel@dabdike.int.hansenpartnership.com>
	<1390413819.1198.20.camel@ret.masoncoding.com>
	<1390414439.2372.53.camel@dabdike.int.hansenpartnership.com>
	<52E00B28.3060609@redhat.com>
	<1390415703.2372.62.camel@dabdike.int.hansenpartnership.com>
	<52E0106B.5010604@redhat.com>
	<1390419019.2372.89.camel@dabdike.int.hansenpartnership.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jan 2014 11:30:19 -0800 James Bottomley <James.Bottomley@hansenpartnership.com> wrote:

> But this, I think, is the fundamental point for debate.  If we can pull
> alignment and other tricks to solve 99% of the problem is there a need
> for radical VM surgery?  Is there anything coming down the pipe in the
> future that may move the devices ahead of the tricks?

I expect it would be relatively simple to get large blocksizes working
on powerpc with 64k PAGE_SIZE.  So before diving in and doing huge
amounts of work, perhaps someone can do a proof-of-concept on powerpc
(or ia64) with 64k blocksize.

That way we'll at least have an understanding of what the potential
gains will be.  If the answer is "1.5%" then poof - go off and do
something else.

(And the gains on powerpc would be an upper bound - unlike powerpc, x86
still has to fiddle around with 16x as many pages and perhaps order-4
allocations(?))

