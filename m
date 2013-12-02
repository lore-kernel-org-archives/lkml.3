Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab3LBF7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 00:59:42 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:53420 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab3LBF7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 00:59:39 -0500
Message-ID: <529C21C5.3030007@hitachi.com>
Date: Mon, 02 Dec 2013 14:59:33 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH 1/2] perf probe: Improve error message when function not
 found
References: <1385942827-11637-1-git-send-email-dsahern@gmail.com>
In-Reply-To: <1385942827-11637-1-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/02 9:07), David Ahern wrote:
> When requesting a function from a userspace library the error message to
> the user is less than helpful. e.g.,
> 
>     perf probe -x /lib64/libpthread-2.14.90.so -a 'lock_full=__pthread_mutex_lock_full'
>     no symbols found in /lib64/libpthread-2.14.90.so, maybe install a debug package?
>     Failed to load map.
>        Error: Failed to add events. (-22)
> 
> In this cae the symbol really does exist but is a local symbol which is
> filtered:
> 
>     nm /lib64/libpthread-2.14.90.so | grep __pthread_mutex_lock_full
>     0000000000005700 t __pthread_mutex_lock_full
> 
> With this patch:
>     perf probe -x /lib64/libpthread-2.14.90.so -a 'lock_full=__pthread_mutex_lock_full'
> 
>     no symbols found in /lib64/libpthread-2.14.90.so, maybe install a debug package?
>     Failed to find function in /lib64/libpthread-2.14.90.so. Perhaps it is a local variable?

Hmm, indeed current message is too less information, but your message looks
wired. I think just showing "Failed to find requested symbol in %s" is enough. :)

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


