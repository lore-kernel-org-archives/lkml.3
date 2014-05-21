Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbaEUXb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 19:31:59 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:56344 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403AbaEUXb5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 19:31:57 -0400
MIME-Version: 1.0
In-Reply-To: <20140521143832.GA9563@qca.qualcomm.com>
References: <CA+r1ZhiM7EK08Y4kriXMugMc1Mbj5VDUPwKMq8-_k8Q8qhwPtw@mail.gmail.com>
 <20140521110143.GA2375@qca.qualcomm.com> <CAGRGNgXuS-ksFBAtmo8nLAPqPFKo2gHGDCsTcranU-k2-K3rfg@mail.gmail.com>
 <20140521143832.GA9563@qca.qualcomm.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 22 May 2014 09:31:36 +1000
Message-ID: <CAGRGNgW2kdG=CUdWpEbpxaVLhVvVg3MzHwkS_M=_Wmaju+q8dw@mail.gmail.com>
Subject: Re: [ath9k-devel] randconfig build error with next-20140519, in drivers/net/wireless/ath/ath9k/dfs.c
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Cc: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linville <linville@tuxdriver.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath9k-devel@venema.h4ckr.net, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rajkumar,

On Thu, May 22, 2014 at 12:38 AM, Rajkumar Manoharan
<rmanohar@qti.qualcomm.com> wrote:
> On Wed, May 21, 2014 at 10:12:26PM +1000, Julian Calaby wrote:
>> Hi Rajkumar,
>>
>> On Wed, May 21, 2014 at 9:01 PM, Rajkumar Manoharan
>> <rmanohar@qti.qualcomm.com> wrote:
>> > On Mon, May 19, 2014 at 09:31:16AM -0700, Jim Davis wrote:
>> >> Building with the attached random configuration file,
>> >>
>> >> In file included from drivers/net/wireless/ath/ath9k/eeprom.h:22:0,
>> >>                  from drivers/net/wireless/ath/ath9k/hw.h:27,
>> >>                  from drivers/net/wireless/ath/ath9k/dfs.c:18:
>> >> drivers/net/wireless/ath/ath9k/dfs.c: In function ‘ath9k_dfs_process_phyerr’:
>> >> drivers/net/wireless/ath/ath9k/dfs.c:185:14: error: ‘struct ath_softc’
>> >> has no member named ‘debug’
>> >>     pe.ts - sc->debug.stats.dfs_stats.last_ts);
>> >>               ^
>> >> drivers/net/wireless/ath/ath9k/../ath.h:273:41: note: in definition of
>> >> macro ‘ath_dbg’
>> >>    ath_printk(KERN_DEBUG, common, fmt, ##__VA_ARGS__); \
>> >>                                          ^
>> >> drivers/net/wireless/ath/ath9k/dfs.c:186:5: error: ‘struct ath_softc’
>> >> has no member named ‘debug’
>> >>    sc->debug.stats.dfs_stats.last_ts = pe.ts;
>> >>      ^
>> >> make[5]: *** [drivers/net/wireless/ath/ath9k/dfs.o] Error 1
>> >
>> > Please select CONFIG_ATH9K_DEBUGFS.
>>
>> The point of randconfig builds is to ensure that there it's really
>> unlikely that there are any config combinations that don't build, even
>> if they're utterly insane.
>>
>> You should really change the ath9k Kconfig rules or move or add ifdefs
>> to prevent this from being possible.
>>
> Completely agree. But ath9k Kconfig has proper dependecy for
> ATH9K_DFS_DEBUGFS. I am wondering how it is selected w/o ATH9K_DEBUGFS.
>
> config ATH9K_DFS_DEBUGFS
>         def_bool y
>         depends on ATH9K_DEBUGFS && ATH9K_DFS_CERTIFIED
>
> Should it be like this?
>
> config ATH9K_DFS_DEBUGFS
>         def_bool y if (ATH9K_DEBUGFS && ATH9K_DFS_CERTIFIED)

Zefir already posted a patch to fix this particular issue.

Judging by the patch, not all of the debugfs using code was properly
enclosed in #ifdefs.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
