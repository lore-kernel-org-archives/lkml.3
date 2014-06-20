Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934300AbaFTE5K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 00:57:10 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.163]:28372 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbaFTE5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 00:57:08 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWi/zfN1cLnBYfssBY9SQMKk8kCovkkmJbh+VP2spQG3tvMeGW7W
X-RZG-CLASS-ID: mo00
Date: Fri, 20 Jun 2014 06:57:04 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, kys@microsoft.com,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: Re: [PATCH net-next] hyperv: Add handler for
 RNDIS_STATUS_NETWORK_CHANGE event
Message-ID: <20140620045704.GA4850@aepfle.de>
References: <1403228076-7596-1-git-send-email-haiyangz@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1403228076-7596-1-git-send-email-haiyangz@microsoft.com>
User-Agent: Mutt/1.5.22.rev6346 (2013-10-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, Haiyang Zhang wrote:

> The RNDIS_STATUS_NETWORK_CHANGE event is received after the Hyper-V host
> sleep or hibernation. We refresh network at this time.

> +	char *argv[] = { "/etc/init.d/network", "restart", NULL };

What happens if that file does not exist? Dead network in the guest?
I tend to think if a VM with PV drivers goes to sleep it has to go
through the whole suspend/resume cycle, very much like the "LID closed"
event. So I think this and the other fbdev change that is floating
around is wrong.

Olaf
