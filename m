Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451Ab3GPGxo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 02:53:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab3GPGxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 02:53:43 -0400
Date: Tue, 16 Jul 2013 08:56:27 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ortwin =?iso-8859-1?Q?Gl=FCck?= <odi@odi.ch>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [BUG] 3.10 regression: hang on suspend
Message-ID: <20130716065626.GA1587@redhat.com>
References: <51E4501D.3010001@odi.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51E4501D.3010001@odi.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mon, Jul 15, 2013 at 09:40:13PM +0200, Ortwin Glück wrote:
> My Samsung ultrabook hangs when suspending to RAM since this commit
> (bisected). Disabling wifi before suspend works around the issue.
> All works fine with 3.9.y.
> 
> 12e7f517029dad819c45eca9ca01fdb9ba57616b
> 
> Author: Stanislaw Gruszka <sgruszka@redhat.com>
> 
> Date:   Thu Feb 28 10:55:26 2013 +0100
> 
>     mac80211: cleanup generic suspend/resume procedures
> 
>     Since now we disconnect before suspend, various code which save
>     connection state can now be removed from suspend and resume
>     procedure. Cleanup on resume side is smaller as ieee80211_reconfig()
>     is also used for H/W restart.
> 
>     Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
>     Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Apparently this commit changed suspend procedure on mac80211, but it's
not obvious for me why it hangs :-(

What is your user space configuration (are you using NM or other
software or maybe just wpa_supplicant)? Are you using wowlan?
If you do add no_console_suspend boot parameter does it print some
diagnostic messages during suspend before the hang ?

Thanks
Stanislaw

