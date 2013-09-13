Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933633Ab3IMN46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:56:58 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:39880 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932941Ab3IMN4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:56:42 -0400
X-Sasl-enc: LMka3EaNNGoiogPfIFyLwQ18zyvOOQ1vUJWyyZ1tBleh 1379080601
Date: Fri, 13 Sep 2013 10:56:39 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Ming Lei <ming.lei@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] firmware: Be a bit more verbose about direct firmware
 loading failure
Message-ID: <20130913135639.GA17010@khazad-dum.debian.net>
References: <1378496168-3684-1-git-send-email-nhorman@tuxdriver.com>
 <CACVXFVPRWEXMHyGhfZVGX2HrL3cguqVBUjTS51r2p8EGt=EPdg@mail.gmail.com>
 <20130911141943.GA3181@neilslaptop.think-freely.org>
 <CACVXFVNfkfsSJJUK_BWHLnddk=NAWDJoERmg_qycYa11G_X2RA@mail.gmail.com>
 <20130912131655.GA8619@hmsreliant.think-freely.org>
 <20130912184630.GA15948@khazad-dum.debian.net>
 <20130912203633.GC8619@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130912203633.GC8619@hmsreliant.think-freely.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Sep 2013, Neil Horman wrote:
> On Thu, Sep 12, 2013 at 03:46:30PM -0300, Henrique de Moraes Holschuh wrote:
> > On Thu, 12 Sep 2013, Neil Horman wrote:
> > > Both of these execptions should be rare, and are something the administrator
> > > will want to know about, so as not to confuse the real error with the mystery
> > > -ENOENT you would get if you fell back to the user mode helepr and it wansn't
> > > configured on in the running kernel.
> > 
> > Except, of course, for Intel processor microcode updates, which are going to
> > cause ENOENT on a large number of systems.
> > 
> > This will generate a large number of questions by users on the distro MLs.
> > 
> > However, IMHO this is *not* a reason to refuse this patch series.  If
> > anything, at least for Debian I will use it as an opportunity to educate
> > people about the existence of microcode update packages in "non-free".
> > 
> I agree. If people are running with downlevel microcode, they shold know about
> it.  You can't expect request_firmware to fail silently.  If people complain, I
> think the right solution would be to add a test to the microcode_request_fw
> function to check for the existence of the file before requesting it.

Make it a firmware loader API for "optional" firmware (i.e. which doesn't
complain on ENOENT), leaving for the caller the detail of whether a
firmware-not-there failure should be logged or not.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
