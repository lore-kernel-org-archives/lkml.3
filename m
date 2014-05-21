Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbaEUOiE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 10:38:04 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10267 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaEUOiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 10:38:01 -0400
X-IronPort-AV: E=McAfee;i="5600,1067,7444"; a="36421049"
X-IronPort-AV: E=Sophos;i="4.98,880,1392192000"; 
   d="scan'208";a="669138114"
Date: Wed, 21 May 2014 20:08:34 +0530
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: Julian Calaby <julian.calaby@gmail.com>
CC: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linville <linville@tuxdriver.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        <ath9k-devel@venema.h4ckr.net>, netdev <netdev@vger.kernel.org>
Subject: Re: [ath9k-devel] randconfig build error with next-20140519, in
 drivers/net/wireless/ath/ath9k/dfs.c
Message-ID: <20140521143832.GA9563@qca.qualcomm.com>
References: <CA+r1ZhiM7EK08Y4kriXMugMc1Mbj5VDUPwKMq8-_k8Q8qhwPtw@mail.gmail.com>
 <20140521110143.GA2375@qca.qualcomm.com>
 <CAGRGNgXuS-ksFBAtmo8nLAPqPFKo2gHGDCsTcranU-k2-K3rfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGRGNgXuS-ksFBAtmo8nLAPqPFKo2gHGDCsTcranU-k2-K3rfg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 10:12:26PM +1000, Julian Calaby wrote:
> Hi Rajkumar,
> 
> On Wed, May 21, 2014 at 9:01 PM, Rajkumar Manoharan
> <rmanohar@qti.qualcomm.com> wrote:
> > On Mon, May 19, 2014 at 09:31:16AM -0700, Jim Davis wrote:
> >> Building with the attached random configuration file,
> >>
> >> In file included from drivers/net/wireless/ath/ath9k/eeprom.h:22:0,
> >>                  from drivers/net/wireless/ath/ath9k/hw.h:27,
> >>                  from drivers/net/wireless/ath/ath9k/dfs.c:18:
> >> drivers/net/wireless/ath/ath9k/dfs.c: In function ‘ath9k_dfs_process_phyerr’:
> >> drivers/net/wireless/ath/ath9k/dfs.c:185:14: error: ‘struct ath_softc’
> >> has no member named ‘debug’
> >>     pe.ts - sc->debug.stats.dfs_stats.last_ts);
> >>               ^
> >> drivers/net/wireless/ath/ath9k/../ath.h:273:41: note: in definition of
> >> macro ‘ath_dbg’
> >>    ath_printk(KERN_DEBUG, common, fmt, ##__VA_ARGS__); \
> >>                                          ^
> >> drivers/net/wireless/ath/ath9k/dfs.c:186:5: error: ‘struct ath_softc’
> >> has no member named ‘debug’
> >>    sc->debug.stats.dfs_stats.last_ts = pe.ts;
> >>      ^
> >> make[5]: *** [drivers/net/wireless/ath/ath9k/dfs.o] Error 1
> >
> > Please select CONFIG_ATH9K_DEBUGFS.
> 
> The point of randconfig builds is to ensure that there it's really
> unlikely that there are any config combinations that don't build, even
> if they're utterly insane.
> 
> You should really change the ath9k Kconfig rules or move or add ifdefs
> to prevent this from being possible.
>
Completely agree. But ath9k Kconfig has proper dependecy for
ATH9K_DFS_DEBUGFS. I am wondering how it is selected w/o ATH9K_DEBUGFS.

config ATH9K_DFS_DEBUGFS
        def_bool y
	depends on ATH9K_DEBUGFS && ATH9K_DFS_CERTIFIED

Should it be like this?

config ATH9K_DFS_DEBUGFS
	def_bool y if (ATH9K_DEBUGFS && ATH9K_DFS_CERTIFIED)

-Rajkumar
