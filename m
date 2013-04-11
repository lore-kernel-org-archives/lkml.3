Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161169Ab3DKU5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:57:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11805 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab3DKU5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:57:21 -0400
X-Authority-Analysis: v=2.0 cv=aOZyWMBm c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=HEz99ifgi9oA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=DrLfaR0XGykA:10 a=zRKbQ67AAAAA:8 a=Qj-eKC6PStGt9u4Spt0A:9 a=QEXdDO2ut3YA:10 a=1Dwx9gnmAe4A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365713840.9609.61.camel@gandalf.local.home>
Subject: Re: [ 024/171 ] sfc: lock TX queues when calling
 netif_device_detach()
From: Steven Rostedt <rostedt@goodmis.org>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Thu, 11 Apr 2013 16:57:20 -0400
In-Reply-To: <1365713664.9609.60.camel@gandalf.local.home>
References: <20130411202503.783159048@goodmis.org>
	 <20130411202550.143721907@goodmis.org>
	 <1365712962.7355.27.camel@bwh-desktop.uk.solarflarecom.com>
	 <1365713664.9609.60.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-11 at 16:54 -0400, Steven Rostedt wrote:
> On Thu, 2013-04-11 at 21:42 +0100, Ben Hutchings wrote:
> > On Thu, 2013-04-11 at 16:25 -0400, Steven Rostedt wrote:
> > 
> > > 3.6.11.2 stable review patch.
> > > If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Daniel Pieczko <dpieczko@solarflare.com>
> > > 
> > > [ Upstream commit c2f3b8e3a44b6fe9e36704e30157ebe1a88c08b1 ]
> > > 
> > > The assertion of netif_device_present() at the top of
> > > efx_hard_start_xmit() may fail if we don't do this.
> > 
> > You should also cherry-pick commit 35205b211c8d 'sfc: Disable soft
> > interrupt handling during efx_device_detach_sync()' on top of this.
> > 
> 
> Hmm, I had that in my quilt queue, but commented it out. I guess it
> didn't apply well, and it was a bit too much to back port blindly. I'll
> take another look.

Strange, it's a trivial patch that applied fine. I wonder why I
commented it out?

-- Steve


