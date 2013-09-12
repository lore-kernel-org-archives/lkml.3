Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab3ILUgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 16:36:49 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53609 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231Ab3ILUgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 16:36:48 -0400
Date: Thu, 12 Sep 2013 16:36:33 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ming Lei <ming.lei@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] firmware: Be a bit more verbose about direct firmware
 loading failure
Message-ID: <20130912203633.GC8619@hmsreliant.think-freely.org>
References: <1378496168-3684-1-git-send-email-nhorman@tuxdriver.com>
 <CACVXFVPRWEXMHyGhfZVGX2HrL3cguqVBUjTS51r2p8EGt=EPdg@mail.gmail.com>
 <20130911141943.GA3181@neilslaptop.think-freely.org>
 <CACVXFVNfkfsSJJUK_BWHLnddk=NAWDJoERmg_qycYa11G_X2RA@mail.gmail.com>
 <20130912131655.GA8619@hmsreliant.think-freely.org>
 <20130912184630.GA15948@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130912184630.GA15948@khazad-dum.debian.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 03:46:30PM -0300, Henrique de Moraes Holschuh wrote:
> On Thu, 12 Sep 2013, Neil Horman wrote:
> > Both of these execptions should be rare, and are something the administrator
> > will want to know about, so as not to confuse the real error with the mystery
> > -ENOENT you would get if you fell back to the user mode helepr and it wansn't
> > configured on in the running kernel.
> 
> Except, of course, for Intel processor microcode updates, which are going to
> cause ENOENT on a large number of systems.
> 
> This will generate a large number of questions by users on the distro MLs.
> 
> However, IMHO this is *not* a reason to refuse this patch series.  If
> anything, at least for Debian I will use it as an opportunity to educate
> people about the existence of microcode update packages in "non-free".
> 
I agree. If people are running with downlevel microcode, they shold know about
it.  You can't expect request_firmware to fail silently.  If people complain, I
think the right solution would be to add a test to the microcode_request_fw
function to check for the existence of the file before requesting it.

Neil

> -- 
>   "One disk to rule them all, One disk to find them. One disk to bring
>   them all and in the darkness grind them. In the Land of Redmond
>   where the shadows lie." -- The Silicon Valley Tarot
>   Henrique Holschuh
> 
