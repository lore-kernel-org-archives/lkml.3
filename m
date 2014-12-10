Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbaLJNm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 08:42:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756261AbaLJNm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 08:42:28 -0500
Date: Wed, 10 Dec 2014 13:42:24 +0000
From: Joe Thornber <thornber@redhat.com>
To: Akira Hayakawa <ruby.wktk@gmail.com>
Cc: ejt@redhat.com, dm-devel@redhat.com, gregkh@linuxfoundation.org,
        snitzer@redhat.com, agk@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH] staging: writeboost: Add dm-writeboost
Message-ID: <20141210134223.GE21108@debian>
Mail-Followup-To: Akira Hayakawa <ruby.wktk@gmail.com>, ejt@redhat.com,
	dm-devel@redhat.com, gregkh@linuxfoundation.org, snitzer@redhat.com,
	agk@redhat.com, linux-kernel@vger.kernel.org
References: <5484498E.4000202@gmail.com>
 <20141207200834.GA2322@kroah.com>
 <5484C0E9.3060707@gmail.com>
 <20141209151253.GA17660@debian>
 <20141210100033.GA21108@debian>
 <548827BD.3050803@gmail.com>
 <20141210123349.GC21108@debian>
 <548843A0.6040906@gmail.com>
 <20141210131325.GD21108@debian>
 <54884B33.4090709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54884B33.4090709@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 10:31:31PM +0900, Akira Hayakawa wrote:
> Joe,
> 
> > So you copy the bio payload to a different block of ram and then
> > complete the bio?  Or does the rambuf refer to the bio payload
> > directly?
> Good question.
> The answer is, copy the data (got by bio_data(bio)) to rambuf once
> and ack if it's not barrier things.
> It would be nice if data in rambuf points to bio payload but it now copies
> because bio payload can be reused after completion. Am I right?
> Is there a way of eliminate memory copying?

You *have* to eliminate this memory copying.  Remap the bios to the
relevant portion of your log, and don't complete them until you log
chunk is coherent.
