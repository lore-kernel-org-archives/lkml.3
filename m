Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbaF3HW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 03:22:58 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754405AbaF3HW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 03:22:57 -0400
Message-ID: <53B11047.3000105@nod.at>
Date: Mon, 30 Jun 2014 09:22:47 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: donb@securitymouse.com, markus@oberhumer.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: lzo1x_decompress_safe: Macro compares unsigned to 0  (NO_EFFECT)
References: <53b0f0f715b96_146f12c1338333fa@209.249.196.67.mail>
In-Reply-To: <53b0f0f715b96_146f12c1338333fa@209.249.196.67.mail>
X-Enigmail-Version: 1.6
X-Forwarded-Message-Id: <53b0f0f715b96_146f12c1338333fa@209.249.196.67.mail>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was introduced by:
commit 206a81c18401c0cde6e579164f752c4b147324ce
Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Fri Jun 20 22:00:53 2014 -0700

    lzo: properly check for overruns

Thanks,
//richard

-------- Original-Nachricht --------
Betreff: New Defects reported by Coverity Scan for Linux
Datum: Sun, 29 Jun 2014 22:09:11 -0700
Von: scan-admin@coverity.com


Hi,


Please find the latest report on new defect(s) introduced to Linux found with Coverity Scan.

Defect(s) Reported-by: Coverity Scan
Showing 1 of 1 defect(s)


** CID 1224102:  Macro compares unsigned to 0  (NO_EFFECT)
/lib/lzo/lzo1x_decompress_safe.c: 225 in lzo1x_decompress_safe()


________________________________________________________________________________________________________
*** CID 1224102:  Macro compares unsigned to 0  (NO_EFFECT)
/lib/lzo/lzo1x_decompress_safe.c: 225 in lzo1x_decompress_safe()
219     			op += t;
220     			ip += t;
221     		} else
222     #endif
223     		{
224     			NEED_IP(t, 3);
>>>     CID 1224102:  Macro compares unsigned to 0  (NO_EFFECT)
>>>     This greater-than-or-equal-to-zero comparison of an unsigned value is always true. "t + 0UL >= 0UL".
225     			NEED_OP(t, 0);
226     			while (t > 0) {
227     				*op++ = *ip++;
228     				t--;
229     			}
230     		}


________________________________________________________________________________________________________
To view the defects in Coverity Scan visit, http://scan.coverity.com/projects/128?tab=overview

To unsubscribe from the email notification for new defects, http://scan5.coverity.com/cgi-bin/unsubscribe.py





