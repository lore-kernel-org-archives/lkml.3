Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbaH0CI2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 22:08:28 -0400
Received: from plane.gmane.org ([80.91.229.3]:54659 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753836AbaH0CI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 22:08:26 -0400
X-Injected-Via-Gmane: http://gmane.org/
Mail-Followup-To: linux-kernel@vger.kernel.org
To: linux-kernel@vger.kernel.org
From: rh_ <richard_hubbe11@lavabit.com>
Subject: Re: [PATCH 0/2] mmc: rtsx: fix incorrect last byte in R2 response
Date: Tue, 26 Aug 2014 19:00:10 -0700
Organization: L2N
Message-ID: <20140826190010.d94a8296e4f55566ab977a1a@lavabit.com>
References: <1408082761-15333-1-git-send-email-rogerable@realtek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: ip70-185-178-95.sb.sd.cox.net
User-Agent: dsodnetnin
X-Gmane-NNTP-Posting-Host: EZnn0.37p
Original-Received: from slem by 1.1 with local
X-No-Archive: yes
Archive: no
X-Archive: encrypt
X-Operating-System: Barebones_6.1
X-Gmane-NNTP-Posting-Host: 192.168.1.1
X-NNTP-Posting-Host: 192.168.1.1
Mail-Copies-To: never
X-Archive: expiry=79
X-Mailer: EZnn0.37u
X-Newsreader: EZnn0.37u
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Aug 2014 14:05:59 +0800
<rogerable@realtek.com> wrote:

> From: Roger Tseng <rogerable@realtek.com>
> 
> (The original patch for PCI and USB was splitted here to make it
> easier for stable tree.)
> 
> Current code erroneously fill the last byte of R2 response with an
> undefined value. In addition, the controller actually 'offloads' the
> last byte (CRC7, end bit) while receiving R2 response and thus it's
> impossible to get the actual value. This could cause mmc stack to
> obtain inconsistent CID from the same card after resume and
> misidentify it as a different card.

What does "resume" mean in this context?  Good to see this was
finally fixed. This problem has caused copious log messages regarding
hotplug events and I don't have any debug or extra logging enabled.

I don't know what triggered the message to get logged as my system
doesn't suspend/resume so I wonder what in your investigation makes
you believe this is a symptom of "resume".


> 
> Fix by assigning dummy CRC and end bit: {7'b0, 1} = 0x1 to the last
> byte of R2.
> 
> Roger Tseng (2):
>   mmc: rtsx_pci_sdmmc: fix incorrect last byte in R2 response
>   mmc: rtsx_usb_sdmmc: fix incorrect last byte in R2 response
> 
>  drivers/mmc/host/rtsx_pci_sdmmc.c |    7 +++++++
>  drivers/mmc/host/rtsx_usb_sdmmc.c |    7 +++++++
>  2 files changed, 14 insertions(+)
> 
> -- 
> 1.7.10.4


-- 


