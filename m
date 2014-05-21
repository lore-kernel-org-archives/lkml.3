Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524AbaEUJKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 05:10:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49927 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaEUJKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 05:10:51 -0400
Message-ID: <537C6D95.4040803@gmail.com>
Date: Wed, 21 May 2014 17:10:45 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
CC: Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org
Subject: Re: =?UTF-8?B?5Zue5aSN77yaIFtQQVRDSF0gYXJjaC91bmljb3JlMzIva2VybmU=?=
 =?UTF-8?B?bC9zZXR1cC5jOiBhZGQgZ2VuZXJpYyAnc2NyZWVuX2luZm8nIHRvIGF2b2lkIGM=?=
 =?UTF-8?B?b21waWxpbmcgZmFpbHVyZQ==?=
References: <902561559.40766.1400659266944.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <902561559.40766.1400659266944.JavaMail.root@bj-mail03.pku.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05/21/2014 04:01 PM, 管雪涛 wrote:
> 
> ----- Chen Gang <gang.chen.5i5j@gmail.com> 写道：
>> Add generic 'screen_info' just like another architectures have done
>> (e.g. tile, sh, score, ia64, hexagon, and cris).
>>
>> The related error (with allmodconfig under unicore32):
>>
>>     LD      init/built-in.o
>>   drivers/built-in.o: In function `vgacon_save_screen':
>>   powercap_sys.c:(.text+0x21788): undefined reference to `screen_info'
>>   drivers/built-in.o: In function `vgacon_resize':
>>   powercap_sys.c:(.text+0x21b54): undefined reference to `screen_info'
>>   drivers/built-in.o: In function `vgacon_switch':
>>   powercap_sys.c:(.text+0x21cb4): undefined reference to `screen_info'
>>   drivers/built-in.o: In function `vgacon_init':
>>   powercap_sys.c:(.text+0x2296c): undefined reference to `screen_info'
>>   drivers/built-in.o: In function `vgacon_startup':
>>   powercap_sys.c:(.text+0x22e80): undefined reference to `screen_info'
>>
>>
>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>> ---
>>  arch/unicore32/kernel/setup.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/arch/unicore32/kernel/setup.c b/arch/unicore32/kernel/setup.c
>> index 87adbf5..94bc4bc 100644
>> --- a/arch/unicore32/kernel/setup.c
>> +++ b/arch/unicore32/kernel/setup.c
>> @@ -53,6 +53,8 @@ struct stack {
>>  
>>  static struct stack stacks[NR_CPUS];
>>  
>> +struct screen_info screen_info;
>> +
> 
> could be as following if it's only used by vga console:
> 
> +#ifdef CONFIG_VGA_CONSOLE
> +struct screen_info screen_info;
> +#endif
> 

Yeah, I shall send patch v2 for it (within this week). And also thank
you for your review the other patches.

BTW: I guess, it only leaves 2 kernel related issues for allmodconfig:

 - one for 'find_first*', 'cpuc_coherent_kern_range' and 'pm_power_off'.
   I guess, we can export their symbol explicitly to fix this issue.

 - the other for additional 'clk_*' which are needed when HAVE_CLK.
   I guess, just "copy/past" the other platforms' implementation is OK.

The related errors:

  ERROR: "clk_round_rate" [sound/spi/snd-at73c213.ko] undefined!
  ERROR: "clk_set_parent" [sound/soc/jz4740/snd-soc-jz4740-i2s.ko] undefined!
  ERROR: "clk_round_rate" [sound/soc/fsl/snd-soc-fsl-ssi.ko] undefined!
  ERROR: "clk_round_rate" [sound/soc/fsl/snd-soc-fsl-spdif.ko] undefined!
  ERROR: "find_first_bit" [sound/soc/codecs/snd-soc-uda1380.ko] undefined!
  ERROR: "find_first_zero_bit" [net/sctp/sctp.ko] undefined!
  ERROR: "find_first_bit" [net/phonet/phonet.ko] undefined!
  ERROR: "find_first_zero_bit" [net/nfc/nfc.ko] undefined!
  ERROR: "find_first_zero_bit" [net/netfilter/nf_tables.ko] undefined!
  ERROR: "find_first_bit" [net/mac80211/mac80211.ko] undefined!
  ERROR: "find_first_zero_bit" [net/bridge/bridge.ko] undefined!
  ERROR: "find_first_bit" [net/bridge/bridge.ko] undefined!
  ERROR: "find_first_zero_bit" [fs/reiserfs/reiserfs.ko] undefined!
  ERROR: "find_first_bit" [fs/ocfs2/ocfs2.ko] undefined!
  ERROR: "find_first_zero_bit" [fs/ocfs2/cluster/ocfs2_nodemanager.ko] undefined!
  ERROR: "find_first_bit" [fs/ocfs2/cluster/ocfs2_nodemanager.ko] undefined!
  ERROR: "find_first_zero_bit" [fs/nfs/nfsv4.ko] undefined!
  ERROR: "find_first_zero_bit" [fs/minix/minix.ko] undefined!
  ERROR: "find_first_bit" [fs/hfsplus/hfsplus.ko] undefined!
  ERROR: "find_first_zero_bit" [fs/gfs2/gfs2.ko] undefined!
  ERROR: "find_first_zero_bit" [fs/bfs/bfs.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/uwb/uwb.ko] undefined!
  ...

Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
