Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbbAELlu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 06:41:50 -0500
Received: from mail.us.es ([193.147.175.20]:59075 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358AbbAELls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 06:41:48 -0500
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus4 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.5/19880. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-103.2/7.5):. 
 Processed in 1.884728 secs); 05 Jan 2015 11:41:46 -0000
X-Spam-ASN: AS12715 87.216.0.0/16
X-Envelope-From: pneira@us.es
Date: Mon, 5 Jan 2015 12:44:32 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: kaber@trash.net, kadlec@blackhole.kfki.hu,
        David Miller <davem@davemloft.net>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH next] net: netfilter: nfnetlink_cthelper: Remove 'const'
 and '&' to avoid warnings
Message-ID: <20150105114432.GA17895@salvia>
References: <549AD616.7070709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <549AD616.7070709@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2014 at 11:04:54PM +0800, Chen Gang wrote:
> The related code can be simplified, and also can avoid related warnings
> (with allmodconfig under parisc):
> 
>     CC [M]  net/netfilter/nfnetlink_cthelper.o
>   net/netfilter/nfnetlink_cthelper.c: In function ‘nfnl_cthelper_from_nlattr’:
>   net/netfilter/nfnetlink_cthelper.c:97:9: warning: passing argument 1 o ‘memcpy’ discards ‘const’ qualifier from pointer target type [-Wdiscarded-array-qualifiers]
>     memcpy(&help->data, nla_data(attr), help->helper->data_len);
>            ^
>   In file included from include/linux/string.h:17:0,
>                    from include/uapi/linux/uuid.h:25,
>                    from include/linux/uuid.h:23,
>                    from include/linux/mod_devicetable.h:12,
>                    from ./arch/parisc/include/asm/hardware.h:4,
>                    from ./arch/parisc/include/asm/processor.h:15,
>                    from ./arch/parisc/include/asm/spinlock.h:6,
>                    from ./arch/parisc/include/asm/atomic.h:21,
>                    from include/linux/atomic.h:4,
>                    from ./arch/parisc/include/asm/bitops.h:12,
>                    from include/linux/bitops.h:36,
>                    from include/linux/kernel.h:10,
>                    from include/linux/list.h:8,
>                    from include/linux/module.h:9,
>                    from net/netfilter/nfnetlink_cthelper.c:11:
>   ./arch/parisc/include/asm/string.h:8:8: note: expected ‘void *’ but argument is of type ‘const char (*)[]’
>    void * memcpy(void * dest,const void *src,size_t count);
>           ^

Applied, thanks.
