Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191AbaITASz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 20:18:55 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:47198 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757977AbaITASy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 20:18:54 -0400
Message-ID: <541CC7E5.3060505@roeck-us.net>
Date: Fri, 19 Sep 2014 17:18:45 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Anish Bhatt <anish@chelsio.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: Re: linux-next: Tree for Sep 19
References: <20140919165817.225eb8b8@canb.auug.org.au>,<20140919211404.GA24856@roeck-us.net> <525DB349B3FB5444AE057A887CB2A8D88EF4BB@nice.asicdesigners.com>
In-Reply-To: <525DB349B3FB5444AE057A887CB2A8D88EF4BB@nice.asicdesigners.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020209.541CC7EE.0044,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
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

On 09/19/2014 02:42 PM, Anish Bhatt wrote:
> If you're just bisecting, you probably want my very first commit that started this :
> https://git.kernel.org/cgit/linux/kernel/git/davem/net.git/commit/?id=c99d667e852766afc755fa4430be64bb94e5ea1c
>
> Essentially, the bnx2 modules would silently disable ipv6 support if ipv6 was
> compiled as a module, but cnic was inbuilt. Then it turned out that the select
> on CNIC would override the tristate for CNIC, causing build failures.
>
> The fix for CNIC caused introduced recursive dependencies, requiring this :
> https://git.kernel.org/cgit/linux/kernel/git/davem/net.git/commit/?id=5d6be6a5d4864712832822efeb9c2d54e4063949
>
> which further required this :
> https://git.kernel.org/cgit/linux/kernel/git/davem/net.git/commit/?id=95cd6f488d164de462a8279e802a0ad05c33d167
>
> Turns out this was not enough either, requiring this fix :
> https://git.kernel.org/cgit/linux/kernel/git/davem/net.git/commit/?id=6a38792ca8a5da28f65dc42eeb73d9a431f8d0fd
>
> and so on and so forth. According to the last message, Randy might be
>   working on a proper fix for this :
> http://www.spinics.net/lists/linux-scsi/msg78416.html
>
> Most of this seems to be that the default configs do not select NET, but select SCSI_FC*
> which used to previously select NET on it's own (via SCSI_NET_LINK), maybe this
> is wrong too ?

Default configurations, as per "make savedefconfig", only record differences to the default.
There will be no "CONFIG_NET=y" in a defconfig if "select NET" configures it automatically.
This is per design to reduce the size of the configuration file. On the downside,
it means that a "simple" change such as "select NET" -> "depends NET" has far reaching
consequences.

Guenter

