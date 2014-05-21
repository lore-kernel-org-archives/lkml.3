Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbaEUOEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 10:04:20 -0400
Received: from mail.neratec.com ([46.140.151.2]:22837 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbaEUOES convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 10:04:18 -0400
X-Greylist: delayed 500 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 May 2014 10:04:17 EDT
Message-ID: <537CB066.1070803@neratec.com>
Date: Wed, 21 May 2014 15:55:50 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>,
        Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linville <linville@tuxdriver.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath9k-devel@venema.h4ckr.net, netdev <netdev@vger.kernel.org>
Subject: Re: [ath9k-devel] randconfig build error with next-20140519, in drivers/net/wireless/ath/ath9k/dfs.c
References: <CA+r1ZhiM7EK08Y4kriXMugMc1Mbj5VDUPwKMq8-_k8Q8qhwPtw@mail.gmail.com> <20140521110143.GA2375@qca.qualcomm.com> <CAGRGNgXuS-ksFBAtmo8nLAPqPFKo2gHGDCsTcranU-k2-K3rfg@mail.gmail.com>
In-Reply-To: <CAGRGNgXuS-ksFBAtmo8nLAPqPFKo2gHGDCsTcranU-k2-K3rfg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

sorry, I posted a related patch today ('[PATCH] ath9k: fix build error with
disabled debug'), but seems did not manage to set the correct in-reply-to field.


On 05/21/2014 02:12 PM, Julian Calaby wrote:
> Hi Rajkumar,
> 
> On Wed, May 21, 2014 at 9:01 PM, Rajkumar Manoharan
> <rmanohar@qti.qualcomm.com> wrote:
>> On Mon, May 19, 2014 at 09:31:16AM -0700, Jim Davis wrote:
>>> Building with the attached random configuration file,
>>>
>>> In file included from drivers/net/wireless/ath/ath9k/eeprom.h:22:0,
>>>                  from drivers/net/wireless/ath/ath9k/hw.h:27,
>>>                  from drivers/net/wireless/ath/ath9k/dfs.c:18:
>>> drivers/net/wireless/ath/ath9k/dfs.c: In function ‘ath9k_dfs_process_phyerr’:
>>> drivers/net/wireless/ath/ath9k/dfs.c:185:14: error: ‘struct ath_softc’
>>> has no member named ‘debug’
>>>     pe.ts - sc->debug.stats.dfs_stats.last_ts);
>>>               ^
>>> drivers/net/wireless/ath/ath9k/../ath.h:273:41: note: in definition of
>>> macro ‘ath_dbg’
>>>    ath_printk(KERN_DEBUG, common, fmt, ##__VA_ARGS__); \
>>>                                          ^
>>> drivers/net/wireless/ath/ath9k/dfs.c:186:5: error: ‘struct ath_softc’
>>> has no member named ‘debug’
>>>    sc->debug.stats.dfs_stats.last_ts = pe.ts;
>>>      ^
>>> make[5]: *** [drivers/net/wireless/ath/ath9k/dfs.o] Error 1
>>
>> Please select CONFIG_ATH9K_DEBUGFS.
> 
> The point of randconfig builds is to ensure that there it's really
> unlikely that there are any config combinations that don't build, even
> if they're utterly insane.
> 
> You should really change the ath9k Kconfig rules or move or add ifdefs
> to prevent this from being possible.
> 
> Thanks,
> 

