Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934492AbaFTFM0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 01:12:26 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58433 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751441AbaFTFMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 01:12:25 -0400
X-Sasl-enc: k+UMPXgBihGiDQrSBUEaw9yyW9aD0YUisx/neM4980jP 1403241142
Date: Thu, 19 Jun 2014 22:12:13 -0700
From: Greg KH <greg@kroah.com>
To: Olaf Hering <olaf@aepfle.de>
Cc: Haiyang Zhang <haiyangz@microsoft.com>, netdev@vger.kernel.org,
        jasowang@redhat.com, driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net-next] hyperv: Add handler for
 RNDIS_STATUS_NETWORK_CHANGE event
Message-ID: <20140620051213.GA9960@kroah.com>
References: <1403228076-7596-1-git-send-email-haiyangz@microsoft.com>
 <20140620045704.GA4850@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620045704.GA4850@aepfle.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 06:57:04AM +0200, Olaf Hering wrote:
> On Thu, Jun 19, Haiyang Zhang wrote:
> 
> > The RNDIS_STATUS_NETWORK_CHANGE event is received after the Hyper-V host
> > sleep or hibernation. We refresh network at this time.
> 
> > +	char *argv[] = { "/etc/init.d/network", "restart", NULL };
> 
> What happens if that file does not exist? Dead network in the guest?
> I tend to think if a VM with PV drivers goes to sleep it has to go
> through the whole suspend/resume cycle, very much like the "LID closed"
> event. So I think this and the other fbdev change that is floating
> around is wrong.

Ah, and what about systems with no /etc/init.d/ at all (like
systemd-based ones)?  You can't have a kernel driver ask userspace to
restart all networking connections, that seems really wrong.

greg k-h
