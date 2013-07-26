Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022Ab3GZHs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 03:48:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:26547 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752878Ab3GZHsZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 03:48:25 -0400
X-IronPort-AV: E=Sophos;i="4.89,749,1367942400"; 
   d="scan'208";a="8031703"
Message-ID: <51F22287.8050204@cn.fujitsu.com>
Date: Fri, 26 Jul 2013 15:17:27 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: majianpeng <majianpeng@gmail.com>
CC: viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: question about splice
References: <201307261507562231224@gmail.com>
In-Reply-To: <201307261507562231224@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/26 15:19:04,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/26 15:19:04
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jianpeng,

On 07/26/2013 03:08 PM, majianpeng wrote:

> Hi all,
> 	I used splice and found a prolem(at least i call).
> The demo is:
> A:splice(regularfileA--->pipe);
> B:splice(pipe--->regularfileB)
> Before do B, we modify the data of regA which now in pipe. The data to regularfileB willbe change.
> If we used the buff
> A:read(regA, buff);
> B: write(buff, regB);
> After A, the contend of regA can't effect the buff.
> Review the code of splice,I know the pipe share the pagecache of regA.

Right. And also this is the splice's original design intention, using share mmap rather
than copy_to_user/copy_from_user in order to achieve zero-copy.

Thanks,
Gu

> Maybe this is not a problem or am i missing something?

> 
> Thanks!
> Jianpeng MaN嫥叉靣笡y氊b瞂千v豝�)藓{.n�+壏{睉赙zXФ洝塄}财爖�&j:+v墾�珣赙zZ+€�+zf＂穐殘啳嗃i�z�畐ア�?櫒璀�&�)撷f旟^j谦y呩@A玜囤�0鹅h�鍜i


