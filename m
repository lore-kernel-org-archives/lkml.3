Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032Ab3GWUwb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 16:52:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40168 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398Ab3GWUwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 16:52:30 -0400
Date: Tue, 23 Jul 2013 13:52:29 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Dilger, Andreas" <andreas.dilger@intel.com>
Cc: Peng Tao <bergwolf@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peng Tao <tao.peng@emc.com>
Subject: Re: [PATCH 02/48] staging/lustre/obdclass: restore lu_ref
Message-ID: <20130723205229.GA11261@kroah.com>
References: <20130723193712.GA9385@kroah.com>
 <CE1443D8.57081%andreas.dilger@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CE1443D8.57081%andreas.dilger@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 08:31:15PM +0000, Dilger, Andreas wrote:
> On 2013/07/23 1:37 PM, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> wrote:
> 
> >On Tue, Jul 23, 2013 at 12:06:23AM +0800, Peng Tao wrote:
> >> lu_ref.[ch] were mistakenly removed by coan2. Add them back and guard
> >> with CONFIG_LUSTRE_DEBUG_LU_REF_CHECK.
> >
> >Ick, why?  Why not use the in-kernel infrastructure for this type of
> >thig, _iff_ you really need it.
> >
> >Why do you need this at all, isn't the reference code fully debugged by
> >now, given that this has been running for years?  I would only expect to
> >see something like this in new code that is still being developed.
> 
> Lustre is still being developed, so it is useful to be able to enable this
> debugging to catch any new problems that are introduced.

Ok, then use the in-kernel infrastructure for this type of thing, don't
roll your own and add custom stuff that will later just have to be
ripped out and converted to use the in-kernel stuff.

thanks,

greg k-h
