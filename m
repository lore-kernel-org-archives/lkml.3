Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaJ1TXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 15:23:19 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:56689 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbaJ1TXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 15:23:18 -0400
Date: Tue, 28 Oct 2014 12:23:05 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/15] net: dsa: Don't set skb->protocol on outgoing
 tagged packets
Message-ID: <20141028192305.GB12033@roeck-us.net>
References: <1414342365-27191-1-git-send-email-linux@roeck-us.net>
 <1414342365-27191-2-git-send-email-linux@roeck-us.net>
 <544FEC39.4060903@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544FEC39.4060903@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020207.544FED25.0345,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 10
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 12:19:21PM -0700, Florian Fainelli wrote:
> On 10/26/2014 09:52 AM, Guenter Roeck wrote:
> > Setting skb->protocol to a private protocol type may result in warning
> > messages such as
> > 	e1000e 0000:00:19.0 em1: checksum_partial proto=dada!
> > 
> > This happens if the L3 protocol is IP or IPv6 and skb->ip_summed is set
> > to CHECKSUM_PARTIAL. Looking through the code, it appears that changing
> > skb->protocol for transmitted packets is not necessary and may actually
> > be harmful. Drop it.
> 
> You could emphasize that overriding skb->protocol prevents purposely
> unmodified (from a DSA perspective) network drivers from properly
> setting up their transmit checksum offload pointers since they inspect
> skb->protocol to setup the IPv4 header or IPv6 header pointers.
> 
Ok, I'll do that.

Thanks,
Guenter
