Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268Ab3JIMI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 08:08:57 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:20190 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab3JIMIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 08:08:55 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-7d-5255475583e0
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v2 0/2] cpufreq: exynos: Fixes for v3.12
Date: Wed, 09 Oct 2013 14:08:41 +0200
Message-id: <1381320523-28183-1-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1380108138-30402-1-git-send-email-l.majewski@samsung.com>
References: <1380108138-30402-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsVy+t9jQd1Q99Agg47p5hYbZ6xntXja9IPd
	ovPsE2aLN4+4Ld483MxocXnXHDaLz71HGC1uN65gszhz+hKrxfoZr1ksNn71sJj7u5HVgcdj
	56y77B53ru1h81g37S2zx5ar7SwefVtWMXp83iQXwBbFZZOSmpNZllqkb5fAlTG5+Q5TwS/W
	it37T7E0MH5i6WLk5JAQMJGYdmM3M4QtJnHh3nq2LkYuDiGB6YwSi3tmQjldTBJr5m1nBali
	E9CT+Hz3KROILSIQKnF06ld2EJtZ4DizxM/lpiC2sICFxNqDPxm7GDk4WARUJfbP4wMxeQXc
	JJrnpUHskpd4er+PDcTmFHCXWL5+Ndh0IaCSIxfvsExg5F3AyLCKUTS1ILmgOCk910ivODG3
	uDQvXS85P3cTIzgUn0nvYFzVYHGIUYCDUYmH9wF/SJAQa2JZcWXuIUYJDmYlEV5fi9AgId6U
	xMqq1KL8+KLSnNTiQ4zSHCxK4rwHW60DhQTSE0tSs1NTC1KLYLJMHJxSDYz2l1Zuc1JQ+/Nk
	p9a9VBFehbil2iZ/pj5YbVB4NnHGldXb/tg4/fpYIF7oPP1+F0/u6k1ft82s/C7El/Y+j69v
	WRq3YCUf56frZqbPjF8wHfDeEPr85sI5BQe6Ur4EFqpstE2pYdwtHrJulsjHs5PE706b5izP
	eojrzIIX/W/lHbkqkoTyXioosRRnJBpqMRcVJwIArGMIzUECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Attached commits provide cpufreq regression fixes for Trats and Trats2
Exynos4 boards.
Since v3.12 Exynos4 uses common clock framework for clock manipulation.
Those patches restore correct output for cpuinfo_cur_freq [1] sysfs
attribute.
Without them, the [1] provides default frequency (800 MHz) set at driver
initialization.


Lukasz Majewski (2):
  cpufreq: exynos4x12: Use the common clock framework to set APLL clock
    rate
  cpufreq: exynos4210: Use the common clock framework to set APLL clock
    rate

 drivers/cpufreq/exynos4210-cpufreq.c |   67 ++++-----------------------------
 drivers/cpufreq/exynos4x12-cpufreq.c |   69 ++++------------------------------
 2 files changed, 16 insertions(+), 120 deletions(-)

-- 
1.7.10.4

