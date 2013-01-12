Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab3ALKTK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 05:19:10 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:57224 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab3ALKTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 05:19:09 -0500
Message-ID: <1357985943.6796.55.camel@marge.simpson.net>
Subject: Re: [RFC PATCH 0/2] sched: simplify the select_task_rq_fair()
From: Mike Galbraith <bitbucket@online.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        mingo@kernel.org, a.p.zijlstra@chello.nl
Date: Sat, 12 Jan 2013 11:19:03 +0100
In-Reply-To: <1357977704.6796.47.camel@marge.simpson.net>
References: <1356588535-23251-1-git-send-email-wangyun@linux.vnet.ibm.com>
	 <50ED384C.1030301@linux.vnet.ibm.com>
	 <1357977704.6796.47.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:beDufREb23K70HeRsSHlldSlmDtMAR8c0JN6o+ziVdf
 vNF8oHecSiL233oQ/CMtlke9PKuYUTjJd5C4DTEjv3DgvbI51A
 aZeF5m08GzsF704If65Tk8QSr/tygFZugQGLqFHW09YLkt/30s
 Vteqbkh7GctBMN6mAjSU77V8HQSZGTqnZzf5MqnD1yrxv7POg7
 +R0BYJwh1A5qeMSNp4YGPeYqTTkWpMDMPY1PLXpHRVt0QFcqjE
 +1oAghL+caLbVLv0DLsOzXUFLnbea5LJwWlPCF8qT82LTgTwYC
 rYgu1VKcghYf3FrpC8PbHpYxPHDyUpTVPnl6C3HoX4oiEXBaPB
 4fdFqBV8NHrnnSZvcvtWZahtBOPoVSl649CNXuPbUwepQe6k2y
 n0jOu80JzYjow==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


aim7 compute

Tasks    jobs/min  jti  jobs/min/task      real       cpu
    1      440.41  100       440.4070     13.76      3.65
    5     1923.81   99       384.7619     15.75     26.17
   10     4223.00   99       422.2997     14.35     41.66
   20     7632.24   87       381.6121     15.88     55.85
   40    16378.38   97       409.4595     14.80    169.63
   80    32934.78   99       411.6848     14.72    364.50
  160    63789.47   98       398.6842     15.20    398.55
  320   121200.00   98       378.7500     16.00    471.10
  640   213803.75   96       334.0684     18.14    640.05
 1280   323334.72   93       252.6053     23.99   1106.92
 2560   425846.83   87       166.3464     36.43   2097.59

+simplify select_task_rq_fair()

Tasks    jobs/min  jti  jobs/min/task      real       cpu
    1      441.37  100       441.3693     13.73      3.71
    5     1861.18   99       372.2359     16.28     28.87
   10     2777.27   99       277.7269     21.82     93.90
   20     4069.85   83       203.4923     29.78    140.40
   40     6500.40   69       162.5101     37.29    355.66
   80    31338.07   96       391.7259     15.47    316.10
  160    63207.30   98       395.0456     15.34    405.22
  320   122501.58   96       382.8174     15.83    450.57
  640   219863.95   91       343.5374     17.64    591.74
 1280   333339.06   84       260.4211     23.27   1045.13
 2560   428315.85   79       167.3109     36.22   2075.88

Hm, low end takes a big hit.


