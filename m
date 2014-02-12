Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbaBLQgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:36:53 -0500
Received: from mail.skyhub.de ([78.46.96.112]:59486 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606AbaBLQgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 11:36:51 -0500
Date: Wed, 12 Feb 2014 17:36:44 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tejun Heo <tj@kernel.org>
Cc: Prarit Bhargava <prarit@redhat.com>, linux-edac@vger.kernel.org,
        Doug Thompson <dougthompson@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] edac, poll timeout cannot be zero
Message-ID: <20140212163644.GG5121@pd.tnic>
References: <1391457913-881-1-git-send-email-prarit@redhat.com>
 <20140212150748.GE5121@pd.tnic>
 <20140212151657.GL24490@htj.dyndns.org>
 <20140212155752.GF5121@pd.tnic>
 <20140212162311.GB26809@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140212162311.GB26809@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 11:23:11AM -0500, Tejun Heo wrote:
> Hah... can't you just do it on object initialization?  It's a bit
> nasty and fragile to game initialization state.
> 
> > or so... I.e., what PREPARE_WORK() does?
> 
> It allows you to change the callback without breaking the
> synchronization.  Of course, if there's a pending work item, it may or
> may not execute the newly assigned function.  It's also a bit nasty
> and has only few users in the whole kernel and I think we might wanna
> get rid of them.

Yeah, no, I certainly don't have to touch wq inner organs - I was
wondering whether there's such functionality already. The simple patch I
sent earlier should be good enough then.

Thanks!

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
