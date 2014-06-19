Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274AbaFSUUB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 16:20:01 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:39072 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756957AbaFSUUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 16:20:00 -0400
Date: Thu, 19 Jun 2014 13:19:54 -0700
From: josh@joshtriplett.org
To: Johannes Stadlinger <Johannes.Stadlinger@fau.de>
Cc: devel@linuxdriverproject.org,
        Maximilian Eschenbacher <maximilian@eschenbacher.email>,
        linux-kernel@i4.cs.fau.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tugce Sirin <ztugcesirin@gmail.com>,
        Neil Armstrong <superna9999@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Vitaly Osipov <vitaly.osipov@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] wlan-ng/prism2sta:checkpatch: Fix long lines
Message-ID: <20140619201954.GF16404@cloud>
References: <1403205620-10219-1-git-send-email-Johannes.Stadlinger@fau.de>
 <1403205620-10219-6-git-send-email-Johannes.Stadlinger@fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403205620-10219-6-git-send-email-Johannes.Stadlinger@fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 09:20:18PM +0200, Johannes Stadlinger wrote:
> This patch fixes all warning of checkpatch about lines over 80
> characters.
> 
> Signed-off-by: Johannes Stadlinger <Johannes.Stadlinger@fau.de>
> Signed-off-by: Maximilian Eschenbacher <maximilian@eschenbacher.email>
> CC: linux-kernel@i4.cs.fau.de
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CC: Tugce Sirin <ztugcesirin@gmail.com>
> CC: Josh Triplett <josh@joshtriplett.org>
> CC: Neil Armstrong <superna9999@gmail.com>
> CC: Paul Gortmaker <paul.gortmaker@windriver.com>
> CC: Vitaly Osipov <vitaly.osipov@gmail.com>
> CC: devel@driverdev.osuosl.org
> CC: linux-kernel@vger.kernel.org

Most of these look fine, but...

> @@ -1271,7 +1275,8 @@ void prism2sta_processing_defer(struct work_struct *data)
>  				     HFA384x_RID_CURRENTSSID, result);
>  				return;
>  			}
> -			prism2mgmt_bytestr2pstr((struct hfa384x_bytestr *) &ssid,
> +			prism2mgmt_bytestr2pstr((struct hfa384x_bytestr *)
> +									&ssid,
>  						(p80211pstrd_t *) &
>  						wlandev->ssid);

...that (and the one in the subsequent context lines) looks horrible.
I'd suggest breaking after the opening parenthesis of the function call
and just indenting the arguments by one tab:
	foo_with_long_name(
		long_arg,
		another_long_arg);

Better yet, ignore checkpatch and format that call more readably as
though the 80 column rule didn't exist.
