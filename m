Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab3D2IAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 04:00:23 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:63403 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab3D2IAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 04:00:20 -0400
Message-ID: <1367222415.4656.61.camel@marge.simpson.net>
Subject: perf: report loops endlessly if record was killed via SIGTERM
From: Mike Galbraith <bitbucket@online.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Mon, 29 Apr 2013 10:00:15 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:QK1lEAzaUYKWxdzLWevSbDpsIbD1uxUh+ClNm9xY4ZX
 RaQbOUJheHaDedTXFnWP+rOFY6qg96enOTN6JuRp4DpZ8rJNo6
 ytmPGDQvSq1xU1ZtalD8xklHPZZPnS6D7JU/aoa7m/6P0Or/bz
 p2BRoH1e1ChubnTEL58gneFisnMLSJysno+5uYybuDPQtQOchF
 IKyBY4htACi4vDO5XOtvmtOXshfXLuA1PLIDJa/XJ10C0JVexB
 dIdW0D4gk6T07gPe9Okh4nEsFu9XdJMXAzuL7u0NHMHNgvK2Nu
 ZZHewpIWl09sOxGvsW3pH9bXMNd8uwEPvybJc55vEbtV5GwSSQ
 AYS812xWbqsv9FnGBUio7KK4MO+wFsmosk1yQelXbdfxwXYEPT
 w44PIDfuQufcw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boring notabug report, but..

(Dr. Dr., perf acts all dainbramaged when you shoot it in the head)

reproducer: perf record -a -g& sleep 1;whatever;killall perf

Discovered because AIM7 needs input, and does not run properly when
profiled via the more conventional perf record -a -g -- ./multitask -nl
-f.  Ergo, start perf record, run AIM7, kill perf.  Say SIGINT instead,
and it works as expected.  SIGTERM leaves perf.data in a bad state that
report can't deal with, but it'll happily keep trying forever.

Only mentioned because some other user might try to workaround input
nogo thingy and meet the same.

	-Mike

