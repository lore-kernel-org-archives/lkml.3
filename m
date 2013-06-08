Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab3FHKJB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 06:09:01 -0400
Received: from intranet.asianux.com ([58.214.24.6]:61367 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab3FHKI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 06:08:57 -0400
X-Spam-Score: -100.8
Message-ID: <51B30285.6020503@asianux.com>
Date: Sat, 08 Jun 2013 18:08:05 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: rth@twiddle.net, ink@jurassic.park.msu.ru, mattst88@gmail.com,
        "dhowells@redhat.com" <dhowells@redhat.com>, tony.luck@intel.com,
        fenghua.yu@intel.com, yasutake.koichi@jp.panasonic.com
CC: linux-alpha@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-ia64@vger.kernel.org, linux-am33-list@redhat.com,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: [Suggestion] arch/*/include/asm/bitops.h: about __set_bit() API.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maintainers:


Several architectures have different __set_bit() API to others, in
standard API, 2nd param of __set_bit() is 'unsigned long *', but:

  in 'min10300', it is 'unsigned char *',
  in 'ia64' and 'alpha', they are 'int' or 'unsigned int'.

If another sub-systems did not notice it, it may lead them to make
mistakes.

It seems related maintainer intended to implement it like that.

So could related maintainers provide the reason for it, so more guys
(e.g. me) can learn about it (at least can avoid related mistakes).


The related information in arch sub-system:

using 'unsigned char *':
  ./mn10300/include/asm/bitops.h:28:#define __set_bit(nr, addr)					\

using 'unsigned int *', implicitly: 
  ./ia64/include/asm/bitops.h:63:__set_bit (int nr, volatile void *addr)

using 'int *', implicitly: (need use 'unsigned', at least)
  ./alpha/include/asm/bitops.h:49:__set_bit(unsigned long nr, volatile void * addr)

using 'unsigned long *' implicitly:
  ./frv/include/asm/bitops.h:164:static inline void __set_bit(unsigned long nr, volatile void *addr)
  
standard API:  
  ./h8300/include/asm/bitops.h:74:#define __set_bit(nr,addr)    set_bit((nr),(addr))
  ./m68k/include/asm/bitops.h:67:#define __set_bit(nr, vaddr)	set_bit(nr, vaddr)
  ./arc/include/asm/bitops.h:293:static inline void __set_bit(unsigned long nr, volatile unsigned long *m)
  ./sh/include/asm/bitops-op32.h:20:static inline void __set_bit(int nr, volatile unsigned long *addr)
  ./hexagon/include/asm/bitops.h:151:static inline void __set_bit(int nr, volatile unsigned long *addr)
  ./s390/include/asm/bitops.h:212:static inline void __set_bit(unsigned long nr, volatile unsigned long *ptr)
  ./x86/include/asm/bitops.h:84:static inline void __set_bit(int nr, volatile unsigned long *addr)
  (others use 'generic')


Thanks.
-- 
Chen Gang

Asianux Corporation
