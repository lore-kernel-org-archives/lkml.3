Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbaAFJna (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 04:43:30 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:47105 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbaAFJn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 04:43:28 -0500
Message-ID: <52CA7ABB.4010401@gmail.com>
Date: Mon, 06 Jan 2014 11:43:23 +0200
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: cmahapatra@ti.com
CC: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        "pali.rohar@gmail.com" <pali.rohar@gmail.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: OMAPDSS: DISPC: horizontal timing too tight errors
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

commit 7faa92339bbb1e6b9a80983b206642517327eb75 "OMAPDSS: DISPC: Handle 
synclost errors in OMAP3" introduces some limits check to prevent 
SYNCLOST errors on OMAP3 in a specific usecase. The problem I see here 
(on Nokia N900, Maemo 5, linux 3.13-rc6, DSP accel video decoding) is 
that those checks effectively prevent fullscreen video playback of 
anything above lets say 640x350 with "horizontal timing too tight" 
errors spit in dmesg log. If I hack check_horiz_timing_omap3 function to 
always return true, I can happily play videos up to (and including) 720p 
resolutions, with no SYNCLOST errors.

So, a couple of questions:

Where do the values in static const u8 limits[3] come from? Are those 
documented somewhere?

Commit message says "This code is written based on code written by Ville 
Syrjälä <ville.syrjala@nokia.com> in Linux OMAP kernel.", is that code 
publicly available and where (if it is).

Besides compiling DSS driver with DEBUG enabled and providing the log 
(yeah, I know I should've done it already and have the logs included in 
this mail, but... :) ), is there anything else I can do to find the 
culprit for those errors.

Regards,
Ivo
