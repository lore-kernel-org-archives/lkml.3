Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934424Ab3BTQkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 11:40:14 -0500
Received: from mout.perfora.net ([74.208.4.194]:61945 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933811Ab3BTQkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 11:40:12 -0500
Message-ID: <5124FB41.5000106@nctritech.com>
Date: Wed, 20 Feb 2013 11:35:13 -0500
From: Jody - Tritech Computer Solutions <jody@nctritech.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, andrew.wood@ivarch.com
Subject: CIFS 'cache=strict' breaks 'pv' utility
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:MMuAuO4bMhBLmLz6rmgfGYdTUaeVyfvg3fwctWmbtIf
 GRguN10GAtFnhbrvDwsUtIVnXJvKcHb+Qck3n40qWFMsWiwti/
 Imo0+X/BFNsN8DOndVk4dhYbj8q5BddgR+U+WWxBPTSIdaUIlk
 Z5ntScqFtfPL15UJmG++Dy4h1vuXyrqdeiswehAkIZgMzjvcDZ
 Fai3gcw9LwCNDgRgrvkxwaaFK/vvh7j0hg8ey88x9jxC0njeqU
 WMQkn+rl8gHLwKX8g+zgrtHcPbVkWmy707CduhvwAvIbcsna5x
 KeSD4IBfzAQ3B1GqIslxdMreReC7RLEXN7n6YfVUmQBpahdP9J
 Q/cI6ENsXmavca2eo1WXcolub21n2aqHUFZNeCxAK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

After the switch from 'cache=loose' to 'cache=strict' as the default 
CIFS cache mount option, I am unable to use the 'pv' utility in place of 
'cat' to read files beyond a certain size over CIFS. Mounting with 
'cache=loose' works around the problem, but does not change the 
breakage. If I mount with 'cache=strict' on 3.6.11 (the last stable 
kernel that works out-of-the-box) the breakage occurs again.

I hit this problem on 32-bit and 64-bit kernels, pv-1.2.0 and the latest 
pv-1.4.6, and the failure is tied to 'cache=strict' on all kernels from 
3.6.11 through 3.8.

My testing with a command such as 'pv /mnt/cifs/file.tar.xz | wc -c' 
indicates that 'pv' outputs the data up to a certain power-of-two point 
and then fails with "pv: (stdin): read failed: Input/output error". I 
have seen data stop transferring at 524288, 1048576, and 2097152 bytes 
when I tried feeding it various file sizes.

I am able to use 'pv' with files on CIFS mounted as 'cache=strict' if I 
reduce the buffer size on the command line (the -B xxx option) to 131072 
or lower, while setting a buffer of 262144 or higher always fails.

I am sending this to the LKML as well as the 'pv' maintainer, since I do 
not know the scope of the issue. If this exposes an unknown bug in the 
kernel CIFS driver, I don't want it to fly under the radar. I am 
available for testing and reporting as needed.

I don't subscribe to LKML, so please CC me on any responses.

--

Jody Lee Bruchon
Tritech Computer Solutions
