Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbaAVPyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 10:54:44 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36214 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753040AbaAVPyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 10:54:39 -0500
Message-ID: <1390406077.2372.4.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] really large storage sectors - going
 beyond 4096 bytes
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ric Wheeler <rwheeler@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Date: Wed, 22 Jan 2014 07:54:37 -0800
In-Reply-To: <52DF353D.6050300@redhat.com>
References: <20131220093022.GV11295@suse.de> <52DF353D.6050300@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-21 at 22:04 -0500, Ric Wheeler wrote:
> One topic that has been lurking forever at the edges is the current 4k 
> limitation for file system block sizes. Some devices in production today and 
> others coming soon have larger sectors and it would be interesting to see if it 
> is time to poke at this topic again.
> 
> LSF/MM seems to be pretty much the only event of the year that most of the key 
> people will be present, so should be a great topic for a joint session.

But the question is what will the impact be.  A huge amount of fuss was
made about 512->4k.  Linux was totally ready because we had variable
block sizes and our page size is 4k.  I even have one pure 4k sector
drive that works in one of my test systems.

However, the result was the market chose to go the physical/logical
route because of other Operating System considerations, all 4k drives
expose 512 byte sectors and do RMW internally.  For us it becomes about
layout and alignment, which we already do.  I can't see how going to 8k
or 16k would be any different from what we've already done.  In other
words, this is an already solved problem.

James


