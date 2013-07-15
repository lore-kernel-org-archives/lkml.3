Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab3GOTzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 15:55:40 -0400
Received: from fep19.mx.upcmail.net ([62.179.121.39]:42574 "EHLO
	fep19.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476Ab3GOTzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 15:55:37 -0400
X-Greylist: delayed 919 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Jul 2013 15:55:36 EDT
X-SourceIP: 77.56.27.120
X-Authenticated-Sender: odi.ch@hispeed.ch
Message-ID: <51E4501D.3010001@odi.ch>
Date: Mon, 15 Jul 2013 21:40:13 +0200
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, sgruszka@redhat.com,
        linux-wireless@vger.kernel.org
Subject: [BUG] 3.10 regression: hang on suspend
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

My Samsung ultrabook hangs when suspending to RAM since this commit (bisected). 
Disabling wifi before suspend works around the issue. All works fine with 3.9.y.

12e7f517029dad819c45eca9ca01fdb9ba57616b 

Author: Stanislaw Gruszka <sgruszka@redhat.com> 

Date:   Thu Feb 28 10:55:26 2013 +0100

     mac80211: cleanup generic suspend/resume procedures

     Since now we disconnect before suspend, various code which save
     connection state can now be removed from suspend and resume
     procedure. Cleanup on resume side is smaller as ieee80211_reconfig()
     is also used for H/W restart.

     Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
     Signed-off-by: Johannes Berg <johannes.berg@intel.com>


Hardware:
01:00.0 Network controller: Intel Corporation Centrino Advanced-N 6235 (rev 24)

Sorry for not noticing this earlier.

Ortwin
